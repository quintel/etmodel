require 'rails_helper'

RSpec.describe PasswordResetsController do
  let!(:user) {
    FactoryBot.create(:user, email: "test@test.com", perishable_token: "123")
  }

  it "visits new path" do
    get :new

    expect(response).to be_success
  end

  it "can't visit new path when signed in" do
    login_as user

    get :new

    expect(response).to redirect_to(root_path)
  end

  describe "#create" do
    it "requests unsuccessfully with unknown email" do
      post :create, params: { user: { email: "does-not-exist" } }

      expect(response).to redirect_to(login_path)
    end

    it "requests unsuccessfully when signed in" do
      login_as user

      post :create, params: { user: { email: user.email } }

      expect(response).to redirect_to(root_path)
    end

    it "requests successfully" do
      post :create, params: { user: { email: user.email } }

      expect(response).to redirect_to(login_path)
    end

    it "resets the perishable token" do
      old_token = user.perishable_token

      post :create, params: { user: { email: user.email } }

      expect(user.reload.perishable_token).to_not eq(old_token)
    end
  end

  describe "#edit" do
    it "requests successfully" do
      get :edit, params: { id: user.perishable_token }

      expect(response).to be_success
    end

    it "requests unsuccessfully" do
      get :edit, params: { id: 'does-not-work' }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "#update" do
    # When password to short
    it "renders edit" do
      put :update, params: {
        user: { password: "123" }, id: user.perishable_token
      }

      expect(response).to render_template(:edit)
    end

    # When incorrect token
    it "renders edit" do
      put :update, params: {
        user: { password: "123aapnootmies" }, id: "no-id"
      }

      expect(response).to redirect_to(root_path)
    end

    # When correct
    context "updates the password of a user" do
      context 'valid' do
        it 'succeeds' do
          old_password = user.crypted_password

          put :update, params: {
            id: user.perishable_token,
            user: {
              password: '123aapnootmies',
              password_confirmation: '123aapnootmies',
            }
          }

          expect(user.reload.crypted_password).to_not eq(old_password)
        end
      end

      context 'invalid' do
        it 'too short' do
          old_password = user.crypted_password

          put :update, params: {
            user: { password: '123' }, id: user.perishable_token
          }

          expect(response).to render_template(:edit)
        end

        it 'mismatch in passwords' do
          old_password = user.crypted_password

          put :update, params: {
            id: user.perishable_token,
            user: {
              password: '123aapnootmies',
              password_reset: '1233434'
            }
          }

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
