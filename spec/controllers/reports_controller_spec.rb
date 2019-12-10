require 'rails_helper'

describe ReportsController, vcr: true do
  render_views

  describe '#show' do
    context 'without an active scenario' do
      before { get(:show, params: { id: 'sample' }) }

      it 'starts a new scenario' do
        expect(response.body).to include('"api_session_id":null')
      end

      it 'renders the report' do
        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end

    context 'with an active scenario' do
      before { session[:setting] = Setting.new(api_session_id: 648_695) }

      it 'uses the scenario' do
        get :show, params: { id: 'sample' }
        expect(response.body).to include('"api_session_id":648695')
      end

      it 'renders the report' do
        get :show, params: { id: 'sample' }

        expect(response).to be_successful
        expect(response).to render_template(:show)
      end

      it 'renders 404 when the specified report does not exist' do
        expect { get :show, params: { id: 'four-oh-four' } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a specified scenario' do
      before { session[:setting] = Setting.new(api_session_id: 648_695) }

      it 'starts a new scenario with the specified ID' do
        get :show, params: { id: 'sample', scenario_id: 648_695 }
        expect(response.body).to include('"api_session_id":655091')
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
      before { session[:setting] = Setting.new(api_session_id: 648_695) }

      before { get(:auto) }

      it 'redirects to the "main" report' do
        expect(response).to redirect_to(report_url('main'))
      end
    end

    context 'with an active non-country scenario' do
      before do
        session[:setting] = Setting.new(
          api_session_id: 956_091,
          area_code: 'PV22_drenthe'
        )
      end

      before { get(:auto) }

      it 'redirects to the "regional" report' do
        expect(response).to redirect_to(report_url('regional'))
      end
    end
  end
end
