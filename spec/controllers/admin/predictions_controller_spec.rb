require 'spec_helper'

describe Admin::PredictionsController, :vcr => true do
  render_views
  let(:input_element) { FactoryGirl.create :input_element }
  let!(:prediction)   { FactoryGirl.create :prediction }

  before do
    controller.class.skip_before_filter :restrict_to_admin
  end

  describe "GET index" do
    before do
      get :index
    end

    it { should respond_with(:success)}
    it { should render_template :index}
  end

  describe "GET new" do
    before do
      get :new
    end

    it { should respond_with(:success)}
    it { should render_template :new}
  end

  describe "POST create" do
    before do
      @old_prediction_count = Prediction.count
      attributes = FactoryGirl.attributes_for(:prediction).merge({:input_element_id => input_element.id})
      post :create, :prediction => attributes
    end

    it "should create a new prediction" do
      Prediction.count.should == @old_prediction_count + 1
    end

    it { should redirect_to(admin_predictions_path)}
  end

  describe "GET show" do
    before do
      get :show, :id => prediction.id
    end

    it { should respond_with(:success)}
    it { should render_template :show}
  end

  describe "GET edit" do
    before do
      get :edit, :id => prediction.id
    end

    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @prediction = FactoryGirl.create :prediction
      put :update, :id => @prediction.id, :prediction => { :description => 'this is a other description'}
    end

    it { should redirect_to(admin_predictions_path) }
  end

  describe "DELETE destroy" do
    before do
      @prediction = FactoryGirl.create :prediction
      @old_prediction_count = Prediction.count
      delete :destroy, :id => @prediction.id
    end

    it "should delete the prediction" do
      Prediction.count.should == @old_prediction_count - 1
    end
    it { should redirect_to(admin_predictions_path)}
  end
end
