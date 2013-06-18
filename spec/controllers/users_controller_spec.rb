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

  describe '#unsubscribe' do

    context 'with a formerly interested subscriber' do

      before do
        @user = FactoryGirl.create(:user, allow_news: true)
        get :unsubscribe, id: @user.id, h: @user.hash
        @user.reload
      end

      it 'registers in the database' do
        expect(@user.allow_news).to be_false
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
        @user = FactoryGirl.create(:user, allow_news: false)
        get :unsubscribe, id: @user.id, h: @user.hash
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
        @user = FactoryGirl.create(:user, allow_news: true)
        get :unsubscribe, id: @user.id, h: 'i-am-a-hacker'
        @user.reload
      end

      it 'does not register in the database' do
        expect(@user.allow_news).to be_true
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
    describe "when teacher email is provided" do
      context "and it is valid" do
        before(:each) do
          @teacher = FactoryGirl.create(:user)
        end

        it "assigns a correct teacher_id to the user" do
          expect {
            post :create, { user: {
              name: 'Student one',
              email: 'stu@quintel.com',
              password: '12345',
              password_confirmation: '12345'
            },
              teacher_email: @teacher.email
            }
          }.to change{ User.count }
          expect(User.last.teacher_id).to eql @teacher.id
        end
      end
      context "and it is not valid" do
        before(:each) do
          @teacher = FactoryGirl.create(:user)
        end

        it "does not assign a teacher_id to the new user" do
          expect {
            post :create, { user: {
              name: 'Student one',
              email: 'stu@quintel.com',
              password: '12345',
              password_confirmation: '12345'
            },
              teacher_email: ''
            }
          }.to change{ User.count }
          expect(User.last.teacher_id).to be_nil
        end
      end

    end
  end
end
