require 'spec_helper'

describe Admin::ConstraintsController, type: :controller do
  render_views

  let!(:constraint) { FactoryGirl.create :constraint }
  let!(:admin) { FactoryGirl.create :admin }

  before do
    login_as(admin)
  end

  describe "GET index" do
    let(:response) { get(:index) }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:index) }
  end

  describe "GET new" do
    let(:response) { get(:new) }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:new) }
  end

  describe "POST create" do
    before do
      @old_constraint_count = Constraint.count
      post :create, :constraint => FactoryGirl.attributes_for(:constraint)
    end

    it "should create a new constraint" do
      Constraint.count.should == @old_constraint_count + 1
    end

    it { should redirect_to(admin_constraint_path(assigns(:constraint)))}
  end

  describe "GET show" do
    let(:response) { get(:show, id: constraint.id) }

    it { expect(response).to be_success}
    it { expect(response).to render_template :show}
  end

  describe "GET edit" do
    let(:response) { get(:edit, id: constraint.id) }

    it { expect(response).to be_success}
    it { expect(response).to render_template :edit}
  end

  describe "PUT update" do
    before do
      @constraint = FactoryGirl.create :constraint
      put :update, :id => @constraint.id, :constraint => { :key => 'yo'}
    end

    it { should redirect_to(admin_constraint_path(@constraint)) }
  end

  describe "DELETE destroy" do
    before do
      @constraint = FactoryGirl.create :constraint
      @old_constraint_count = Constraint.count
      delete :destroy, :id => @constraint.id
    end

    it "should delete the constraint" do
      Constraint.count.should == @old_constraint_count - 1
    end
    it { should redirect_to(admin_constraints_path)}
  end
end
