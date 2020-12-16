# frozen_string_literal: true

require 'rails_helper'

describe EsdlSuiteController do
  let(:user) { FactoryBot.create(:user) }
  let(:nonce) { '123456abcd' }
  let(:esdl_auth_url) { 'localhost:3000/auth' }

  def stub_login_redirect_auth_uri
    allow_any_instance_of(EsdlSuiteService)
      .to receive(:auth_uri)
      .and_return(esdl_auth_url)
  end

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
    before do
      login_as user
    end

    ## sets the stuff in the usersession
  end
end
