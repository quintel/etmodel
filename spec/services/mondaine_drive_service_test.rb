# frozen_string_literal: true

require 'rails_helper'

describe MondaineDriveService, type: :service do
  let(:auth_url) { 'http://localhost/auth' }
  let(:api_url) { 'http://localhost/api' }
  let(:service) { described_class.new(api_url, auth_url) }

  def stub_auth_response(code, username, password, response_body = {})
    stub_post_response(
      code,
      {
        username: username,
        password: password,
        grant_type: 'password',
        client_id: 'curl',
        scope: 'openid profile email microprofile-jwt user_group_path'
      },
      response_body
    )
  end

  def stub_refresh_token_response(code, refresh_token, response_body)
    stub_post_response(
      code,
      {
        client_id: 'curl',
        grant_type: 'refresh_token',
        refresh_token: refresh_token
      },
      response_body
    )
  end

  def stub_post_response(code, data, response_body)
    allow(HTTParty)
      .to receive(:post)
      .with(
        auth_url, hash_including(data: data)
      )
      .and_return(ServicesHelper::StubResponse.new(code, response_body))
  end

  def access_token(expired_at = nil)
    token = {
      access_token: 'xyz',
      expires_in: 600,
      refresh_token: 'abc',
    }

    return token unless expired_at

    token[:expires_at] = expired_at
    token
  end

  describe 'getting an access token' do
    subject { service.get_access_token(username, password) }

    context 'when Mondaine Drive user exists' do
      let(:username) { 'Mondaine' }
      let(:password) { 'Drive' }

      before do
        stub_auth_response(200, username, password, access_token)
      end

      it { is_expected.to be_a(ServiceResult) }
      it { is_expected.to be_successful }

      it 'returns the access_token in the ServiceResult' do
        expect(subject.value).to include(access_token)
      end
    end

    context 'when Mondaine Drive user does not exist' do
      let(:username) { 'Mondaine' }
      let(:password) { 'Drive' }

      before do
        stub_auth_response(400, username, password, access_token)
      end

      it { is_expected.to be_a(ServiceResult) }
      it { is_expected.not_to be_successful }

      it 'no access token is returned' do
        expect(subject.value).to be_falsey
      end
    end
  end

  describe 'refreshing an access token' do
    let(:expired_token) { access_token(Time.current - 30.minutes) }
    let(:not_expired_token) { access_token(Time.current + 30.minutes) }

    context 'with expired access token' do
      subject { service.refresh_access_token(expired_token) }

      before do
        stub_refresh_token_response(200, expired_token[:refresh_token], access_token)
      end

      it { is_expected.to be_successful }
      it { is_expected.to be_a(ServiceResult) }

      it 'refreshes the token' do
        expect(subject.value[:expires_at]).to be > Time.current
      end
    end

    context 'with valid access token' do
      subject { service.refresh_access_token(not_expired_token) }

      before do
        stub_refresh_token_response(200, not_expired_token[:refresh_token], access_token)
      end

      it { is_expected.to be_successful }
      it { is_expected.to be_a(ServiceResult) }

      it 'refreshes the token' do
        expect(subject.value[:expires_at]).not_to eq(not_expired_token[:expires_at])
      end
    end
  end

  describe 'validating an access token' do
    let(:expired_token) { access_token(Time.current - 30.minutes) }
    let(:not_expired_token) { access_token(Time.current + 30.minutes) }

    context 'with expired access token' do
      subject { service.validate_token(expired_token) }

      before do
        stub_refresh_token_response(200, expired_token[:refresh_token], access_token)
      end

      it 'refreshes the token' do
        expect(subject[:expires_at]).to be > Time.current
      end
    end

    context 'with valid access token' do
      before do
        stub_refresh_token_response(200, not_expired_token[:refresh_token], access_token)
      end

      it 'does not change the token' do
        expect(service.validate_token(not_expired_token)).to eq(not_expired_token)
      end
    end
  end
end
