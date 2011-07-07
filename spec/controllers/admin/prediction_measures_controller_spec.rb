require 'spec_helper'

describe Admin::PredictionMeasuresController do
  render_views
  let!(:prediction_measure) { Factory :prediction_measure }
  before do
    controller.class.skip_before_filter :restrict_to_admin
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
      @old_prediction_measure_count = PredictionMeasure.count
      post :create, :prediction_measure => Factory.attributes_for(:prediction_measure)
    end
        
    it "should create a new prediction_measure" do
      PredictionMeasure.count.should == @old_prediction_measure_count + 1
    end
  end


  describe "GET edit" do
    before do
      get :edit, :id => prediction_measure.id
    end
    
    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @prediction_measure = Factory :prediction_measure
      put :update, :id => @prediction_measure.id, :prediction_measure => { :cost => 8}
    end
    
    it { should redirect_to(admin_prediction_path(@prediction_measure.prediction)) }
  end

  describe "DELETE destroy" do
    before do
      @prediction_measure = Factory :prediction_measure
      @old_prediction_measure_count = PredictionMeasure.count
      delete :destroy, :id => @prediction_measure.id
    end
    
    it "should delete the prediction_measure" do
      PredictionMeasure.count.should == @old_prediction_measure_count - 1
    end
    it { should redirect_to(admin_predictions_path)}
  end

end
