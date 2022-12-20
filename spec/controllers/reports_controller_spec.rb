# frozen_string_literal: true

require 'rails_helper'

describe ReportsController, vcr: true do
  render_views

  describe '#show' do
    context 'without an active scenario' do
      subject { response }

      before { get(:show, params: { id: 'sample' }) }

      it 'starts a new scenario' do
        expect(response.body).to include('"api_session_id":null')
      end

      it { is_expected.to be_successful }
      it { is_expected.to render_template(:show) }
    end

    context 'with an active scenario' do
      subject { response }

      before do
        session[:setting] = Setting.new(api_session_id: 648_695)
        get :show, params: { id: 'sample' }
      end

      it { is_expected.to be_successful }
      it { is_expected.to render_template(:show) }

      it 'uses the scenario' do
        expect(subject.body).to include('"api_session_id":648695')
      end

      it 'renders 404 when the specified report does not exist' do
        get :show, params: { id: 'four-oh-four' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'requesting a PDF' do
      let(:request) { get(:show, params: { id: 'sample', format: 'pdf' }) }

      it 'returns 406' do
        expect(request.status).to eq(406)
      end
    end
  end

  describe '#auto' do
    context 'without an active scenario' do
      before { get(:auto) }

      it 'redirects to the "main" report' do
        expect(response).to redirect_to(report_url('main'))
      end
    end

    context 'with an active country scenario' do
      subject do
        session[:setting] = Setting.new(api_session_id: 648_695)
        get(:auto)
        response
      end

      it { is_expected.to redirect_to report_url('main') }
    end

    context 'with an active non-country scenario' do
      subject do
        session[:setting] = Setting.new(api_session_id: 956_091,
                                        area_code: 'PV22_drenthe')
        get(:auto)
        response
      end

      it { is_expected.to redirect_to(report_url('regional')) }
    end
  end
end
