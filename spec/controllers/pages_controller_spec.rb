require 'spec_helper'

describe PagesController, :vcr => true do
  render_views

  before do
    ApplicationController.stub!(:ensure_valid_browser)
  end

  {'nl' => 2030, 'de' => 2050}.each do |country, year|
    describe "selecting #{country} #{year}" do
      before do
        post :root, :area_code => country, :end_year => year
      end

      specify { response.should redirect_to(play_path) }
      specify { session[:setting].end_year.should == year }
      specify { session[:setting].area_code.should == country }
    end
  end

  context "setting custom year values" do
    it "should have custom year field" do
      get :root
      response.should have_selector("form") do |form|
        form.should have_selector("select", :name => 'other_year')
      end
    end

    it "should not select custom year values if it's not selected" do
      post :root, :area_code => "nl", :other_year => '2034'
      session[:setting].end_year.should_not == 2034
    end

    it "should not select other field" do
      post :root, :area_code => "nl", :end_year => 'other', :other_year => '2036'
      session[:setting].end_year.should == 2036
    end
  end

  context :static_pages do
    [ :bugs, :units, :browser_support, :disclaimer,
      :privacy_statement].each do |page|
      describe "#{page} page" do
        it "should work" do
          get page
          response.should be_success
          response.should render_template(page)
        end
      end
    end
  end

  context "setting locale" do
    it "should set the locale and redirect" do
      post :set_locale, :locale => 'nl'
      response.should be_redirect
      I18n.locale.should == :nl
    end
  end

  describe "#choose" do
    it "should render correctly" do
      get :choose
      expect(response).to be_success
      expect(response).to render_template(:choose)
    end
  end

  describe "#prominent_users" do
    it "should render correctly" do
      get :prominent_users
      expect(response).to be_success
      expect(response).to render_template(:prominent_users)
    end
  end

  context "hidden setting pages" do
    [:show_all_countries, :show_flanders].each do |p|
      describe "pages##{p}" do
        it "should update the session variable and redirect to home page" do
          get p
          expect(session[p]). to be_true
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "#info" do
    it "should render title and description" do
      s = FactoryGirl.create :sidebar_item, :section => 'foo', :key => 'bar'
      t = FactoryGirl.create :text, :key => 'foo_bar'

      get :info, :ctrl => 'foo', :act => 'bar'
      expect(response).to be_success
      expect(response).to render_template(:info)
    end
  end

  describe "#feedback" do
    it "should render the form" do
      xhr :get, :feedback
      expect(response).to be_success
      expect(response).to render_template(:feedback)
    end

    it "should let the user post some feedback and send a couple emails" do
      ActionMailer::Base.deliveries = []
      xhr :post, :feedback, :feedback => {
        :name => 'Schwarzenegger',
        :email => 'arnold@quintel.com',
        :msg => "I'll be back"
      }, :format => :js
      expect(response).to be_success
      expect(response).to render_template(:feedback)
      emails = ActionMailer::Base.deliveries
      expect(emails.size).to eql(2)

      quintel = emails.first
      user = emails.last
      expect(quintel.to[0]).to eql("john.kerkhoven@quintel.com")
      expect(quintel.to[1]).to eql("dennis.schoenmakers@quintel.com")
      expect(user.to[0]).to eql('arnold@quintel.com')
    end
  end
end
