require 'spec_helper'

describe Admin::PredictionValuesController do
  render_views
  let!(:prediction_value) { Factory :prediction_value }
  
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
      @old_prediction_value_count = PredictionValue.count
      post :create, :prediction_value => Factory.attributes_for(:prediction_value)
    end
        
    it "should create a new prediction_value" do
      PredictionValue.count.should == @old_prediction_value_count + 1
    end
  end


  describe "GET edit" do
    before do
      get :edit, :id => prediction_value.id
    end
    
    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @prediction_value = Factory :prediction_value
      put :update, :id => @prediction_value.id, :prediction_value => { :max => 8}
    end
    
    it { should redirect_to(admin_prediction_path(@prediction_value.prediction)) }
  end

  describe "DELETE destroy" do
    before do
      @prediction_value = Factory :prediction_value
      @old_prediction_value_count = PredictionValue.count
      delete :destroy, :id => @prediction_value.id
    end
    
    it "should delete the prediction_value" do
      PredictionValue.count.should == @old_prediction_value_count - 1
    end
    it { should redirect_to(admin_predictions_path)}
  end

end
