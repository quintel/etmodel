require 'rails_helper'

describe SavedScenarioUsersController do
  render_views

  before do
    # Disable relaying ScenarioUserUpdates to ETEngine
    allow(CreateAPIScenarioUser).to receive(:call).and_return(ServiceResult.success)
    allow(UpdateAPIScenarioUser).to receive(:call).and_return(ServiceResult.success)
    allow(DestroyAPIScenarioUser).to receive(:call).and_return(ServiceResult.success)
  end

  let(:saved_scenario) { FactoryBot.create :saved_scenario, id: 648691 }

  # Non logged-in users should always receive 404 not-found responses
  # when attempting to perform an action on SavedScenarioUsers.
  describe 'a non-logged in visitor' do
    let(:user) { FactoryBot.create(:user) }
    let!(:scenario_owner) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        user: user,
        role_id: User::ROLES.key(:scenario_owner)
      )
    end

    it 'cannot view the list of users for a saved scenario' do
      get(:index, params: { saved_scenario_id: saved_scenario.id })

      expect(response).to have_http_status(404)
    end

    it 'cannot add a new user to a scenario' do
      post(:create, format: :js, params: {
        saved_scenario_id: saved_scenario.id,
        user_email: 'test@test.com',
        role_id: User::ROLES.key(:scenario_owner)
      })

      expect(response).to have_http_status(404)
    end

    it 'cannot update an existing scenario user' do
      put(:update, format: :js, params: {
        saved_scenario_id: saved_scenario.id,
        id: scenario_owner.id,
        saved_scenario_user: {
          role_id: User::ROLES.key(:scenario_viewer)
        }
      })

      expect(response).to have_http_status(404)
    end

    it 'cannot remove an existing scenario user' do
      delete(:destroy, params: {
        saved_scenario_id: saved_scenario.id,
        id: scenario_owner.id
      })

      expect(response).to have_http_status(404)
    end
  end

  describe 'a scenario user' do
    let(:saved_scenario) { FactoryBot.create :saved_scenario, id: 648692 }
    let(:user_viewer) { FactoryBot.create :user }
    let(:user_collaborator) { FactoryBot.create :user }
    let(:user_owner) { FactoryBot.create :user }
    let!(:scenario_viewer) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        user: user_viewer,
        role_id: User::ROLES.key(:scenario_viewer)
      )
    end
    let!(:scenario_collaborator) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        user: user_collaborator,
        role_id: User::ROLES.key(:scenario_collaborator)
      )
    end
    let!(:scenario_owner) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        user: user_owner,
        role_id: User::ROLES.key(:scenario_owner)
      )
    end

    context 'with the viewer role' do
      before do
        sign_in user_viewer
        session[:setting] = Setting.new
      end

      it 'is redirected when attempting to view the list of users for a saved scenario' do
        get(:index, params: { saved_scenario_id: saved_scenario.id })

        expect(response).to have_http_status(404)
      end

      it 'is redirected when attempting to add a new user to a scenario' do
        post(:create, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          saved_scenario_user: {
            user_email: 'test@test.com',
            role_id: User::ROLES.key(:scenario_viewer)
          }
        })

        expect(response).to have_http_status(404)
      end

      it 'is redirected when attempting to update an existing scenario user' do
        put(:update, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_owner.id,
          saved_scenario_user: {
            role_id: User::ROLES.key(:scenario_viewer)
          }
        })

        expect(response).to have_http_status(404)
      end

      it 'is redirected when attempting to remove an existing scenario user' do
        delete(:destroy, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_owner.id
        })

        expect(response).to have_http_status(404)
      end
    end

    context 'with the collaborator role' do
      before do
        sign_in user_collaborator
        session[:setting] = Setting.new
      end

      it 'is redirected when attempting to view the list of users for a saved scenario' do
        get(:index, params: { saved_scenario_id: saved_scenario.id })

        expect(response).to have_http_status(404)
      end

      it 'is redirected when attempting to add a new user to a scenario' do
        post(:create, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          saved_scenario_user: {
            user_email: 'test@test.com',
            role_id: User::ROLES.key(:scenario_owner)
          }
        })

        expect(response).to have_http_status(404)
      end

      it 'is redirected when attempting to update an existing scenario user' do
        put(:update, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_owner.id,
          saved_scenario_user: {
            role_id: User::ROLES.key(:scenario_viewer)
          }
        })

        expect(response).to have_http_status(404)
      end

      it 'is redirected when attempting to remove an existing scenario user' do
        delete(:destroy, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_owner.id
        })

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'a scenario owner' do
    let(:user) { FactoryBot.create :user }
    let(:saved_scenario) { FactoryBot.create :saved_scenario, id: 648694 }
    let!(:scenario_owner) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        user: user,
        role_id: User::ROLES.key(:scenario_owner)
      )
    end

    before do
      sign_in user
      session[:setting] = Setting.new
    end

    it 'can view the list of users for a saved scenario' do
      get(:index, params: { saved_scenario_id: saved_scenario.id })

      expect(response).to have_http_status(200)
    end

    it 'can add a new user to a scenario' do
      post(:create, format: :js, params: {
        saved_scenario_id: saved_scenario.id,
        saved_scenario_user: {
          user_email: 'test@test.com',
          role_id: User::ROLES.key(:scenario_owner)
        }
      })

      expect(
        saved_scenario.saved_scenario_users.where(user_email: 'test@test.com').count
      ).to be(1)
    end

    context 'when updating or removing an existing scenario user' do
      let(:scenario_viewer) do
        FactoryBot.create(
          :saved_scenario_user,
          saved_scenario: saved_scenario,
          user: nil, user_email: 'test@test.com',
          role_id: User::ROLES.key(:scenario_viewer)
        )
      end

      it 'can update the role' do
        # Promote viewer to owner!
        put(:update, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_viewer.id,
          saved_scenario_user: {
            role_id: User::ROLES.key(:scenario_owner)
          }
        })

        expect(
          saved_scenario.saved_scenario_users.find_by(user_email: 'test@test.com')&.role_id
        ).to eq(
            User::ROLES.key(:scenario_owner)
        )
      end

      it 'can remove the user' do
        delete(:destroy, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_viewer.id
        })

        expect(
          saved_scenario.saved_scenario_users.where(user_email: 'test@test.com').count
        ).to be(0)
      end
    end

    it "cannot change its own role if it's the last owner" do
      put(:update, format: :js, params: {
        saved_scenario_id: saved_scenario.id,
        id: scenario_owner.id,
        saved_scenario_user: {
          role_id: User::ROLES.key(:scenario_viewer)
        }
      })

      expect(
        saved_scenario.saved_scenario_users.where(role_id: User::ROLES.key(:scenario_owner)).count
      ).to be(1)
    end
  end

  describe 'an admin user' do
    let(:admin) { FactoryBot.create :admin }
    let(:saved_scenario) { FactoryBot.create :saved_scenario, id: 648695 }
    let!(:scenario_owner) do
      FactoryBot.create(
        :saved_scenario_user,
        saved_scenario: saved_scenario,
        role_id: User::ROLES.key(:scenario_owner)
      )
    end

    before do
      sign_in admin
      session[:setting] = Setting.new
    end

    it 'can not view the list of users for a saved scenario' do
      get(:index, params: { saved_scenario_id: saved_scenario.id })

      expect(response).to have_http_status(404)
    end

    it 'can not add a new user to a scenario' do
      post(:create, format: :js, params: {
        saved_scenario_id: saved_scenario.id,
        saved_scenario_user: {
          user_email: 'test@test.com',
          role_id: User::ROLES.key(:scenario_owner)
        }
      })

      expect(
        saved_scenario.saved_scenario_users.where(user_email: 'test@test.com').count
      ).to be(0)
    end

    context 'when updating or removing an existing scenario user' do
      let(:scenario_viewer) do
        FactoryBot.create(
          :saved_scenario_user,
          saved_scenario: saved_scenario,
          user: nil, user_email: 'test@test.com',
          role_id: User::ROLES.key(:scenario_viewer)
        )
      end

      it 'can not update the role' do
        # Promote to owner!
        put(:update, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_viewer.id,
          saved_scenario_user: {
            role_id: User::ROLES.key(:scenario_owner)
          }
        })

        expect(
          saved_scenario.saved_scenario_users.find_by(user_email: 'test@test.com')&.role_id
        ).to eq(
          User::ROLES.key(:scenario_viewer)
        )
      end

      it 'can not remove the user' do
        delete(:destroy, format: :js, params: {
          saved_scenario_id: saved_scenario.id,
          id: scenario_viewer.id
        })

        expect(
          saved_scenario.saved_scenario_users.where(user_email: 'test@test.com').count
        ).to be(1)
      end
    end
  end
end
