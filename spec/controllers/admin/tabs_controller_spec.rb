require 'spec_helper'

describe Admin::TabsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let!(:tab) { FactoryGirl.create :tab }

  before do
    login_as(admin)
  end

  describe "GET index" do
    it "should be successful" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET new" do
    it "should be successful" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    it "should be successful" do
      post :create, :tab => { :key => 'a_tab' }
      response.should be_redirect
    end
  end
end
