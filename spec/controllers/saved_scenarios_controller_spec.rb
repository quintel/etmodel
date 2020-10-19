require 'rails_helper'

describe SavedScenariosController, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }

  before do
    allow(Api::Scenario).to receive(:find).and_return scenario_mock
  end

  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }
  let!(:admin_scenario) { FactoryBot.create :saved_scenario, user: admin, id: 648696 }

  context 'a regular user' do
    before do
      login_as user
      session[:setting] = Setting.new
    end

    describe 'GET load' do
      context 'with an owned saved_scenario' do
        before(:each){ get :load, params: {id: user_scenario.id} }
        subject { response }

        it { is_expected.to redirect_to play_path }

        it do
          expect(assigns(:saved_scenario)).to eq user_scenario
        end
      end

      it 'changes the session active_saved_scenario_id in settings' do
        expect do
          get :load, params: { id: user_scenario.id }
        end.to change{ session[:setting].active_saved_scenario_id }
                .from(nil)
                .to user_scenario.id
      end

      context 'with unowned saved_scenario' do
        it "doesn't change the active_saved_scenario_id in the settings" do
          expect do
            get :load, params: { id: admin_scenario.id }
          end.not_to change{ session[:setting].active_saved_scenario_id }
        end

        it "redirects to play path" do
          get :load, params: { id: admin_scenario.id }
          expect(response).to redirect_to play_path
        end
      end

      it 'with a not-loadable scenario redirects to #show' do
        allow(user_scenario.scenario).to receive(:loadable?).and_return(false)
        get :load, params: { id: user_scenario.id }
        expect(response).to be_redirect
      end

      it 'with a non-existent scenario redirects to #show' do
        allow(Api::Scenario)
          .to receive(:find)
          .and_raise(ActiveResource::ResourceNotFound.new(nil))
        get :load, params: { id: user_scenario.id }
        expect(response).to be_redirect
      end
    end
  end

  describe ' GET show' do
    it 'has an ok status' do
      get :show, params: { id: user_scenario.id }
      expect(response).to be_successful
    end

    it 'responds to the .csv format' do
      get :show, params: { id: user_scenario.id }, format: :csv
      expect(response.media_type).to eq('text/csv')
    end
  end

  describe 'GET new' do
    it 'renders the new saved scenario form' do
      get :new, params: { scenario_id: user_scenario.id }
      expect(response).to be_ok
    end
  end

  describe 'POST create' do
    before do
      login_as(user)

      allow(CreateAPIScenario).to receive(:call).and_return(
        ServiceResult.success(Api::Scenario.new(
          id: 999, area_code: 'nl', end_year: 2050
        ))
      )
    end

    context 'with valid attributes' do
      let(:request) do
        post :create, params: {
          saved_scenario: { title: 'My first scenario', scenario_id: user_scenario.id }
        }
      end

      it 'creates a new SavedScenario' do
        expect { request }.to change(SavedScenario, :count).by(1)
      end

      it 'sets the scenario ID' do
        request
        expect(SavedScenario.last.scenario_id).to eq(999)
      end

      it 'redirect to the scenario' do
        expect(request).to redirect_to(play_path)
      end
    end

    context 'with invalid attributes' do
      before do
        allow(UnprotectAPIScenario).to receive(:call).and_return(ServiceResult.success)
      end

      let(:request) do
        post :create, params: {
          saved_scenario: { scenario_id: user_scenario.id }
        }
      end

      it 'does not create a new SavedScenario' do
        expect { request }.not_to change(SavedScenario, :count)
      end

      it 'renders the form' do
        expect(request).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let(:update) do
      put :update, format: :js, params: {
        id: user_scenario.id,
        saved_scenario: params
      }
      user_scenario.reload
    end

    context 'with an owned saved_scenario and an empty title' do
      before do
        login_as user
        session[:setting] = Setting.new
        update
      end

      let(:params) do
        {
          title: '',
          description: ''
        }
      end

      it 'does not update the title' do
        expect(user_scenario.title).not_to eq(params[:title])
      end
    end

    context 'with an owned saved_scenario and a new title and description' do
      before do
        login_as user
        session[:setting] = Setting.new
        update
      end

      let(:params) do
        {
          title: 'New title',
          description: 'New description'
        }
      end

      it 'updates the title' do
        expect(user_scenario.title).to eq(params[:title])
      end

      it 'updates the description' do
        expect(user_scenario.description).to eq(params[:description])
      end
    end

    context 'with an unowned saved_scenario' do
      let(:params) do
        {
          title: 'New title',
          description: 'New description'
        }
      end

      it 'does not update the scenario' do
        update
        expect(user_scenario.title).not_to eq(params[:title])
      end
    end
  end
end
