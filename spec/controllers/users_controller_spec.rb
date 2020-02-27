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

    context 'when the user wants to subscribe to the newsletter' do
      let(:user_attributes) do
        super().merge(allow_news: true)
      end

      it 'calls the CreateNewsletterSubscription service' do
        allow(CreateNewsletterSubscription).to receive(:call)
        request

        expect(CreateNewsletterSubscription)
          .to have_received(:call)
          .with(User.find_by_email('rb@quintel.com'))
      end
    end

    context 'when the user does not want to subscribe to the newsletter' do
      let(:user_attributes) do
        super().merge(allow_news: false)
      end

      it 'does not call the CreateNewsletterSubscription service' do
        allow(CreateNewsletterSubscription).to receive(:call)
        request
        expect(CreateNewsletterSubscription).not_to have_received(:call)
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

    context 'when subscribed to the newsletter' do
      before { user.update(allow_news: true) }

      let(:request) do
        post :update, params: {
          id: user.id,
          user: user.attributes.merge('allow_news' => true)
        }
      end

      it "doesn't create a new subscription when allow_news is unchanged" do
        allow(CreateNewsletterSubscription).to receive(:call)
        request
        expect(CreateNewsletterSubscription).not_to have_received(:call)
      end

      it "doesn't delete their subscription when allow_news is unchanged" do
        allow(DestroyNewsletterSubscription).to receive(:call)
        request
        expect(DestroyNewsletterSubscription).not_to have_received(:call)
      end
    end

    context 'when unsubscribed from the newsletter' do
      before { user.update(allow_news: false) }

      let(:request) do
        post :update, params: {
          id: user.id,
          user: user.attributes.merge('allow_news' => false)
        }
      end

      it "doesn't create a new subscription when allow_news is unchanged" do
        allow(CreateNewsletterSubscription).to receive(:call)
        request
        expect(CreateNewsletterSubscription).not_to have_received(:call)
      end

      it "doesn't delete their subscription when allow_news is unchanged" do
        allow(DestroyNewsletterSubscription).to receive(:call)
        request
        expect(DestroyNewsletterSubscription).not_to have_received(:call)
      end
    end

    context 'when subscribing to the newsletter' do
      before { user.update(allow_news: false) }

      let(:request) do
        post :update, params: {
          id: user.id,
          user: user.attributes.merge('allow_news' => true)
        }
      end

      it 'creates a subscription' do
        allow(CreateNewsletterSubscription).to receive(:call)
        request
        expect(CreateNewsletterSubscription).to have_received(:call).with(user)
      end
    end

    context 'when unsubscribing from the newsletter' do
      before { user.update(allow_news: true) }

      let(:request) do
        post :update, params: {
          id: user.id,
          user: user.attributes.merge('allow_news' => false)
        }
      end

      it 'removes their subscription' do
        allow(DestroyNewsletterSubscription).to receive(:call)
        request
        expect(DestroyNewsletterSubscription).to have_received(:call).with(user)
      end
    end

    context 'when subscibed to updates and changing e-mail address' do
      before { user.update(allow_news: true) }

      let(:request) do
        post :update, params: {
          id: user.id,
          user: user.attributes.merge('email' => 'new@quintel.com')
        }
      end

      it 'updates the subscription' do
        allow(UpdateNewsletterSubscription).to receive(:call)
        request
        expect(UpdateNewsletterSubscription).to have_received(:call).with(user)
      end
    end

    context 'when not subscribed to updates and changing e-mail address' do
      before { user.update(allow_news: false) }

      let(:request) do
        post :update, params: {
          id: user.id,
          user: user.attributes.merge('email' => 'new@quintel.com')
        }
      end

      it 'does not update the subscription' do
        allow(UpdateNewsletterSubscription).to receive(:call)
        request

        expect(UpdateNewsletterSubscription)
          .not_to have_received(:call).with(user)
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
