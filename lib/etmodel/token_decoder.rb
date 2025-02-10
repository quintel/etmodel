# frozen_string_literal: true

module ETModel
  # Handles JWT decoding, verification, and fetching.
  module TokenDecoder
    module_function

    DecodeError = Class.new(StandardError)

    # Decodes and verifies a JWT.
    def decode(token)
      begin
        decoded = JSON::JWT.decode(token, jwk_set)
      rescue JSON::JWK::Set::KidNotFound
        jwk_cache.delete('jwk_hash') # Clear cache and retry
        decoded = JSON::JWT.decode(token, jwk_set)
      end

      unless decoded[:iss] == Settings.identity.issuer &&
             decoded[:aud] == Settings.identity.client_id &&
             decoded[:sub].present? &&
             decoded[:exp] > Time.now.to_i
        raise DecodeError, 'JWT verification failed'
      end

      decoded
    end

    # Fetches and caches the JWK set from the IdP.
    def jwk_set
      jwk_cache.fetch('jwk_hash') do
        client = Faraday.new(Identity.discovery_config.jwks_uri) do |conn|
          conn.request(:json)
          conn.response(:json)
          conn.response(:raise_error)
        end

        JSON::JWK::Set.new(client.get.body)
      end
    end

    # Handles caching of JWKs.
    def jwk_cache
      @jwk_cache ||=
        if Rails.env.development?
          ActiveSupport::Cache::MemoryStore.new
        else
          Rails.cache
        end
    end
  end
end
