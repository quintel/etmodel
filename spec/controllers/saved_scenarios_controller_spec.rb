require 'rails_helper'

describe SavedScenariosController, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }

  before do
    allow(user_scenario).to receive(:scenario).and_return(scenario_mock)
    allow(admin_scenario).to receive(:scenario).and_return(scenario_mock)
  end

  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }
  let!(:admin_scenario) { FactoryBot.create :saved_scenario, user: admin, id: 648696 }

  describe 'GET index' do
    context 'when requesting HTML' do
      it { expect(get(:index)).to redirect_to(scenarios_url) }
    end
  end

  context 'a regular user' do
    before do
      sign_in user
      session[:setting] = Setting.new
    end

    describe 'GET load' do
      context 'with an owned saved_scenario' do
        subject { response }

        before { get(:load, params: { id: user_scenario.id }) }

        it { is_expected.to redirect_to play_path }

        it do
          expect(assigns(:saved_scenario)).to eq(user_scenario)
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

        it 'sets the scenario title in the settings' do
          expect { get(:load, params: { id: admin_scenario.id }) }
            .to change { session[:setting].active_scenario_title }
            .from(nil).to(admin_scenario.title)
        end

        it "redirects to play path" do
          get :load, params: { id: admin_scenario.id }
          expect(response).to redirect_to play_path
        end
      end

      it 'with a not-loadable scenario redirects to #show' do
        allow(user_scenario.scenario(nil)).to receive(:loadable?).and_return(false)
        get :load, params: { id: user_scenario.id }
        expect(response).to be_redirect
      end

      it 'with a non-existent scenario redirects to #show' do
        allow(CreateAPIScenario)
          .to receive(:call)
          .and_return(ServiceResult.failure('Scenario not found'))

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

    context 'when the scenario cannot be loaded' do
      before do
        allow(Engine::Area).to receive(:code_exists?).and_return(false)
      end

      it 'redirects to the root page' do
        get :show, params: { id: user_scenario.id }
        expect(response).to be_redirect
      end
    end
  end

  describe 'GET new' do
    it 'renders the new saved scenario form' do
      sign_in(user)
      get :new, params: { scenario_id: user_scenario.id }

      expect(response).to be_ok
    end
  end

  describe 'POST create' do
    before do
      sign_in(user)

      allow(CreateAPIScenario).to receive(:call).and_return(
        ServiceResult.success(Engine::Scenario.new(
          attributes_for(:engine_scenario, id: 999, area_code: 'nl', end_year: 2050)
        ))
      )

      allow(CreateAPIScenarioVersionTag).to receive(:call).and_return(
        ServiceResult.success
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
        allow(SetAPIScenarioCompatibility)
          .to receive(:dont_keep_compatible)
          .and_return(ServiceResult.success)
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
        sign_in user
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
        sign_in user
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

  describe 'PUT discard' do
    before do
      sign_in(user)
      session[:setting] = Setting.new
    end

    context 'with an owned saved scenario' do
      before do
        post(:discard, params: { id: user_scenario.id })
      end

      it 'redirects to the scenario listing' do
        expect(response).to be_redirect
      end

      it 'soft-deletes the scenario' do
        expect(user_scenario.reload).to be_discarded
      end
    end

    context 'with an unowned saved scenario' do
      before do
        post(:discard, params: { id: admin_scenario.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not soft-delete the scenario' do
        expect(admin_scenario.reload).not_to be_discarded
      end
    end

    context 'with a saved scenario ID that does not exist' do
      before do
        post(:discard, params: { id: 99_999 })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end

  describe 'PUT undiscard' do
    before do
      sign_in(user)
      session[:setting] = Setting.new
    end

    context 'with an owned saved scenario' do
      before do
        user_scenario.discard!
        post(:undiscard, params: { id: user_scenario.id })
      end

      it 'redirects to the scenario listing' do
        expect(response).to be_redirect
      end

      it 'removes the soft-deletion of the scenario' do
        expect(user_scenario.reload).not_to be_discarded
      end
    end

    context 'with an unowned saved scenario' do
      before do
        admin_scenario.discard!
        post(:undiscard, params: { id: admin_scenario.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not remove the soft-deletion of the scenario' do
        expect(admin_scenario.reload).to be_discarded
      end
    end

    context 'with a saved scenario ID that does not exist' do
      before do
        post(:undiscard, params: { id: 99_999 })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end

  describe 'PUT publish' do
    before do
      sign_in(user)
      session[:setting] = Setting.new
      allow(UpdateAPIScenarioPrivacy).to receive(:call_with_ids)
    end

    context 'with an owned saved scenario' do
      before do
        user_scenario.update!(private: true)
        post(:publish, params: { id: user_scenario.id })
      end

      it 'redirects to the scenario' do
        expect(response).to be_redirect
      end

      it 'makes the scenario public' do
        expect(user_scenario.reload).not_to be_private
      end

      it 'updates the API scenarios' do
        expect(UpdateAPIScenarioPrivacy).to have_received(:call_with_ids).with(
          anything, [user_scenario.id], private: false
        )
      end
    end

    context 'with an unowned saved scenario' do
      before do
        admin_scenario.update!(private: true)
        post(:publish, params: { id: admin_scenario.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not change the scenario privacy' do
        expect(admin_scenario.reload).to be_private
      end

      it 'does not update the API scenarios' do
        expect(UpdateAPIScenarioPrivacy).not_to have_received(:call_with_ids)
      end
    end
  end

  describe 'PUT unpublish' do
    before do
      sign_in(user)
      allow(UpdateAPIScenarioPrivacy).to receive(:call_with_ids)
      session[:setting] = Setting.new
    end

    context 'with an owned saved scenario' do
      before do
        user_scenario.update!(private: false)
        post(:unpublish, params: { id: user_scenario.id })
      end

      it 'redirects to the scenario listing' do
        expect(response).to be_redirect
      end

      it 'makes the scenario public' do
        expect(user_scenario.reload).to be_private
      end

      it 'updates the API scenarios' do
        expect(UpdateAPIScenarioPrivacy).to have_received(:call_with_ids).with(
          anything, [user_scenario.id], private: true
        )
      end
    end

    context 'with an unowned saved scenario' do
      before do
        user_scenario.update!(private: false)
        post(:unpublish, params: { id: admin_scenario.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not change the scenario privacy' do
        expect(admin_scenario.reload).not_to be_private
      end

      it 'does not update the API scenarios' do
        expect(UpdateAPIScenarioPrivacy).not_to have_received(:call_with_ids)
      end
    end
  end

  describe 'PUT restore' do
    before do
      sign_in(user)
      session[:setting] = Setting.new
      allow(RestoreSavedScenario).to receive(:call)
    end

    context 'with an owned saved scenario' do
      before do
        user_scenario.update!(scenario_id_history: [8, 9, 10])
        put(
          :restore,
          format: :js,
          params: { id: user_scenario.id, saved_scenario: { scenario_id: 9 } }
        )
      end

      it 'is succesfull' do
        expect(response).to be_successful
      end
    end

    context 'with an unowned saved scenario' do
      before do
        admin_scenario.update!(scenario_id_history: [8, 9, 10])
        put(
          :restore,
          format: :js,
          params: { id: admin_scenario.id, saved_scenario: { scenario_id: 9 } }
        )
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      sign_in(user)
      session[:setting] = Setting.new
    end

    context 'with an owned saved scenario' do
      before do
        delete(:destroy, params: { id: user_scenario.id })
      end

      it 'redirects to the scenario listing' do
        expect(response).to be_redirect
      end

      it 'destroys the scenario' do
        expect(SavedScenario.exists?(user_scenario.id)).to be(false)
      end
    end

    context 'with an unowned saved scenario' do
      before do
        delete(:destroy, params: { id: admin_scenario.id })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end

      it 'does not destroy the scenario' do
        expect(SavedScenario.exists?(admin_scenario.id)).to be(true)
      end
    end

    context 'with a saved scenario ID that does not exist' do
      before do
        delete(:destroy, params: { id: 99_999 })
      end

      it 'returns 404' do
        expect(response).to be_not_found
      end
    end
  end
end
