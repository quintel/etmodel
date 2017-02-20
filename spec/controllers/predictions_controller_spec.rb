require 'spec_helper'

describe PredictionsController, type: :controller do
  let(:prediction) { FactoryGirl.create :prediction}

  before do
    Setting.any_instance.stub(:area_code).and_return('nl')
  end

  describe "GET index" do
    before do
      xhr :get, :index, :input_element_id => prediction.input_element.id
    end

    it { response.should be_success }
    it { response.should render_template :index }
  end

  describe "GET show" do
    before do
      xhr :get, :show, :id => prediction.id
    end

    it { response.should be_success }
    it { response.should render_template :show }
  end

  describe "GET share" do
    before do
      get :share, :id => prediction.id
    end

    it { response.should be_success }
    it { response.should render_template :index}
  end
end
