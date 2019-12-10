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

  #TODO: REMOVE
  # describe "GET new" do
  #   it "should be successful" do
  #     get :new
  #     expect(response).to render_template(:new)
  #   end
  # end

  # # TODO Remove!
  # describe "POST create" do
  #   it "should be successful" do
  #     post :create, params: { tab: { key: 'a_tab', position: 0 } }
  #     expect(response).to be_redirect
  #   end
  # end
end
