# frozen_string_literal: true

# Base class for communications with the ESDL Suite
#
# Retrieves access tokens and sets up ESDLSuiteIds for making download, upload  and browse requests
# possible. The application config must have the esdl suite client, secret and url set in order to
# send requests to ESDL Suite.
class EsdlSuiteService
  include Service

  ID_TOKEN_VALIDATION_ERRORS = [
    OpenIDConnect::ResponseObject::IdToken::InvalidNonce,
    OpenIDConnect::ResponseObject::IdToken::InvalidIssuer,
    OpenIDConnect::ResponseObject::IdToken::InvalidAudience
  ].freeze

  # Public: Setup a new EsdlSuitService with the configuration specified in the app config
  def self.setup
    new(
      Settings.esdl_suite_url,
      Settings.esdl_suite_client_id,
      Settings.esdl_suite_client_secret,
      Settings.esdl_suite_redirect_url
    )
  end

  def self.call(*args)
    setup.call(*args)
  end

  # Public: Creates an instance of EsdlSuiteService
  #
  # provider_uri - URI, when extended with /.well-known/openid-configuration acts as a discovery url
  #                pointing to a JSON file containing all OpenID settings for the ESDL Suite
  # client_id    - Our client_id
  # secret       - Our client_secret
  # redirect_uri - The uri we want the ESDL Suite to redirect to and send the authorization code to
  #                after the user has logged into the Suite
  #
  # Returns the EsdlSuiteService instance
  def initialize(provider_uri, client_id, secret, redirect_url)
    @provider_uri = provider_uri
    @client_id = client_id
    @secret = secret
    @redirect_url = redirect_url
    @audience = 'esdl-mapeditor'
  end

  # Public: Composes the authentication URL, where the user should be redirected to to log in.
  #
  # nonce - Unique value associated with the request. Same value needs to be passed to the
  #         #authenticate method (this value is stored in the user session)
  #
  # Returns the authentication URL
  def auth_uri(nonce)
    client.authorization_uri(
      scope: %i[user_group_path email profile esdl-mapeditor microprofile-jwt user_group],
      state: nonce,
      nonce: nonce
    )
  end

  # Public: Checks the validity of the redirect after a user has logged in at the ESDL Suite,
  # and creates an EsdlSuiteId on the user
  #
  # code  - The code returned from the OP (ESDL Suite) after successful user authentication.
  # nonce - The unique value associated with the request that was saved in the user session
  # user  - The User the tokens should be saved for
  #
  # Returns a ServiceResult
  def authenticate(code, nonce, user)
    # Get code from query string.
    client.authorization_code = code
    access_token = client.access_token!

    # Validation.
    id_token = decode_id_token(access_token.id_token)
    expected = { client_id: @client_id, issuer: discovery.issuer, nonce: nonce, audience: @audience }
    id_token.verify!(expected)

    EsdlSuiteId.create_or_update(
      user: user,
      access_token: access_token.access_token,
      refresh_token: access_token.refresh_token,
      expires_at: Time.zone.at(id_token.exp).to_datetime
    )

    ServiceResult.success
  rescue Rack::OAuth2::Client::Error
    ServiceResult.failure(['Auth code has expired'])
  rescue OpenIDConnect::ResponseObject::IdToken::ExpiredToken
    ServiceResult.failure(['Token was expired'])
  rescue *ID_TOKEN_VALIDATION_ERRORS
    ServiceResult.failure(['ID Token could not be validated'])
  end

  # Public: Refreshes an expired access token
  #
  # access_token - An expired OpenIDConnect::AccessToken
  #
  # Returns the updated values in a hash (String access_token, DateTime expires_at)
  def refresh(access_token)
    new_access_token = access_token.client.access_token!
    expires = Time.zone.at(decode_id_token(new_access_token.id_token).exp).to_datetime

    {
      access_token: new_access_token.access_token,
      expires_at: expires
    }
  rescue Rack::OAuth2::Client::Error
    # Refresh token was expired
    {}
  end

  # Public: Sets up an OpenIDConnect::Client with the correct settings
  #
  # Returns an instance of OpenIDConnect::Client
  def client
    @client ||= OpenIDConnect::Client.new(
      identifier: @client_id,
      secret: @secret,
      redirect_uri: @redirect_url,
      realm: 'esdl-mapeditor',
      audience: @audience,
      authorization_endpoint: discovery.authorization_endpoint,
      token_endpoint: discovery.token_endpoint,
      userinfo_endpoint: discovery.userinfo_endpoint
    )
  end

  private

  def discovery
    @discovery ||= OpenIDConnect::Discovery::Provider::Config.discover!(@provider_uri)
  end

  def jwks_key
    @jwks_key ||= retrieve_jwks_key
  end

  # Internal: Retrieves the jwks key to decrypt the id_token from the discovered jwks_uri.
  #
  # Returns a JSON::JWK instance
  def retrieve_jwks_key
    response = HTTParty.public_send(:get, discovery.jwks_uri)

    if response.ok?
      jwk = JSON.parse(response.body)['keys'][0]
      return JSON::JWK.new(jwk)
    end

    raise OpenIDConnect::BadRequest(
      message: 'Bad Request trying to reach jwks uri',
      response: response
    )
  end

  def decode_id_token(id_token)
    OpenIDConnect::ResponseObject::IdToken.decode(id_token, jwks_key)
  end

  def headers_for(esdl_suite_id)
    { 'Authorization' => "Bearer #{esdl_suite_id.access_token}" }
  end
end
