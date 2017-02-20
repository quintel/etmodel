require 'spec_helper'

describe Admin::SlidesController, type: :controller do
  let!(:slide) { FactoryGirl.create :slide }

  before(:each) do
    login_as(FactoryGirl.create(:admin))
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  describe "create" do
    it "create action should render new template when model is invalid" do
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      post :create, :slide => FactoryGirl.attributes_for(:slide)
      response.should redirect_to(admin_slides_path)
    end
  end

  describe "update" do
    before do
      @slide = FactoryGirl.create :slide
    end

    it "update action should render edit template when model is invalid" do
      put :update, :id => @slide, :slide => {:key => ''}
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      put :update, :id => @slide, :slide => {:key => 'abc'}
      response.should redirect_to(admin_slides_path)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => slide.id
    response.should render_template(:edit)
  end

  it "destroy action should destroy model and redirect to index action" do
    slide = FactoryGirl.create :slide
    delete :destroy, :id => slide.id
    response.should redirect_to(admin_slides_path)
    Slide.exists?(slide.id).should be(false)
  end
end
