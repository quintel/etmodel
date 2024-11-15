# frozen_string_literal: true

module ETModel
  # Handles JWT decoding, verification, and fetching.
  module TokenDecoder
    module_function

    DecodeError = Class.new(StandardError)
    FetchTokenError = Class.new(StandardError)

    # Decodes and verifies a JWT.
    def decode(token)
      decoded = JSON::JWT.decode(token, jwk_set)

      unless decoded[:iss] == Settings.idp_url &&
             decoded[:aud] == Settings.identity.client_uri &&
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

    # Fetches an access token from the IdP.
    def fetch_token(user)
      response = Faraday.post("#{Settings.idp_url}/identity/token") do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {
          grant_type: 'client_credentials',
          client_id: Settings.identity.client_id,
          user_id: user.id # Pass the user to the IdP
        }
      end

      parsed_response = JSON.parse(response.body)

      unless response.success? && parsed_response['access_token'].present?
        raise "Failed to fetch token: #{parsed_response['error_description'] || 'Unknown error'}"
      end

      parsed_response['access_token']
    end

  end
end
