require 'spec_helper'

describe Admin::InterfacesController do
  render_views
  
  let!(:interface) { Factory :interface }
  let!(:admin) { Factory :admin }
  
  before do
    login_as(admin)
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
      @old_interface_count = Interface.count
      post :create, :interface => Factory.attributes_for(:interface)
    end
        
    it "should create a new interface" do
      Interface.count.should == @old_interface_count + 1
    end

    it { should redirect_to(admin_interface_path(assigns(:interface)))}
  end

  describe "GET show" do
    before do
      get :show, :id => interface.id
    end
    
    it { should respond_with(:success)}
    it { should render_template :show}
  end

  describe "GET edit" do
    before do
      get :edit, :id => interface.id
    end
    
    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @interface = Factory :interface
      put :update, :id => @interface.id, :interface => { :key => 'yo'}
    end
    
    it { should redirect_to(admin_interface_path(@interface)) }
  end

  describe "DELETE destroy" do
    before do
      @interface = Factory :interface
      @old_interface_count = Interface.count
      delete :destroy, :id => @interface.id
    end
    
    it "should delete the interface" do
      Interface.count.should == @old_interface_count - 1
    end
    it { should redirect_to(admin_interfaces_path)}
  end

end
