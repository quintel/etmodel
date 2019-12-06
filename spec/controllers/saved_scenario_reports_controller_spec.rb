# frozen_string_literal: true

require 'rails_helper'

describe SavedScenarioReportsController, vcr: true do
  let(:user) { FactoryBot.create :user }
  let!(:user_scenario) do
    FactoryBot.create :saved_scenario, user: user
  end

  describe 'GET show' do
    context 'ovm.csv' do
      before(:each) do
        get :show,
            format: :csv,
            params: { report_name: 'ovm', saved_scenario_id: user_scenario.id }
      end

      subject { response }

      it { is_expected.to have_http_status(200) }

      it 'has a report_template' do
        expect(assigns(:report_template)).to_not be_empty
      end

      it 'has queries' do
        expect(assigns(:queries)).to_not be_empty
      end
    end
  end
end
