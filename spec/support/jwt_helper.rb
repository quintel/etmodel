# frozen_string_literal: true

# Contains methods for generating JWTs (that would normally come from ETEngine) and stubbing
# services.
module JWTHelper
  def self.key
    @key ||= OpenSSL::PKey::RSA.new(2048)
  end

  def authorization_header(user = nil, scopes = [])
    user ? { 'Authorization' => "Bearer #{generate_jwt(user, scopes:)}" } : {}
  end

  def generate_jwt(user, **kwargs)
    allow(ETModel::Tokens)
      .to receive(:jwk_set).and_return(
        JSON::JWK::Set.new([JSON::JWK.new(JWTHelper.key.public_key, kid: 'test_key')])
      )

    token = JSON::JWT.new(jwt_payload(user, **kwargs))
    token.header[:kid] = 'test_key'

    token.sign(JWTHelper.key, :RS256).to_s
  end

  def jwt_payload(
    user,
    aud: 'http://localhost:3000',
    iat: Time.now.to_i,
    exp: 1.minute.from_now.to_i,
    scopes: []
  )
    {
      'iss' => Settings.identity.issuer,
      'aud' => aud,
      'iat' => iat,
      'exp' => exp,
      'sub' => user.id,
      'user' => {
        'id' => user.id,
        'name' => user.name
      },
      'scopes' => Array(scopes)
    }
  end
end
