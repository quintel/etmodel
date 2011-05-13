require 'spec_helper'

describe Admin::ViewNodesController do
  let(:admin) { Factory :admin }
  let!(:root_node) { Factory :root_node }
  
  before do
    login_as(admin)
  end
  
  describe "GET index" do
    it "should be successful" do
      get :index
      response.should render_template(:index)
    end
  end
end
