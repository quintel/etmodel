require 'spec_helper'

describe Admin::OutputElementSeriesController do
  before(:all) { Authorization.ignore_access_control(true); OutputElementSerie.new().save }
  after(:all)  { Authorization.ignore_access_control(false) }

#  before(:each) do
#    output_element_serie = OutputElementSerie.new().save
#    output_element_serie.save(false)
#  end

  render_views

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
    before do
      @output_element_serie = OutputElementSerie.new 
      OutputElementSerie.should_receive(:new).with(any_args).and_return(@output_element_serie)
    end

    it "create action should render new template when model is invalid" do
      @output_element_serie.stub!(:save).and_return(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      @output_element_serie.stub!(:save).and_return(true)
      post :create
      response.should redirect_to(admin_output_element_series_url)
    end
  end


  describe "update" do
    before do
      @output_element_serie = OutputElementSerie.first 
      OutputElementSerie.should_receive(:find).with(any_args).and_return(@output_element_serie)
    end

    it "update action should render edit template when model is invalid" do
      @output_element_serie.stub!(:update_attributes).with(any_args).and_return(false)
      put :update, :id => @output_element_serie
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      @output_element_serie.stub!(:update_attributes).with(any_args).and_return(true)
      put :update, :id => @output_element_serie
      response.should redirect_to(admin_output_element_series_url)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => OutputElementSerie.first
    response.should render_template(:edit)
  end


  it "destroy action should destroy model and redirect to index action" do
    output_element_serie = OutputElementSerie.first
    delete :destroy, :id => output_element_serie
    response.should redirect_to(admin_output_element_series_url)
    OutputElementSerie.exists?(output_element_serie.id).should be_false
  end
end
