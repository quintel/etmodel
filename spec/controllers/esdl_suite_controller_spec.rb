# frozen_string_literal: true

require 'rails_helper'

describe EsdlSuiteController do
  include EsdlSuiteHelper

  let(:user) { FactoryBot.create(:user) }
  let(:nonce) { '123456abcd' }
  let(:esdl_auth_url) { 'localhost:3000/auth' }
  let(:esdl_suite_id) do
    EsdlSuiteId.create!(
      user: user,
      expires_at: 10.minutes.from_now,
      access_token: '123',
      refresh_token: '456',
      id_token: '789'
    )
  end

  def stub_login_redirect_auth_uri
    allow_any_instance_of(EsdlSuiteService)
      .to receive(:auth_uri)
      .and_return(esdl_auth_url)
  end

  def stub_browse_tree(successful)
    result = successful ? ServiceResult.success([{ key: 'val' }]) : ServiceResult.failure
    allow(BrowseEsdlSuite)
      .to receive(:call)
      .and_return(result)
  end

  before { setup_esdl_suite_app_config }

  describe 'GET login' do
    subject do
      get :login
      response
    end

    before { stub_login_redirect_auth_uri }

    context 'with user not logged in to the ETM' do
      before do
        session[:esdl_nonce] = nil
      end

      it { is_expected.not_to redirect_to(esdl_auth_url) }
      it { is_expected.to be_redirect }

      it 'does not set a nonce' do
        subject
        expect(session[:esdl_nonce]).to be_nil
      end
    end

    context 'with no nonce present in session' do
      before do
        login_as user
      end

      it { is_expected.to redirect_to(esdl_auth_url) }

      it 'saves a nonce in the session' do
        subject
        expect(session[:esdl_nonce]).not_to be_nil
      end

      it 'saves a unique value each time the login reqeust is made' do
        get :login
        saved_nonce = session[:esdl_nonce]
        get :login
        expect(session[:esdl_nonce]).not_to eq(saved_nonce)
      end
    end

    context 'with a nonce already present in the session' do
      before do
        login_as user
        session[:esdl_nonce] = nonce
      end

      it { is_expected.to redirect_to(esdl_auth_url) }

      it 'generates a new nonce value' do
        subject
        expect(session[:esdl_nonce]).not_to eq(nonce)
      end
    end
  end

  describe 'GET redirect' do
    subject do
      get :redirect, params: { code: 'abcd', nonce: nonce }
      response
    end

    before do
      login_as user
      session[:esdl_nonce] = nonce
      stub_esdl_suite_open_id_methods
    end

    it { is_expected.to be_redirect }

    it 'creates a new EsdlSuiteId in the database' do
      expect { subject }.to change { EsdlSuiteId.count }.by(1)
    end

    it 'creates a new EsdlSuiteId on the user' do
      subject
      expect(user.esdl_suite_id).to be_present
    end
  end

  describe 'GET browse' do
    subject do
      get :browse, params: { path: 'some_path' }, format: :json
      response
    end

    before do
      login_as user
      stub_esdl_suite_open_id_methods
    end

    context 'when not logged in to drive' do
      it { is_expected.to be_redirect }
    end

    context 'with valid browse path' do
      before do
        stub_browse_tree(true)
        esdl_suite_id
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns a json with tree nodes' do
        expect(JSON.parse(subject.body)).to eq([{ 'key' => 'val' }])
      end
    end

    context 'with invalid browse path' do
      before do
        stub_browse_tree(false)
        esdl_suite_id
      end

      it { is_expected.to have_http_status(:not_found) }

      it 'returns an empty json' do
        expect(JSON.parse(subject.body)).to eq([])
      end
    end
  end
end
