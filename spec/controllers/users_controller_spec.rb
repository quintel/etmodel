require 'spec_helper'

describe UsersController do
  render_views

  describe "#new" do
    it "should show the signup form" do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    it "should create a new user" do
      expect {
        post :create, :user => {
          :name => 'Rocky Balboa',
          :email => 'rb@quintel.com',
          :password => 'adriana',
          :password_confirmation => 'adriana'
        }
        expect(response).to be_redirect
      }.to change{ User.count }
    end

    it "should not create a new user with invalid data" do
      expect {
        post :create, :user => {
          :name => 'Rocky Balboa',
          :email => 'rb@quintel.com'
        }
        expect(response).to render_template(:new)
      }.to_not change{ User.count }
    end
  end
end
