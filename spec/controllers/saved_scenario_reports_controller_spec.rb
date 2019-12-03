require 'rails_helper'

describe SavedScenarioReportsController, vcr: true do
  let(:user) { FactoryBot.create :user }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }

  describe 'GET show' do

    context 'ovm.csv' do
      before(:each){ get :show, params: { report_name: 'ovm.csv',
                                          saved_scenario_id: user_scenario.id } }

      it 'has name' do
        expect(assigns(:report_name)).to eq 'ovm'
      end

      it 'has yml' do
        expect(assigns(:yml)).to_not be_empty
      end

      it 'has queries' do
        expect(assigns(:queries)).to_not be_empty
      end

      it 'has a response' do
        expect(assigns(:response)).to eq 3
      end
    end
  end




end