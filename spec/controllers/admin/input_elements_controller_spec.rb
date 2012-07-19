require 'spec_helper'

describe Admin::InputElementsController do
  before(:each) do
    controller.class.skip_before_filter :restrict_to_admin
    @input_element = Factory :input_element
  end

  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  describe "create" do
    before do
      @input_element = InputElement.new
      InputElement.should_receive(:new).with(any_args).and_return(@input_element)
    end

    it "create action should render new template when model is invalid" do
      @input_element.stub!(:save).and_return(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      @input_element.stub!(:save).and_return(true)
      post :create
      response.should redirect_to(admin_input_elements_url)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => InputElement.first.id
    response.should render_template(:edit)
  end

  describe "update" do
    before do
      @input_element = InputElement.first.reload
      InputElement.should_receive(:find).with(any_args).and_return(@input_element)
    end

    it "update action should render edit template when model is invalid" do
      @input_element.stub!(:update_attributes).with(any_args).and_return(false)
      put :update, :id => @input_element
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      @input_element.stub!(:update_attributes).with(any_args).and_return(true)
      put :update, :id => @input_element
      response.should redirect_to(admin_input_elements_url)
    end
  end

  it "destroy action should destroy model and redirect to index action" do
    input_element = InputElement.first
    delete :destroy, :id => input_element
    response.should redirect_to(admin_input_elements_url)
    InputElement.exists?(input_element.id).should be_false
  end
end
