require 'spec_helper'

describe Admin::AreasController do
  before(:all) { Authorization.ignore_access_control(true) }
  after(:all)  { Authorization.ignore_access_control(false) }

  #fixtures :all
  render_views

  before(:each) do
    @area = Area.new(:country => 'nl')
    @area.save(false)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Area.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  describe "create" do
    before do
      @area = Area.new
      Area.should_receive(:new).with(any_args).and_return(@area)
    end

    it "create action should render new template when model is invalid" do
      @area.stub!(:save).and_return(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      @area.stub!(:save).and_return(true)
      @area.stub!(:id).and_return(1)
      post :create
      response.should redirect_to(admin_areas_url)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => Area.first
    response.should render_template(:edit)
  end

  describe "update" do
    before do
      @area = Area.first
      @area.stub!(:id).and_return(1)
      Area.stub!(:find).with(any_args).and_return(@area)
    end

    it "update action should render edit template when model is invalid" do
      @area.stub!(:update_attributes).with(any_args).and_return(false)
      put :update, :id => @area
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      @area.stub!(:update_attributes).with(any_args).and_return(true)
      put :update, :id => @area
      response.should redirect_to(admin_area_url(assigns[:area]))
    end
  end

  it "destroy action should destroy model and redirect to index action" do
    area = Area.first
    delete :destroy, :id => area
    response.should redirect_to(admin_areas_url)
    Area.exists?(area.id).should be_false
  end
end
