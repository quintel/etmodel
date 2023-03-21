# frozen_string_literal: true

require 'rails_helper'

# Required for class_double
require_relative '../../app/services/create_multi_year_chart'

describe MultiYearChartsController do
  describe '#create' do
    context 'when signed in and given a valid saved scenario ID' do
      let(:scenario) { create(:saved_scenario, end_year: 2050, user: user) }
      let(:user) { create(:user) }
      let(:myc) { create(:multi_year_chart, scenarios_count: 1) }

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
        expect(service).to have_received(:call).with(anything, scenario, user)
      end
    end

    context 'when signed in and given someone elses saved scenario ID' do
      let(:scenario) { create(:saved_scenario, end_year: 2050) }

      before { sign_in create(:user) }

      it 'raises a Not Found error' do
        post(:create, params: { scenario_id: scenario.id })
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when signed in and the CreateMultiYearChart service fails' do
      let(:scenario) { create(:saved_scenario, end_year: 2050, user: user) }
      let(:api_scenario) { build(:engine_scenario) }
      let(:user) { create(:user) }

      let!(:service) { class_double('CreateMultiYearChart').as_stubbed_const }

      before do
        sign_in user

        allow(service).to receive(:call).and_return(ServiceResult.failure(
          "That didn't work."
        ))

        allow(FetchAPIScenario).to receive(:call)
          .with(anything, scenario.scenario_id).and_return(api_scenario)

        allow(Engine::Scenario).to receive(:batch_load).and_return([api_scenario])
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
        expect(service).to have_received(:call).with(anything, scenario, user)
      end
    end

    context 'when not signed in signed in' do
      let(:scenario) { build(:engine_scenario) }

      it 'shows a sign-in prompt' do
        post :create, params: { scenario_id: scenario.id }
        expect(response).to be_forbidden
      end
    end
  end

  describe '#destroy' do
    let!(:service) { class_double('DeleteMultiYearChart').as_stubbed_const }

    context 'when the MYC belongs to the logged-in user' do
      let(:myc) { create(:multi_year_chart) }

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
        expect(service).to have_received(:call).with(anything, myc)
      end
    end

    context 'when the MYC belongs to a different user' do
      let(:myc) { create(:multi_year_chart) }

      before do
        sign_in create(:user)
      end

      it 'raises RecordNotFound' do
        delete :destroy, params: { id: myc.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not signed in signed in' do
      let(:myc) { create(:multi_year_chart) }

      it 'shows the sign-in prompt' do
        delete :destroy, params: { id: myc.id }
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PUT discard' do
    let(:scenario) { create(:saved_scenario, end_year: 2050, user: user) }
    let(:user) { create(:user) }
    let(:myc) { create(:multi_year_chart, scenarios_count: 1) }

    before do
      sign_in(myc.user)
      session[:setting] = Setting.new
    end

    context 'with an owned myc' do
      before do
        post(:discard, params: { id: myc.id })
      end

      it 'redirects to the scenario listing' do
        expect(response).to be_redirect
      end

      it 'soft-deletes the scenario' do
        expect(myc.reload).to be_discarded
      end
    end

    context 'with an unowned myc' do
      before do
        sign_in create(:user)
        post(:discard, params: { id: myc.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not soft-delete the myc' do
        expect(myc.reload).not_to be_discarded
      end
    end

    context 'with a myc ID that does not exist' do
      before do
        post(:discard, params: { id: 99_999 })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end

  describe 'PUT undiscard' do
    let(:scenario) { create(:saved_scenario, end_year: 2050, user: user) }
    let(:user) { create(:user) }
    let(:myc) { create(:multi_year_chart, scenarios_count: 1) }

    before do
      sign_in(myc.user)
      session[:setting] = Setting.new
    end

    context 'with an owned myc' do
      before do
        myc.discard!
        post(:undiscard, params: { id: myc.id })
      end

      it 'redirects to the myc listing' do
        expect(response).to be_redirect
      end

      it 'removes the soft-deletion of the myc' do
        expect(myc.reload).not_to be_discarded
      end
    end

    context 'with an unowned myc' do
      before do
        myc.discard!
        sign_in create(:user)
        post(:undiscard, params: { id: myc.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not remove the soft-deletion of the myc' do
        expect(myc.reload).to be_discarded
      end
    end

    context 'with a myc ID that does not exist' do
      before do
        post(:undiscard, params: { id: 99_999 })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end
end
