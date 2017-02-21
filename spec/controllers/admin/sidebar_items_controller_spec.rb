require 'spec_helper'

describe Admin::SidebarItemsController do
  let(:admin) { FactoryGirl.create :admin }
  let!(:sidebar_item) { FactoryGirl.create :sidebar_item }

  before do
    login_as(admin)
  end

  describe "GET index" do
    it "should be successful" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    it "should be successful" do
      get :new
      expect(response).to render_template(:new)
    end
  end
end
