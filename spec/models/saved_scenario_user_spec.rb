require 'rails_helper'

describe SavedScenarioUser do
  let(:saved_scenario) { create(:saved_scenario) }

  it { is_expected.to validate_inclusion_of(:role_id).in_array(User::ROLES.keys) }

  it { is_expected.to belong_to(:saved_scenario) }
  it { is_expected.to belong_to(:user).optional }

  it 'validates on_save with user_email and no user_id set' do
    expect do
      create(:saved_scenario_user,
        saved_scenario: saved_scenario,
        user: nil,
        user_email: 'test@test.com'
      )
    end.to_not raise_error
  end

  it 'validates on_save with user_id and no user_email set' do
    expect do
      create(:saved_scenario_user,
        saved_scenario: saved_scenario,
        user: create(:user)
      )
    end.to_not raise_error
  end

  it 'allows updating the role if not the last scenario owner' do
    # The first user added will automatically become the scenario owner
    saved_scenario.user = create(:user)
    saved_scenario_user = create(
      :saved_scenario_user,
      saved_scenario: saved_scenario,
      role_id: User::ROLES.key(:scenario_owner)
    )

    saved_scenario_user.update(role_id: User::ROLES.key(:scenario_viewer))

    expect(
      saved_scenario_user.reload.role_id
    ).to be(User::ROLES.key(:scenario_viewer))
  end

  it 'allows destroying a record if not the last scenario owner' do
    # The first user added will automatically become the scenario owner
    saved_scenario.user = create(:user)
    saved_scenario_user = create(
      :saved_scenario_user,
      saved_scenario: saved_scenario,
      role_id: User::ROLES.key(:scenario_owner)
    )

    saved_scenario_user.destroy

    expect(
      saved_scenario.saved_scenario_users.count
    ).to be(1)
  end

  it 'raises an error when validating an incorrect email address' do
    expect do
      create(:saved_scenario_user,
        saved_scenario: saved_scenario,
        user: nil,
        user_email: 'test'
      )
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'raises an error when both user and email address are present' do
    expect do
      create(:saved_scenario_user,
        saved_scenario: saved_scenario,
        user: create(:user),
        user_email: 'test@test.com'
      )
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cancels an update action for the last owner of a scenario' do
    # The first user added will automatically become the scenario owner
    saved_scenario.user = create(:user)

    saved_scenario_user = saved_scenario.saved_scenario_users.first
    saved_scenario_user.update(role_id: User::ROLES.key(:scenario_viewer))

    expect(
      saved_scenario_user.reload.role_id
    ).to be(User::ROLES.key(:scenario_owner))
  end

  it 'cancels a destroy action for the last owner of a scenario if other users are present' do
    owner = create(:saved_scenario_user, saved_scenario: saved_scenario, role_id: User::ROLES.key(:scenario_owner))
    viewer = create(:saved_scenario_user, saved_scenario: saved_scenario, role_id: User::ROLES.key(:scenario_viewer))

    owner.destroy

    expect(owner.reload).to_not be(nil)
  end

  it 'cancels the destroy action for the last owner of a scenario if its the last user' do
    owner = create(
      :saved_scenario_user,
      saved_scenario: saved_scenario,
      role_id: User::ROLES.key(:scenario_owner)
    )
    owner.destroy

    expect(
      saved_scenario.saved_scenario_users.count
    ).to be(1)
  end

  context 'when destroying the saved scenario' do
    subject { saved_scenario.destroy }

    before { saved_scenario_user }

    let(:saved_scenario_user) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        role_id: User::ROLES.key(:scenario_owner),
        id: 123_778
      )
    end

    it 'is successful' do
      expect(subject.errors).to be_empty
    end

    it 'allows the saved scenario to be destroyed' do
      expect { subject }.to change(saved_scenario, :persisted?).from(true).to(false)
    end

    it 'also destroys the saved scenario users' do
      subject
      expect { saved_scenario_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
