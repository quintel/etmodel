require 'spec_helper'

describe Admin::TabsController do
  let(:admin) { FactoryGirl.create :admin }
  let!(:tab) { FactoryGirl.create :tab }

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

  describe "POST create" do
    it "should be successful" do
      post :create, :tab => { :key => 'a_tab' }
      expect(response).to be_redirect
    end
  end
end
