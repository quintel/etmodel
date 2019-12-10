require 'rails_helper'

describe Admin::TabsController do
  let(:admin) { FactoryBot.create :admin }

  before do
    login_as(admin)
  end

  describe "GET index" do
    it "should be successful" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
