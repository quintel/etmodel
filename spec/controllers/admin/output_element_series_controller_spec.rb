require 'spec_helper'

describe Admin::OutputElementSeriesController, type: :controller do
  let!(:serie) { FactoryGirl.create :output_element_serie }
  let(:admin) { FactoryGirl.create :admin }

   before do
    login_as(admin)
   end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => OutputElementSerie.first
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
      post :create, :output_element_serie => FactoryGirl.attributes_for(:output_element_serie)
      new_serie = assigns(:output_element_serie)
      response.should redirect_to(admin_output_element_serie_path(:id => new_serie.id))
    end
  end

  describe "update" do
    before do
      @output_element_serie = OutputElementSerie.first
      OutputElementSerie.should_receive(:find).with(any_args).and_return(@output_element_serie)
    end

    it "update action should render edit template when model is invalid" do
      @output_element_serie.stub(:update_attributes).with(any_args).and_return(false)
      put :update, :id => @output_element_serie
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      @output_element_serie.stub(:update_attributes).with(any_args).and_return(true)
      put :update, :id => @output_element_serie
      response.should redirect_to(admin_output_element_serie_path(:id => @output_element_serie.id))
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => serie.id
    response.should render_template(:edit)
  end


  it "destroy action should destroy model and redirect to index action" do
    output_element_serie = FactoryGirl.create :output_element_serie
    delete :destroy, :id => output_element_serie.id
    response.should redirect_to([:admin, output_element_serie.output_element])
    OutputElementSerie.exists?(output_element_serie.id).should be(false)
  end
end
