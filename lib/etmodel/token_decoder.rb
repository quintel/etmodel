# frozen_string_literal: true

module ETModel
  # Decodes and verifies a JWT.
  module TokenDecoder
    module_function

    DecodeError = Class.new(StandardError)

    def decode(token)
      decoded = JSON::JWT.decode(token, jwk_set)

      unless decoded[:iss] == Settings.idp_url &&
             decoded[:aud] == Settings.identity.client_uri &&
             decoded[:sub].present? &&
             decoded[:exp] > Time.now.to_i
        raise DecodeError, 'JWT verification failed'
      end

      # The JWT gem returns an array of the decoded token and the header.
      decoded
    end

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
