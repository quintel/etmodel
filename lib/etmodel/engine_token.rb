# frozen_string_literal: true

module ETModel
  # Decodes and verifies a JWT sent by ETEngine.
  module EngineToken
    module_function

    DecodeError = Class.new(StandardError)

    def decode(token)
      decoded = JSON::JWT.decode(token, jwk_set)

      unless (
        decoded[:iss] == Settings.api_url &&
        decoded[:aud] == Settings.identity.client_uri &&
        decoded[:sub].present? &&
        decoded[:exp] > Time.now.to_i
      )
        raise DecodeError, 'JWT verification failed'
      end

      # The JWT gem returns an array of the decoded token and the header.
      decoded
    end

    def jwk_set
      jwk_cache.fetch('jwks_hash') do
        JSON::JWK::Set::Fetcher.fetch(Identity.discovery_config.jwks_endpoint)
      end
    end

    def jwk_cache
      if Rails.env.development?
        @jwk_cache ||= ActiveSupport::Cache::MemoryStore.new
      else
        Rails.cache
      end
    end

    private_class_method :jwk_cache
  end
end
