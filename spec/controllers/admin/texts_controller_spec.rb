require 'spec_helper'

describe Admin::TextsController, type: :controller do
  let!(:text) { FactoryGirl.create :text }

  before(:each) do
    login_as(FactoryGirl.create(:admin))
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  describe "create" do
    it "create action should render new template when model is invalid" do
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      post :create, :text => FactoryGirl.attributes_for(:text)
      response.should redirect_to(admin_texts_path)
    end
  end

  describe "update" do
    before do
      @text = FactoryGirl.create :text
    end

    it "update action should render edit template when model is invalid" do
      put :update, :id => @text, :text => {:key => ''}
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      put :update, :id => @text, :text => {:key => 'abc'}
      response.should redirect_to(admin_texts_path)
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => text.id
    response.should render_template(:edit)
  end

  it "destroy action should destroy model and redirect to index action" do
    text = FactoryGirl.create :text
    delete :destroy, :id => text.id
    response.should redirect_to(admin_texts_path)
    Text.exists?(text.id).should be(false)
  end
end
