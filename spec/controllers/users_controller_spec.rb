# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  render_views

  let(:user) { FactoryBot.create(:user) }

  describe '#new' do
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end

    it 'shows the signup form' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#unsubscribe' do
    context 'with a formerly interested subscriber' do
      let(:user) { FactoryBot.create(:user, allow_news: true) }

      before do
        get :unsubscribe, params: { id: user.id, h: user.md5_hash }
        user.reload
      end

      it 'registers in the database' do
        expect(user.allow_news).to be(false)
      end

      it 'renders a page succesfully' do
        expect(response).to be_successful
      end

      it 'shows you have been unsubscribed' do
        expect(response.body).to match(/You have been unsubscribed/i)
      end
    end

    context 'with an already signed-out user' do
      let(:user) { FactoryBot.create(:user, allow_news: false) }

      before do
        get :unsubscribe, params: { id: user.id, h: user.md5_hash }
        user.reload
      end

      it 'renders a page succesfully' do
        expect(response).to be_successful
      end

      it 'shows you have been unsubscribed ALREADY' do
        expect(response.body).to match(/already/i)
      end
    end

    context 'with invalid hash' do
      let(:user) { FactoryBot.create(:user, allow_news: true) }

      before do
        get :unsubscribe, params: { id: user.id, h: 'i-am-a-hacker' }
        user.reload
      end

      it 'does not register in the database' do
        expect(user.allow_news).to be(true)
      end

      it 'renders a page succesfully' do
        expect(response).to be_successful
      end

      it 'shows that user has not been unsubscribed' do
        expect(response.body).to match(/cannot unsubscribe/i)
      end
    end
  end

  describe '#create' do
    let(:user_attributes) do
      {
        name: 'Rocky Balboa',
        email: 'rb@quintel.com',
        password: 'adriana_',
        password_confirmation: 'adriana_'
      }
    end

    let(:request) do
      post :create, params: { user: user_attributes }
    end

    context 'with valid attributes' do
      it 'creates a new user' do
        expect { request }.to change(User, :count).by(1)
      end

      it 'redirects' do
        request
        expect(response).to be_redirect
      end
    end

    context 'with invalid attributes' do
      let(:user_attributes) do
        super().merge(password: nil)
      end

      it 'does not create a new user' do
        expect { request }.not_to change(User, :count)
      end

      it 'renders the signup form' do
        request
        expect(response).to render_template(:new)
      end
    end

    describe 'when teacher email is provided' do
      context 'when the user is valid' do
        let(:teacher) { FactoryBot.create(:user) }

        it 'assigns a correct teacher_id to the user' do
          expect do
            post :create, params: { user: {
              name: 'Student one',
              email: 'stu@quintel.com',
              teacher_email: teacher.email,
              password: '12345678',
              password_confirmation: '12345678'
            } }
          end.to change(User, :count)

          expect(User.last.teacher_id).to eql teacher.id
        end
      end
    end
  end

  describe '#edit' do
    context 'when user wants to edit his own profile' do
      before do
        login_as user
      end

      it 'the system finds a correct user' do
        get :edit, params: { id: user }
        expect(response).to be_successful
        expect(assigns(:user)).to eql user
      end
    end

    context "when user wants to edit another user's account" do
      it 'he is redirected to the home page' do
        get :edit, params: { id: user }
        expect(response).to redirect_to(:root)
      end
    end
  end

  describe '#update' do
    before do
      login_as user
    end

    context 'with valid parameters' do
      it "updates user's account" do
        user.name = 'Shiny'
        post :update, params: { id: user, user: user.attributes }
        expect(response).to redirect_to(edit_user_path)
      end
    end

    context 'with invalid parameters' do
      it "does not update user's account" do
        user.name = ''
        post :update, params: { id: user, user: user.attributes }

        expect(response).to render_template(:edit)

        expect(response.body)
          .to have_selector('input#user_name', text: user.name)

        expect(response.body)
          .to have_selector('span.error', text: "can't be blank")
      end
    end
  end

  describe '#destroy' do
    let!(:user) do
      FactoryBot.create(
        :user,
        password: 'my-password',
        password_confirmation: 'my-password'
      )
    end

    let(:password) { '' }
    let(:request) { delete(:destroy, params: { password: password }) }

    context 'when signed in as a guest' do
      it 'redirects to the root' do
        expect(request).to be_redirect
      end
    end

    context 'with the correct user password' do
      let(:password) { 'my-password' }

      before { login_as(user) }

      it 'redirects to the root' do
        expect(request).to be_redirect
      end

      it 'deletes the account' do
        expect { request }.to change(User, :count).by(-1)
      end

      it 'deletes saved scenarios' do
        FactoryBot.create(:saved_scenario, user: user)
        expect { request }.to change(SavedScenario, :count).by(-1)
      end
    end

    context 'with an incorrect user password' do
      let(:password) { 'wrong-password' }

      before { login_as(user) }

      it 'shows the confirmation form' do
        expect(request.body).to have_selector('input.mistake')
      end

      it 'does not delete the account' do
        expect { request }.not_to change(User, :count)
      end
    end

    context 'with an empty password' do
      let(:password) { '' }

      before { login_as(user) }

      it 'shows the confirmation form' do
        expect(request.body).to have_selector('input.mistake')
      end

      it 'does not delete the account' do
        expect { request }.not_to change(User, :count)
      end
    end

    context 'with no password' do
      let(:password) { nil }

      before { login_as(user) }

      it 'shows the confirmation form' do
        expect(request.body).to have_selector('input.mistake')
      end

      it 'does not delete the account' do
        expect { request }.not_to change(User, :count)
      end
    end
  end
end
