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
    end
  end

  describe ' GET show' do
    it 'has an ok status' do
      get :show, params: { id: user_scenario.id }
      expect(response).to be_successful
    end

    it 'with a not-loadable scenario' do
      expect(user_scenario.scenario).to receive(:loadable?).and_return(false)

      get :show, params: { id: user_scenario.id }

      expect(response).to be_redirect
    end


    it 'with a non-existent scenario' do
      allow(Api::Scenario)
        .to receive(:find)
        .and_raise(ActiveResource::ResourceNotFound.new(nil))
      get :show, params: { id: user_scenario.id }
      expect(response).to be_redirect
    end
  end
end
