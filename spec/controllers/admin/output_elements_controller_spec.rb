require 'rails_helper'

describe Admin::OutputElementsController do
  let!(:output_element) { FactoryGirl.create :output_element }

  before do
    login_as(FactoryGirl.create(:admin))
  end

  it "index action should render index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    get :show, params: { id: output_element.id }
    expect(response).to render_template(:show)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  describe "create" do
    it "create action should render new template when model is invalid" do
      post :create
      expect(response).to render_template(:new)
    end

    it "create action should redirect when model is valid" do
      post :create, params: {
        output_element: FactoryGirl.attributes_for(:output_element).merge(output_element_type_id: 1)
      }

      expect(response).to redirect_to(admin_output_elements_path)
    end
  end

  describe "update" do
    before do
      @output_element = FactoryGirl.create :output_element
    end

    it "update action should render edit template when model is invalid" do
      put :update, params: { id: @output_element, output_element: { key: '' } }
      expect(response).to render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      put :update, params: {
        id: @output_element, output_element: { key: 'abc' }
      }

      expect(response).to redirect_to(admin_output_elements_path)
    end
  end

  it "edit action should render edit template" do
    get :edit, params: { id: output_element.id }
    expect(response).to render_template(:edit)
  end

  it "destroy action should destroy model and redirect to index action" do
    output_element = FactoryGirl.create :output_element

    delete :destroy, params: { id: output_element.id }

    expect(response).to redirect_to(admin_output_elements_path)
    expect(OutputElement.exists?(output_element.id)).to be(false)
  end
end
