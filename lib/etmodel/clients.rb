# frozen_string_literal: true

module ETModel
  # Handles the clients.
  module Clients
    module_function

    # Returns the Faraday client which should be used to communicate with MyETM. This contains the
    # user authentication token if the user is logged in.
    def idp_client(user)
      @idp_client ||= begin
        client(
          Settings.idp_url,
          ETModel::TokenDecoder.fetch_token(user)
        )
      end
    end

    def engine_client(user)
      @engine_client ||= begin
        client(
          Settings.ete_url,
          ETModel::TokenDecoder.fetch_token(user, engine = true)
        )
      end
    end

    private

    def client(url, token)
      Faraday.new(url) do |conn|
        conn.request :authorization, 'Bearer', token
        conn.request :json
        conn.response :json
        conn.response :raise_error
      end
    end
  end
end
