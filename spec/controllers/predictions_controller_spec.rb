require 'spec_helper'

describe PredictionsController do
    render_views
    let(:prediction) { Factory :prediction}

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
end
