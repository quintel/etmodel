require 'spec_helper'

describe Admin::QueryTablesController do
  before(:all) { Authorization.ignore_access_control(true) }
  after(:all)  { Authorization.ignore_access_control(false) }

  before(:each) do
    @query_table = QueryTable.new(:column_count => 3, :row_count => 3)
    @query_table.save(false)
  end

  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => QueryTable.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  describe "create" do
    before do
      @q = QueryTable.new 
      QueryTable.should_receive(:new).with(any_args).and_return(@q)
    end

    it "create action should render new template when model is invalid" do
      @q.stub!(:valid?).and_return(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      @q.stub!(:valid?).and_return(true)
      post :create
      response.should redirect_to(admin_query_table_url(assigns[:query_table]))
    end
  end

  describe "update" do
    before do
      @q = QueryTable.first 
      QueryTable.should_receive(:find).with(any_args).and_return(@q)
    end

    it "update action should render edit template when model is invalid" do
      @q.stub!(:valid?).and_return(false)
      put :update, :id => @q
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      @q.stub!(:valid?).and_return(true)
      put :update, :id => @q
      response.should redirect_to(admin_query_table_url(assigns[:query_table]))
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => QueryTable.first
    response.should render_template(:edit)
  end


  it "destroy action should destroy model and redirect to index action" do
    query_table = QueryTable.first
    delete :destroy, :id => query_table
    response.should redirect_to(admin_query_tables_url)
    QueryTable.exists?(query_table.id).should be_false
  end
end
