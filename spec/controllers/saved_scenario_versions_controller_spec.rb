require 'rails_helper'

describe SavedScenarioVersionsController do
  render_views

  let(:scenario_mock) { ete_scenario_mock }

  before do
    allow(user_scenario).to receive(:scenario).and_return(scenario_mock)
    allow(admin_scenario).to receive(:scenario).and_return(scenario_mock)
  end

  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }
  let!(:admin_scenario) { FactoryBot.create :saved_scenario, user: admin, id: 648696 }
  let!(:user_first_scenario_version) { FactoryBot.create :saved_scenario_version, saved_scenario: user_scenario }
  let!(:user_current_scenario_version) { FactoryBot.create :saved_scenario_version, saved_scenario: user_scenario }
  let!(:admin_first_scenario_version) { FactoryBot.create :saved_scenario_version, saved_scenario: admin_scenario }
  let!(:admin_current_scenario_version) { FactoryBot.create :saved_scenario_version, saved_scenario: admin_scenario }

  describe 'POST create' do
    before do
      sign_in(user)
    end

    context 'with valid attributes' do
      let(:request) do
        post :create, params: {
          saved_scenario_id: user_scenario.id,
          saved_scenario_version: {
            scenario_id: scenario_mock.id,
            message: 'A new scenario version!'
          }
        }
      end

      it 'creates a new SavedScenarioVersion' do
        expect { request }.to change(SavedScenarioVersion, :count).by(1)
      end

      it 'sets the proper attributes' do
        request

        expect(SavedScenarioVersion.last.attributes).to include(
          'user_id' => user.id,
          'saved_scenario_id' => user_scenario.id,
          'scenario_id' => scenario_mock.id.to_i,
          'message' => 'A new scenario version!'
        )
      end

      it 'returns 200 OK' do
        request

        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid attributes' do
      let(:request) do
        post :create, params: {
          saved_scenario_id: user_scenario.id,
          saved_scenario_version: {
            scenario_id: scenario_mock.id
          }
        }
      end

      it 'does not create a new SavedScenario' do
        expect { request }.not_to change(SavedScenarioVersion, :count)
      end

      it 'returns 422 Unprocessable Entity' do
        request

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET revert' do
    before do
      sign_in(user)
    end

    context 'with an owned saved scenario' do
      before do
        get(:revert, params: { saved_scenario_id: user_scenario.id, id: user_first_scenario_version.id })
      end

      it 'redirects to the saved scenario show page' do
        expect(response).to be_redirect
      end

      it 'removes any future scenario versions' do
        expect(user_scenario.saved_scenario_versions.count).to eq(1)
      end
    end

    context 'with an unowned saved scenario' do
      before do
        get(:revert, params: { saved_scenario_id: admin_scenario.id, id: admin_first_scenario_version.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not remove future scenario versions' do
        expect(user_scenario.saved_scenario_versions.count).to eq(2)
      end
    end

    context 'with a saved scenario version ID that does not exist' do
      before do
        get(:revert, params: { saved_scenario_id: user_scenario.id, id: 9999 })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end
end
