# frozen_string_literal: true

require 'rails_helper'

# Required for class_double
require_relative '../../app/services/create_multi_year_chart'

describe MultiYearChartsController do
  describe '#create' do
    context 'when signed in and given a valid saved scenario ID' do
      let(:scenario) { FactoryBot.create(:saved_scenario, end_year: 2050, user: user) }
      let(:user) { FactoryBot.create(:user) }
      let(:myc) { FactoryBot.create(:multi_year_chart, scenarios_count: 1) }

      let!(:service) { class_double('CreateMultiYearChart').as_stubbed_const }

      before do
        sign_in user

        allow(service).to receive(:call).and_return(ServiceResult.success(myc))
      end

      it 'redirects to the MYC app' do
        post :create, params: { scenario_id: scenario.id }

        expect(response).to redirect_to(
          %r{^#{Settings.multi_year_charts_url}/#{myc.redirect_slug}}
        )
      end

      it 'calls the CreateMultiYearChart service' do
        post :create, params: { scenario_id: scenario.id }
        expect(service).to have_received(:call).with(scenario, user)
      end
    end

    context 'when signed in and given someone elses saved scenario ID' do
      let(:scenario) { FactoryBot.create(:saved_scenario, end_year: 2050) }

      before { sign_in FactoryBot.create(:user) }

      it 'raises a Not Found error' do
        expect { post(:create, params: { scenario_id: scenario.id }) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when signed in and the CreateMultiYearChart service fails' do
      let(:scenario) { FactoryBot.create(:saved_scenario, end_year: 2050, user: user) }
      let(:api_scenario) { FactoryBot.build(:api_scenario) }
      let(:user) { FactoryBot.create(:user) }

      let!(:service) { class_double('CreateMultiYearChart').as_stubbed_const }

      before do
        sign_in user

        allow(service).to receive(:call).and_return(ServiceResult.failure(
          "That didn't work."
        ))

        allow(Api::Scenario).to receive(:find)
          .with(scenario.scenario_id).and_return(api_scenario)

        allow(Api::Scenario).to receive(:batch_load).and_return([api_scenario])
      end

      it 'fails the request with a 422 code' do
        post :create, params: { scenario_id: scenario.id }
        expect(response.status).to eq(422)
      end

      it 'renders the index' do
        post :create, params: { scenario_id: scenario.id }
        expect(response).to render_template(:index)
      end

      it 'sets the error message in the flash' do
        post :create, params: { scenario_id: scenario.id }
        expect(flash[:error]).to eq("That didn't work.")
      end

      it 'calls the CreateMultiYearChart service' do
        post :create, params: { scenario_id: scenario.id }
        expect(service).to have_received(:call).with(scenario, user)
      end
    end

    context 'when not signed in signed in' do
      let(:scenario) { FactoryBot.build(:api_scenario, id: 1) }

      it 'shows a sign-in prompt' do
        post :create, params: { scenario_id: scenario.id }
        expect(response).to be_forbidden
      end
    end
  end

  describe '#destroy' do
    let!(:service) { class_double('DeleteMultiYearChart').as_stubbed_const }

    context 'when the MYC belongs to the logged-in user' do
      let(:myc) { FactoryBot.create(:multi_year_chart) }

      before do
        allow(service).to receive(:call).and_return(ServiceResult.success)
        sign_in myc.user
      end

      it 'redirects to the MYC root' do
        delete :destroy, params: { id: myc.id }
        expect(response).to redirect_to(multi_year_charts_url)
      end

      it 'calls the DeleteMultiYearChart service' do
        delete :destroy, params: { id: myc.id }
        expect(service).to have_received(:call).with(myc)
      end
    end

    context 'when the MYC belongs to a different user' do
      let(:myc) { FactoryBot.create(:multi_year_chart) }

      before do
        sign_in FactoryBot.create(:user)
      end

      it 'raises RecordNotFound' do
        expect { delete :destroy, params: { id: myc.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when not signed in signed in' do
      let(:myc) { FactoryBot.create(:multi_year_chart) }

      it 'shows the sign-in prompt' do
        delete :destroy, params: { id: myc.id }
        expect(response).to be_forbidden
      end
    end
  end
end
