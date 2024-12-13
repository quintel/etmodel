# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedirectController, type: :controller do
  describe "GET #set_cookie_and_redirect" do
    let(:valid_path) { "/some_path" }
    let(:invalid_url) { "http://example.com/destination" }

    context "when return_to param is provided" do
      it "sets the :last_visited_page cookie to return_to param and redirects to a valid destination" do
        get :set_cookie_and_redirect, params: { return_to: valid_path, destination: valid_path }

        expect(cookies[:last_visited_page]).to eq valid_path
        expect(response).to redirect_to(valid_path)
      end
    end

    context "when return_to param is not provided" do
      it "sets the :last_visited_page cookie to root_path and redirects to a valid destination" do
        get :set_cookie_and_redirect, params: { destination: valid_path }

        expect(cookies[:last_visited_page]).to eq root_path
        expect(response).to redirect_to(valid_path)
      end
    end

    context "when destination is nil" do
      it "redirects to root_path" do
        get :set_cookie_and_redirect, params: { return_to: valid_path, destination: nil }

        expect(cookies[:last_visited_page]).to eq valid_path
        expect(response).to redirect_to(root_path.chomp("/"))
      end
    end
  end
end
