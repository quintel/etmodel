require 'spec_helper'

describe Admin::InputElementsController do
  let(:admin) { FactoryGirl.create :admin }

  before(:each) do
    @input_element = FactoryGirl.create :input_element
    login_as(admin)
  end

  it "index action should render index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  describe "create" do
    before do
      @input_element = InputElement.new
      expect(InputElement).to receive(:new).with(any_args).and_return(@input_element)
    end

    it "create action should render new template when model is invalid" do
      allow(@input_element).to receive(:save).and_return(false)
      post :create
      expect(response).to render_template(:new)
    end

    it "create action should redirect when model is valid" do
      allow(@input_element).to receive(:save).and_return(true)
      post :create
      expect(response).to redirect_to(admin_input_elements_url)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => InputElement.first.id
    expect(response).to render_template(:edit)
  end

  describe "update" do
    before do
      @input_element = InputElement.first.reload
      expect(InputElement).to receive(:find).with(any_args).and_return(@input_element)
    end

    it "update action should render edit template when model is invalid" do
      allow(@input_element).to receive(:update_attributes).with(any_args).and_return(false)
      put :update, :id => @input_element
      expect(response).to render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      allow(@input_element).to receive(:update_attributes).with(any_args).and_return(true)
      put :update, :id => @input_element
      expect(response).to redirect_to(admin_input_elements_url)
    end
  end

  it "destroy action should destroy model and redirect to index action" do
    input_element = InputElement.first
    delete :destroy, :id => input_element
    expect(response).to redirect_to(admin_input_elements_url)
    expect(InputElement.exists?(input_element.id)).to be(false)
  end
end
