# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Loading a scenario without a grant', type: :request do
  include Identity::Test::SystemHelpers

  let(:user) { create(:user) }
  let(:session_id) { 10 }
  let(:role) { 'scenario_collaborator' }

  let(:saved_scenario) do
    SavedScenario.from_params(
      title: 'Test', scenario_id: session_id, area_code: 'nl', end_year: 2050, private: true,
      saved_scenario_users: role ? [{ user_id: user.id, role: }] : []
    )
  end

  before do
    allow(FetchAPIScenario).to receive(:call).and_return(ServiceResult.success(ete_scenario_mock))
    allow(CreateAPIScenario).to receive(:call).and_return(ServiceResult.success(ete_scenario_mock))
    allow(FetchSavedScenario).to receive(:call).and_return(ServiceResult.success(saved_scenario))
  end

  def sign_in_with(grants = {})
    cookies[Identity.config.session_cookie_name] = mock_identity_sign_in(
      id: user.id, name: user.name, email: user.email, claims: { scenario_access: grants }
    )
  end

  def return_to
    "http://www.example.com#{load_path}?granted=1"
  end

  def open_url(return_to)
    "#{Settings.identity.issuer}/saved_scenarios/open?" \
      "#{{ session_ids: [ session_id ], return_to: }.to_query}"
  end

  shared_examples 'a load that bounces for a grant' do
    it 'bounces a signed-in caller with no grant through MyETM' do
      sign_in_with
      get load_path

      expect(response).to redirect_to(open_url(return_to))
    end

    it 'bounces when the cookie holds only a read grant' do
      sign_in_with(Settings.version => { read: [session_id] })
      get load_path

      expect(response).to redirect_to(open_url(return_to))
    end

    it 'bounces when the write grant is under another version' do
      sign_in_with('another-version' => { write: [session_id] })
      get load_path

      expect(response).to redirect_to(open_url(return_to))
    end

    it 'loads when the cookie holds a write grant' do
      sign_in_with(Settings.version => { write: [session_id] })
      get load_path

      expect(response).to redirect_to(play_path)
    end

    it 'loads after the bounce' do
      sign_in_with
      get return_to

      expect(response).to redirect_to(play_path)
    end

    it 'refuses after the bounce when the engine refuses the clone' do
      allow(CreateAPIScenario).to receive(:call).and_return(ServiceResult.failure('Forbidden'))
      sign_in_with
      get return_to

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'by session id' do
    let(:load_path) { "/scenarios/#{session_id}/load" }

    it_behaves_like 'a load that bounces for a grant'

    it 'does not bounce a signed-out visitor' do
      get load_path

      expect(response).to redirect_to(play_path)
    end
  end

  describe 'by saved scenario id' do
    let(:load_path) { '/saved_scenarios/12/load' }

    it_behaves_like 'a load that bounces for a grant'

    it 'does not bounce a signed-out visitor' do
      get load_path

      expect(flash[:alert]).to eq(I18n.t('scenario.unauthorized'))
    end

    it 'loads a public scenario for a signed-out visitor' do
      allow(saved_scenario).to receive(:private).and_return(false)
      get load_path

      expect(response).to redirect_to(play_path)
    end

    context 'with a viewer' do
      let(:role) { 'scenario_viewer' }

      it 'bounces without a grant' do
        sign_in_with
        get load_path

        expect(response).to redirect_to(open_url(return_to))
      end

      it 'loads a copy with a read grant' do
        sign_in_with(Settings.version => { read: [session_id] })
        get load_path

        expect(response).to redirect_to(play_path)
      end
    end

    context 'with no role' do
      let(:role) { nil }

      it 'does not bounce, as MyETM would grant nothing' do
        sign_in_with
        get load_path

        expect(response).to redirect_to(play_path)
      end
    end
  end
end
