# frozen_string_literal: true

require 'rails_helper'

describe Admin::GqlController do
  before do
    login_as(FactoryBot.create(:admin))
  end

  describe "GET 'search'" do
    it 'is successful' do
      get 'search'
      expect(response).to have_http_status(:success)
    end
  end
end
