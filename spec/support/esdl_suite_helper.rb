# frozen_string_literal: true

module EsdlSuiteHelper
  def stub_esdl_suite_open_id_methods(valid_nonce: true, valid_code: true)
    setup_esdl_suite_app_config

    stub_discovery
    stub_access_token(valid_code)
    stub_id_token(valid_nonce)
  end

  def stub_access_token_refresh(updated_attributes)
    allow_any_instance_of(EsdlSuiteService)
      .to receive(:refresh)
      .and_return(updated_attributes)
  end

  def provider_url
    'https://esdl-suite/auth/'
  end

  def redirect_url
    'http://localhost/redirect'
  end

  def client_id
    'etm'
  end

  def setup_esdl_suite_app_config
    allow(Settings).to receive(:esdl_suite_url).and_return(provider_url)
    allow(Settings).to receive(:esdl_suite_client_id).and_return(client_id)
    allow(Settings).to receive(:esdl_suite_client_secret).and_return('secret')
    allow(Settings).to receive(:esdl_suite_redirect_url).and_return(redirect_url)
  end

  private

  def stub_discovery
    allow(OpenIDConnect::Discovery::Provider::Config)
      .to receive(:discover!)
      .with(provider_url)
      .and_return(discovery_double)
  end

  def stub_id_token(valid_nonce = true)
    token_double = valid_nonce ? id_token_double : invalid_id_token_double

    allow_any_instance_of(EsdlSuiteService)
      .to receive(:decode_id_token)
      .and_return(token_double)
  end

  def id_token_double
    id_token = double('id_token')
    allow(id_token).to receive(:verify!).and_return(true)
    allow(id_token).to receive(:exp).and_return(10.minutes.from_now)

    id_token
  end

  def invalid_id_token_double
    id_token = double('id_token')
    allow(id_token)
      .to receive(:verify!)
      .and_raise(
        OpenIDConnect::ResponseObject::IdToken::InvalidNonce.new(
          'Invalid ID Token: Nonce does not match'
        )
      )

    id_token
  end

  def stub_access_token(valid_code = true)
    return stub_valid_code_access_token if valid_code

    stub_invalid_code_access_token
  end

  def stub_valid_code_access_token
    allow_any_instance_of(OpenIDConnect::Client)
      .to receive(:access_token!)
      .and_return(
        OpenIDConnect::AccessToken.new(
          access_token: '12345',
          client: client_id,
          id_token: 'hi',
          refresh_token: '6789'
        )
      )
  end

  def stub_invalid_code_access_token
    allow_any_instance_of(OpenIDConnect::Client)
      .to receive(:access_token!)
      .and_raise(
        Rack::OAuth2::Client::Error.new(400, { error_message: 'Invalid grant' })
      )
  end

  def discovery_double
    discovery = double('discovery')
    {
      authorization_endpoint: '/auth',
      token_endpoint: '/token',
      userinfo_endpoint: '/userinfo',
      jwks_uri: '/certs',
      issuer: provider_url
    }.each do |key, value|
      allow(discovery).to receive(key) { value }
    end

    discovery
  end
end
