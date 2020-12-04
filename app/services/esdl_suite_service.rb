# frozen_string_literal: true

# Base class for communications with the ESDL Suite
# Retrieves access tokens for making download, upload
# and browse requests possible
#
# The application config must have the esdl suite client, secret and
# discovery_url set in order to send requests to ESDL Suite.
class EsdlSuiteService
  include Service

  # Most of the methods below are based on https://docs.openathens.net/display/public/OAAccess/Ruby+OpenID+Connect+example
  # provider_discovery_uri      URI pointing to a JSON file containing all OpenID settings
  #                             for the ESDL Suite
  # client_id                   Our client_id
  # secret                      Our client_secret
  # redirect_uri                The uri we want the ESDL Suite to redirect to and
  #                             send the authorization code to after the user has
  #                             logged into the Suite
  #
  def initialize(provider_discovery_uri, client_id, secret, redirect_url)
    @provider_discovery_uri = provider_discovery_uri
    @client_id = client_id
    @secret = secret
    @redirect_url = redirect_url
  end

  # Returns the authentication URL, where the user should be redirected to to log in.
  # nonce                       Unique value associated with the request. Same
  #                             value needs to be passed to the #redirect method
  #                             (this value is stored in the user session)
  #
  def auth_uri(nonce)
    init_client.authorization_uri(
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
    client = init_client
    # What we are expecting.
    expected = { client_id: @client_id, issuer: discover['issuer'], nonce: nonce }
    # Get code from query string.
    client.authorization_code = code
    access_token = client.access_token!
    # Validate the access token.
    id_token = OpenIDConnect::ResponseObject::IdToken.decode(
      access_token.id_token, discover['jwks_uri'] # what should we do with discover.jwks ?
    )
    id_token.verify!(expected)

    access_token.userinfo!
  end

  private

  # Returns a OpenIDConnect::Client with the correct settings
  def init_client
    @client ||= OpenIDConnect::Client.new(
      identifier: @client_id,
      secret: @secret,
      redirect_uri: @redirect_url,
      realm: 'esdl-mapeditor',
      audience: 'esdl-mapeditor',
      authorization_endpoint: discovery['authorization_endpoint'],
      token_endpoint: discovery['token_endpoint'],
      userinfo_endpoint: discovery['userinfo_endpoint']
    )
  end

  def discovery
    @discovery ||= discover
  end

  # Mimicks OpenIDConnect::Discovery::Provider.discover! which is failing for
  # unknown reasons
  def discover
    response = HTTParty.public_send(:get, @provider_discovery_uri)

    return JSON.parse(response.body) if response.ok?

    raise OpenIDConnect::BadRequest(
      message: 'Bad Request trying to reach discovery uri',
      response: response
    )
  end
end
