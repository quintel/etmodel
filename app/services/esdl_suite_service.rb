# frozen_string_literal: true

# Base class for communications with the ESDL Suite
# Retrieves access tokens for making download, upload
# and browse requests possible
#
# The application config must have the esdl suite client, secret and
# url set in order to send requests to ESDL Suite.
class EsdlSuiteService
  include Service

  # Setup a new EsdlSuitService
  def self.setup
    new(
      APP_CONFIG[:esdl_suite_url],
      APP_CONFIG[:esdl_suite_client_id],
      APP_CONFIG[:esdl_suite_client_secret],
      APP_CONFIG[:esdl_suite_redirect_url]
    )
  end

  # Arguments:
  # provider_uri                URI, when extended with /.well-known/openid-configuration
  #                             acts as a discovery url pointing to a JSON file
  #                             containing all OpenID settings for the ESDL Suite
  # client_id                   Our client_id
  # secret                      Our client_secret
  # redirect_uri                The uri we want the ESDL Suite to redirect to and
  #                             send the authorization code to after the user has
  #                             logged into the Suite
  #
  def initialize(provider_uri, client_id, secret, redirect_url)
    @provider_uri = provider_uri
    @client_id = client_id
    @secret = secret
    @redirect_url = redirect_url
    @audience = 'esdl-mapeditor'
  end

  # Returns the authentication URL, where the user should be redirected to to log in.
  # nonce                       Unique value associated with the request. Same
  #                             value needs to be passed to the #authenticate method
  #                             (this value is stored in the user session)
  #
  def auth_uri(nonce)
    client.authorization_uri(
      scope: %i[user_group_path email profile esdl-mapeditor microprofile-jwt user_group],
      state: nonce,
      nonce: nonce
    )
  end

  # Checks the validity of the redirect after a user has logged in at the ESDL Suite,
  # and creates an EsdlSuiteId on the user
  # code                      The code returned from the OP (ESDL Suite) after
  #                           successful user authentication.
  # nonce                     The unique value associated with the request that
  #                           was saved in the user session
  # user                      The User the tokens should be saved for
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
      id_token: access_token.id_token,
      access_token: access_token.access_token,
      refresh_token: access_token.refresh_token,
      expires_at: Time.zone.at(id_token.exp).to_datetime
    )

    ServiceResult.success

  rescue Rack::OAuth2::Client::Error
    ServiceResult.failure(['Auth code has expired'])
  rescue OpenIDConnect::ResponseObject::IdToken::ExpiredToken
    ServiceResult.failure(['Token was expired'])
  rescue OpenIDConnect::ResponseObject::IdToken::InvalidNonce, OpenIDConnect::ResponseObject::IdToken::InvalidIssuer, OpenIDConnect::ResponseObject::IdToken::InvalidAudience
    ServiceResult.failure(['Scary spooky! Either Nonce, Aud or Issuer was invalid!'])
  end

  # Refreshes an expired OpenIDConnect::AccessToken access_token
  # and returns the updated values
  def refresh(access_token)
    new_access_token = access_token.client.access_token!
    expires = Time.zone.at(decode_id_token(new_access_token.id_token).exp).to_datetime

    {
      access_token: new_access_token.access_token,
      id_token: new_access_token.id_token,
      expires_at: expires
    }
  rescue Rack::OAuth2::Client::Error
    {}
  end

  # Returns a OpenIDConnect::Client with the correct settings
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

  # Retrieves the jwks key to decrypt the id_token from the
  # discovered jwks_uri. Returns a JSON::JWK instance
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
end
