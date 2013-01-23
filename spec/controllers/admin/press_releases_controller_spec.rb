require 'spec_helper'

describe Admin::PressReleasesController do
  render_views

  let!(:press_release) { FactoryGirl.create :press_release }

  before(:each) do
    controller.class.skip_before_filter :restrict_to_admin
  end

  describe "index" do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "new" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "create" do
    it "create action should render new template when model is invalid" do
      post :create, :press_release => {}
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      post :create, :press_release => FactoryGirl.attributes_for(:press_release)
      response.should redirect_to(admin_press_releases_path)
    end
  end

  describe "update" do
    before do
      @press_release = FactoryGirl.create :press_release
    end

    it "update action should render edit template when model is invalid" do
      put :update, :id => @press_release.id, :press_release => {:title => ''}
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      put :update, :id => @press_release.id, :press_release => {:title => 'abc'}
      response.should redirect_to(admin_press_releases_path)
    end
  end

  describe "edit" do
    it "edit action should render edit template" do
      get :edit, :id => press_release.id
      response.should render_template(:edit)
    end
  end

  describe "destroy" do
    it "destroy action should destroy model and redirect to index action" do
      press_release = FactoryGirl.create :press_release
      delete :destroy, :id => press_release.id
      response.should redirect_to(admin_press_releases_path)
    end
  end

  describe "upload" do
    it "should upload a file" do
      file = fixture_file_upload('/tabs.yml', 'text/yml')
      post :upload, :press_file => file
      expect(response).to redirect_to(admin_press_releases_path)
    end
  end
end
