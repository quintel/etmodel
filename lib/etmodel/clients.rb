# frozen_string_literal: true

module ETModel
  # Handles the clients.
  module Clients
    module_function

    # Returns the Faraday client which should be used to communicate with MyETM. This contains the
    # user authentication token if the user is logged in.
    def idp_client(user = nil)
      @idp_client ||= begin
        token = user ? ETModel::TokenDecoder.fetch_token(user) : nil
        client(Settings.idp_url, token)
      end
    end

    def engine_client(user = nil)
      @engine_client ||= begin
        token = user ? ETModel::TokenDecoder.fetch_token(user, true) : nil
        client(Settings.ete_url, token)
      end
    end

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
