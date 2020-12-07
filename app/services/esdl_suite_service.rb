# frozen_string_literal: true

# Base class for communications with the ESDL Suite
# Retrieves access tokens for making download, upload
# and browse requests possible
#
# The application config must have the esdl suite client, secret and
# url set in order to send requests to ESDL Suite.
class EsdlSuiteService
  include Service

  # Most of the methods below are based on https://docs.openathens.net/display/public/OAAccess/Ruby+OpenID+Connect+example
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
  #                             value needs to be passed to the #redirect method
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
  # and returns the user info
  # code                      The code returned from the OP (ESDL Suite) after
  #                           successful user authentication.
  # nonce                     The unique value associated with the request that
  #                           was saved in the user session
  def redirect(code, nonce)
    # Get code from query string.
    client.authorization_code = code
    access_token = client.access_token!

    # Validate the access token.
    id_token = decode_id_token(access_token.id_token)

    expected = { client_id: @client_id, issuer: discovery.issuer, nonce: nonce, audience: @audience}
    id_token.verify!(expected)

    ##TODO: HERE WE SHOULD SAVE ALL INFO - access, refresh, id tokens
    # Store in user session? or in database?

    access_token.userinfo!
  end

  private

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
