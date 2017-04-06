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
        expect(response).to be_success
        expect(response).to render_template(:show)
      end
    end

    context 'with an active scenario' do
      before { session[:setting] = Setting.new(api_session_id: 648_695) }
      before { FactoryGirl.create(:tab, key: 'demand') }

      it 'uses the scenario' do
        get :show, params: { id: 'sample' }
        expect(response.body).to include('"api_session_id":648695')
      end

      it 'renders the report' do
        get :show, params: { id: 'sample' }

        expect(response).to be_success
        expect(response).to render_template(:show)
      end

      it 'renders 404 when the specified report does not exist' do
        expect { get :show, params: { id: 'four-oh-four' } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a specified scenario' do
      before { session[:setting] = Setting.new(api_session_id: 648_695) }
      before { FactoryGirl.create(:tab, key: 'demand') }

      it 'starts a new scenario with the specified ID' do
        get :show, params: { id: 'sample', scenario_id: 648_695 }
        expect(response.body).to include('"api_session_id":655091')
      end
    end
  end
end
