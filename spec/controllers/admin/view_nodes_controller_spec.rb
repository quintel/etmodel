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
  
  describe "POST create" do
    describe " a root node" do
      it "should be created" do
        post :create, :view_node => { :key => 'a_root_node' }
        assigns(:view_node).should be_a(ViewNode::Root)
        response.should be_redirect
      end
    end
  end
  
  describe "GET show" do
    before do
      get :show, :id => root_node.id
    end
    
    it { should respond_with(:success) }
    it { should render_template :show }
  end
end
