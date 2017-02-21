require 'spec_helper'

describe Admin::SlidesController do
  let!(:slide) { FactoryGirl.create :slide }

  before(:each) do
    login_as(FactoryGirl.create(:admin))
  end

  it "index action should render index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  describe "create" do
    it "create action should render new template when model is invalid" do
      post :create
      expect(response).to render_template(:new)
    end

    it "create action should redirect when model is valid" do
      post :create, slide: FactoryGirl.attributes_for(:slide)
      expect(response).to redirect_to(admin_slides_path)
    end
  end

  describe "update" do
    before do
      @slide = FactoryGirl.create :slide
    end

    it "update action should render edit template when model is invalid" do
      put :update, id: @slide, slide: {key: ''}
      expect(response).to render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      put :update, id: @slide, slide: {key: 'abc'}
      expect(response).to redirect_to(admin_slides_path)
    end
  end

  it "edit action should render edit template" do
    get :edit, id: slide.id
    expect(response).to render_template(:edit)
  end

  it "destroy action should destroy model and redirect to index action" do
    slide = FactoryGirl.create :slide
    delete :destroy, id: slide.id
    expect(response).to redirect_to(admin_slides_path)
    expect(Slide.exists?(slide.id)).to be(false)
  end
end
