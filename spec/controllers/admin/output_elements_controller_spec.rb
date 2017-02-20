require 'spec_helper'

describe Admin::OutputElementsController, type: :controller do
  let!(:output_element) { FactoryGirl.create :output_element }

  before do
    login_as(FactoryGirl.create(:admin))
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => output_element.id
    response.should render_template(:show)
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
      post :create, :output_element => FactoryGirl.attributes_for(:output_element).merge(:output_element_type_id => 1)
      response.should redirect_to(admin_output_elements_path)
    end
  end

  describe "update" do
    before do
      @output_element = FactoryGirl.create :output_element
    end

    it "update action should render edit template when model is invalid" do
      put :update, :id => @output_element, :output_element => {:key => ''}
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      put :update, :id => @output_element, :output_element => {:key => 'abc'}
      response.should redirect_to(admin_output_elements_path)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => output_element.id
    response.should render_template(:edit)
  end

  it "destroy action should destroy model and redirect to index action" do
    output_element = FactoryGirl.create :output_element
    delete :destroy, :id => output_element.id
    response.should redirect_to(admin_output_elements_path)
    OutputElement.exists?(output_element.id).should be(false)
  end
end
