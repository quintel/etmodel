# frozen_string_literal: true

require 'rails_helper'

describe SavedScenarioHistoryController, vcr: true do
  render_views

  let(:user) { create(:user) }
  let(:saved_scenario) { create(:saved_scenario, user: user, scenario_id: 123, scenario_id_history: [111, 122]) }

  before do
    allow(UpdateAPIScenarioVersionTag).to receive(:call).and_return(ServiceResult.success)
    allow(FetchSavedScenarioVersionTags).to receive(:call).and_return(ServiceResult.success(
      {
        "123" => { 'user_id' => user.id, description: 'my last version' },
        "122" => {},
        "111" => {}
      }
    ))
  end

  context 'with a user that owns the scenario' do
    before do
      sign_in user
      session[:setting] = Setting.new
    end

    describe 'GET index' do
      context 'as json' do
        before do
          get :index, format: :json, params: {
            saved_scenario_id: saved_scenario.id
          }
        end

        it 'is succesful' do
          expect(response).to be_ok
        end

        it 'contains the scenario versions of the full histoty' do
          expect(JSON.parse(response.body)).to include({
            'description' => 'my last version', 'scenario_id' => 123, 'user' => user.name
          })
        end
      end
    end

    describe 'PUT update' do
      before do
        put :update, format: :json, params: {
          saved_scenario_id: saved_scenario.id,
          scenario_id: 123,
          description: 'my update'
        }
      end

      it 'is succesful' do
        expect(response).to be_ok
      end
    end
  end
end
