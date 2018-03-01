require 'rails_helper'

describe UsersController do
  render_views

  let(:user) { FactoryBot.create(:user) }

  describe "#new" do
    it "should show the signup form" do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe '#unsubscribe' do

    context 'with a formerly interested subscriber' do

      before do
        @user = FactoryBot.create(:user, allow_news: true)
        get :unsubscribe, params: { id: @user.id, h: @user.md5_hash }
        @user.reload
      end

      it 'registers in the database' do
        expect(@user.allow_news).to be(false)
      end

      it 'renders a page succesfully' do
        expect(response).to be_success
      end

      it 'shows you have been unsubscribed' do
        expect(response.body).to match(/You have been unsubscribed/i)
      end

    end

    context 'with an already signed-out user' do

      before do
        @user = FactoryBot.create(:user, allow_news: false)
        get :unsubscribe, params: { id: @user.id, h: @user.md5_hash }
        @user.reload
      end

      it 'renders a page succesfully' do
        expect(response).to be_success
      end

      it 'shows you have been unsubscribed ALREADY' do
        expect(response.body).to match(/already/i)
      end

    end

    context 'with invalid hash' do

      before do
        @user = FactoryBot.create(:user, allow_news: true)
        get :unsubscribe, params: { id: @user.id, h: 'i-am-a-hacker' }
        @user.reload
      end

      it 'does not register in the database' do
        expect(@user.allow_news).to be(true)
      end

      it 'renders a page succesfully' do
        expect(response).to be_success
      end

      it 'shows that user has not been unsubscribed' do
        expect(response.body).to match(/cannot unsubscribe/i)
      end

    end

  end

  describe "#create" do
    it "should create a new user" do
      expect {
        post :create, params: { user: {
          name: 'Rocky Balboa',
          email: 'rb@quintel.com',
          password: 'adriana_',
          password_confirmation: 'adriana_'
        } }
        expect(response).to be_redirect
      }.to change{ User.count }
    end

    it "should not create a new user with invalid data" do
      expect {
        post :create, params: { user: {
          name: 'Rocky Balboa',
          email: 'rb@quintel.com'
        } }

        expect(response).to render_template(:new)
      }.to_not change{ User.count }
    end
    describe "when teacher email is provided" do
      context "and it is valid" do
        before(:each) do
          @teacher = FactoryBot.create(:user)
        end

        it "assigns a correct teacher_id to the user" do
          expect {
            post :create, params: { user: {
              name: 'Student one',
              email: 'stu@quintel.com',
              teacher_email: @teacher.email,
              password: '12345678',
              password_confirmation: '12345678'
            } }
          }.to change{ User.count }

          expect(User.last.teacher_id).to eql @teacher.id
        end
      end
    end
  end

  describe "#edit" do
    context "when user wants to edit his own profile" do
      before(:each) do
        login_as user
      end

      it "the system finds a correct user" do
        get :edit, params: { id: user }
        expect(response).to be_success
        expect(assigns(:user)).to eql user
      end
    end

    context "when user wants to edit another user's account" do
      it "he is redirected to the home page" do
        get :edit, params: { id: user }
        expect(response).to redirect_to(:root)
      end
    end
  end

  describe "#update" do
    before(:each) do
      login_as user
    end

    context "with valid parameters" do
      it "updates user's account" do
        user.name = 'Shiny'
        post :update, params: { id: user, user: user.attributes }
        expect(response).to redirect_to(edit_user_path)
      end
    end

    context "with invalid parameters" do
      it "does not update user's account" do
        user.name = ''
        post :update, params: { id: user, user: user.attributes }

        expect(response).to render_template(:edit)

        expect(response.body)
          .to have_selector("input#user_name", text: user.name)

        expect(response.body)
          .to have_selector("span.error", text: "can't be blank")
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

    let!(:scenario) { FactoryBot.create(:saved_scenario, user: user) }

    let(:password) { '' }
    let(:request) { delete(:destroy, params: { password: password }) }

    context 'as a guest' do
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
        expect { request }.to change { User.count }.by(-1)
      end

      it 'deletes saved scenarios' do
        expect { request }.to change { SavedScenario.count }.by(-1)
      end
    end

    context 'with an incorrect user password' do
      let(:password) { 'wrong-password' }

      before { login_as(user) }

      it 'shows the confirmation form' do
        expect(request.body).to have_selector('input.mistake')
      end

      it 'does not delete the account' do
        expect { request }.to_not change { User.count }
      end
    end

    context 'with an empty password' do
      let(:password) { '' }

      before { login_as(user) }

      it 'shows the confirmation form' do
        expect(request.body).to have_selector('input.mistake')
      end

      it 'does not delete the account' do
        expect { request }.to_not change { User.count }
      end
    end

    context 'with no password' do
      let(:password) { nil }

      before { login_as(user) }

      it 'shows the confirmation form' do
        expect(request.body).to have_selector('input.mistake')
      end

      it 'does not delete the account' do
        expect { request }.to_not change { User.count }
      end
    end
  end
end
