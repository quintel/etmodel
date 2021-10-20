# frozen_string_literal: true

require 'rails_helper'

# Required for class_double
require_relative '../../app/services/create_multi_year_chart'

describe MultiYearChartsController do
  describe '#create' do
    context 'when signed in and given a valid API scenario ID' do
      let(:scenario) { FactoryBot.build(:api_scenario, id: 1) }
      let(:user) { FactoryBot.create(:user) }
      let(:myc) { FactoryBot.create(:multi_year_chart, scenarios_count: 1) }

      let!(:service) { class_double('CreateMultiYearChart').as_stubbed_const }

      before do
        login_as user

        allow(service).to receive(:call).and_return(ServiceResult.success(myc))

        allow(Api::Scenario).to receive(:find)
          .with(scenario.id).and_return(scenario)
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

    context 'when signed in and the CreateMultiYearChart service fails' do
      let(:scenario) { FactoryBot.build(:api_scenario, id: 1) }
      let(:user) { FactoryBot.create(:user) }

      let!(:service) { class_double('CreateMultiYearChart').as_stubbed_const }

      before do
        login_as user

        allow(service).to receive(:call).and_return(ServiceResult.failure(
          "That didn't work."
        ))

        allow(Api::Scenario).to receive(:find)
          .with(scenario.id).and_return(scenario)
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

      it 'redirects to the login page' do
        post :create, params: { scenario_id: scenario.id }
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe '#destroy' do
    let!(:service) { class_double('DeleteMultiYearChart').as_stubbed_const }

    context 'when the MYC belongs to the logged-in user' do
      let(:myc) { FactoryBot.create(:multi_year_chart) }

      before do
        allow(service).to receive(:call).and_return(ServiceResult.success)
        login_as myc.user
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
        login_as FactoryBot.create(:user)
      end

      it 'raises RecordNotFound' do
        expect { delete :destroy, params: { id: myc.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when not signed in signed in' do
      let(:myc) { FactoryBot.create(:multi_year_chart) }

      it 'redirects to the login page' do
        delete :destroy, params: { id: myc.id }
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
