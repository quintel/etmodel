# frozen_string_literal: true

require 'rails_helper'

describe SavedScenarioReportsController, vcr: true do
  pending "SHOULD BE REMOVED OR PORTED"

  # let(:user) { create :user }
  # let!(:user_scenario) { create :saved_scenario, user: user }

  # describe 'GET show' do
  #   context 'ovm.csv' do
  #     before do
  #       get :show, format: :csv,
  #         params: { report_name: 'ovm', saved_scenario_id: user_scenario.id }
  #     end

  #     it 'responds with 200 OK' do
  #       expect(response).to have_http_status(:ok)
  #     end

  #     it 'has a report_template' do
  #       expect(assigns(:report_template)).not_to be_empty
  #     end

  #     it 'has queries' do
  #       expect(assigns(:queries)).not_to be_empty
  #     end
  #   end

  #   context 'when the scenario does not exist or is inaccessible' do
  #     before do
  #       allow(FetchAPIScenarioQueries).to receive(:call).and_return(
  #         ServiceResult.failure('Scenario not found')
  #       )

  #       get :show, format: :csv,
  #         params: { report_name: 'ovm', saved_scenario_id: user_scenario.id }
  #     end

  #     it 'responds with 404 Not found' do
  #       expect(response).to have_http_status(:not_found)
  #     end
  #   end
  # end
end
