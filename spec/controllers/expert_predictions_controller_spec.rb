require 'spec_helper'

describe ExpertPredictionsController do
  render_views
  
  let(:slide) { Factory :slide }
  let(:output_element) { Factory :output_element }
  
  describe "GET index" do
    before do
      OutputElement.stub!(:find).and_return(output_element)
      xhr :get, :index, :slide_id => slide.id
    end
    
    it { response.should be_success }
    it { response.should render_template :index }
  end
  
end
