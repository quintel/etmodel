require 'rails_helper'

describe SavedScenarioReportsController, vcr: true do
  let(:user) { FactoryBot.create :user }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }

  describe 'GET show' do
    context 'ovm.csv' do
      before(:each){ get :show, params: { report_name: 'ovm.csv',
                                          saved_scenario_id: user_scenario.id } }
      it 'has yml' do
        expect(assigns(:yml)).to_not be_empty
      end
      it 'has queries' do
        expect(assigns(:queries)).to_not be_empty
      end
      it 'has an api_response with queries' do
        expect(assigns(:query_api_response)).to_not be_empty
      end
    end
  end
end
