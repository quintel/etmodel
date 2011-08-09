require 'spec_helper'

describe Admin::CommentsController do
  render_views
  let!(:comment) { FactoryGirl.create :user_comment }
  
  before do
    controller.class.skip_before_filter :restrict_to_admin
  end
  
  describe "GET index" do
    before do
      get :index
    end
    
    it { should respond_with(:success)}
    it { should render_template :index}
  end

  describe "GET show" do
    before do
      get :show, :id => comment.id
    end
    
    it { should respond_with(:success)}
    it { should render_template :show}
  end

  describe "GET edit" do
    before do
      get :edit, :id => comment.id
    end
    
    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @comment = FactoryGirl.create :user_comment
      put :update, :id => @comment.id, :comment => { :body => 'another text'}
    end
    
    it { should redirect_to(admin_comment_path(@comment)) }
  end

  describe "DELETE destroy" do
    before do
      @comment = FactoryGirl.create :user_comment
      @comment_count = Comment.count
      delete :destroy, :id => @comment.id
    end
    
    it "should delete the comment" do
      Comment.count.should == @comment_count - 1
    end
    it { should redirect_to(admin_comments_path)}
  end
end
