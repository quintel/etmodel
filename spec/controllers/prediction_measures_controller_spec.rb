require 'spec_helper'

describe PredictionMeasuresController do
    render_views
    let(:input_element) { Factory :input_element }

    describe "GET index" do
       before do
         xhr :get, :index, :input_element_id => input_element.id
       end

       it { response.should be_success }
       it { response.should render_template :index }
     end

end
