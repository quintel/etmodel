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
    allow(ETModel::EngineToken)
      .to receive(:jwks_hash).and_return('test_key' => JWTHelper.key.public_key)

    JWT.encode(jwt_payload(user, **kwargs), JWTHelper.key, 'RS256', kid: 'test_key')
  end

  def jwt_payload(
    user,
    aud: 'http://localhost:3000',
    iat: Time.now.to_i,
    exp: 1.minute.from_now.to_i,
    scopes: []
  )
    {
      'iss' => Settings.api_url,
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
