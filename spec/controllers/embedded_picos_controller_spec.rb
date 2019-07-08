require 'rails_helper'

describe EmbeddedPicosController, vcr: true do
  render_views

  let(:scenario_mock) { ete_scenario_mock }

  before do
    allow(Api::Scenario).to receive(:find).and_return scenario_mock
  end

  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let!(:user_scenario) { FactoryBot.create :saved_scenario, user: user, id: 648695 }
  let!(:admin_scenario) { FactoryBot.create :saved_scenario, user: admin, id: 648696 }

  describe ' GET show' do
    before do
      login_as user
      session[:setting] = Setting.new
    end

    it " responds with a 200 status" do
      get :show
      expect(response.status).to eq 200
    end
  end
end
