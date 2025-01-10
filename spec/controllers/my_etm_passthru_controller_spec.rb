# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyEtmPassthruController, type: :controller do
  describe "GET #set_cookie_and_redirect" do
    let(:valid_path) { 'some_path' }

    context "when path param is provided" do
      it "sets the :etm_last_visited_page cookie and redirects to a valid destination" do
        get :set_cookie_and_redirect, params: { page: valid_path }

        expect(cookies[:etm_last_visited_page]).to eq(root_path)
        expect(response).to redirect_to("#{Settings.idp_url}/#{valid_path}")
      end
    end

    context "when path param is not provided" do
      it "sets the :etm_last_visited_page cookie and redirects to a valid destination" do
        get :set_cookie_and_redirect, params: { page: '' }

        expect(cookies[:etm_last_visited_page]).to eq(root_path)
        expect(response).to redirect_to("#{Settings.idp_url}/")
      end
    end
  end
end
