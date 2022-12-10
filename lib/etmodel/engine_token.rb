# frozen_string_literal: true

module ETModel
  # Decodes and verifies a JWT sent by ETEngine.
  module EngineToken
    module_function

    def verify(token, verify: true)
      decoded = JWT.decode(
        token,
        nil,
        verify,
        algorithm: 'RS256',
        iss: Settings.api_url,
        verify_iss: true,
        aud: Settings.identity.client_uri,
        verify_aud: true
      ) do |header|
        jwks_hash[header['kid']]
      end

      # The JWT gem returns an array of the decoded token and the header.
      decoded.first
    end

    def jwks_hash
      jwks_cache.fetch('jwks_hash') do
        etengine_uri = URI.parse(Settings.api_url)
        etengine_uri.path = '/oauth/discovery/keys'

        jwks_raw = JSON.parse(Net::HTTP.get(etengine_uri))['keys']

        Array(jwks_raw).to_h do |raw|
          jwk = JWT::JWK.import(raw)
          [jwk.kid, jwk.public_key]
        end
      end
    end

    def jwks_cache
      if Rails.env.development?
        @jwks_cache ||= ActiveSupport::Cache::MemoryStore.new
      else
        Rails.cache
      end
    end

    private_class_method :jwks_cache
  end
end
