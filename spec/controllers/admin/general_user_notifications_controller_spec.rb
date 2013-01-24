require 'spec_helper'

describe Admin::GeneralUserNotificationsController do
  render_views
  let!(:general_user_notification) { FactoryGirl.create :general_user_notification }

  before do
    controller.class.skip_before_filter :restrict_to_admin
  end

  describe "GET new" do
    before do
      get :new
    end

    it { should respond_with(:success)}
    it { should render_template :new}
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
      get :show, :id => general_user_notification.id
    end

    it { should respond_with(:success)}
    it { should render_template :show}
  end

  describe "GET edit" do
    before do
      get :edit, :id => general_user_notification.id
    end

    it { should respond_with(:success)}
    it { should render_template :edit}
  end

  describe "PUT update" do
    before do
      @general_user_notification = FactoryGirl.create :general_user_notification
      put :update, :id => @general_user_notification.id,
                   :general_user_notification => { :notification_en => 'another text'}
    end

    it { should redirect_to(admin_general_user_notifications_path) }
  end

  describe "DELETE destroy" do
    before do
      @general_user_notification = FactoryGirl.create :general_user_notification
      @general_user_notification_count = GeneralUserNotification.count
      delete :destroy, :id => @general_user_notification.id
    end

    it "should delete the GeneralUserNotification" do
      GeneralUserNotification.count.should == @general_user_notification_count - 1
    end
    it { should redirect_to(admin_general_user_notifications_path)}
  end
end
