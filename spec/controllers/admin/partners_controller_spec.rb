require 'spec_helper'

describe Admin::PartnersController do
  render_views
  let!(:partner)   { Factory.create :partner }

  before do
    controller.class.skip_before_filter :restrict_to_admin

    ActiveResource::HttpMock.respond_to do |mock|
      area = [{ :id => 1, :country => 'nl', :use_network_calculations => false}].to_json(:root => "area")
      mock.get "/api/v3/areas.json?country=nl", { "Accept" => "application/json" }, area
      mock.get "/api/v3/areas.json", { "Accept" => "application/json" }, area
    end
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
      @old_partner_count = Partner.count
      post :create, :partner => Factory.attributes_for(:partner)
    end

    it "should create a new partner" do
      Partner.count.should == @old_partner_count + 1
    end

    it { should redirect_to(admin_partner_path(Partner.last))}
  end

  describe "GET show" do
    before do
      get :show, :id => partner.id
    end

    it { should respond_with(:success)}
    it { should render_template :show}
  end

  describe "GET edit" do
    before do
      get :edit, :id => partner.id
    end

    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @partner = Factory.create :partner
      put :update, :id => @partner.id, :partner => { :name => "McDonald's"}
    end

    it { should redirect_to(admin_partner_path(@partner)) }
  end

  describe "DELETE destroy" do
    before do
      @partner = Factory.create :partner
      @old_partner_count = Partner.count
      delete :destroy, :id => @partner.id
    end

    it "should delete the partner" do
      Partner.count.should == @old_partner_count - 1
    end
    it { should redirect_to(admin_partners_path)}
  end
end
