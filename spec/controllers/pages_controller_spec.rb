require 'rails_helper'

describe PagesController, vcr: true do
  render_views

  {'nl' => 2030, 'de' => 2050}.each do |country, year|
    describe "selecting #{country} #{year}" do
      before do
        post :root, params: { area_code: country, end_year: year }
      end

      specify { expect(response).to redirect_to(play_path) }
      specify { expect(session[:setting].end_year).to eq(year) }
      specify { expect(session[:setting].area_code).to eq(country) }
    end
  end

  context "setting custom year values" do
    it "should have custom year field" do
      get :root

      expect(response.body).to have_selector("#new_scenario form") do |form|
        expect(form).to have_selector("select", name: 'other_year')
      end
    end

    it "should not select custom year values if it's not selected" do
      post :root, params: { area_code: "nl", other_year: '2034' }
      expect(session[:setting].end_year).not_to eq(2034)
    end

    it "should not select other field" do
      post :root, params: {
        area_code: "nl", end_year: 'other', other_year: '2036'
      }

      expect(session[:setting].end_year).to eq(2036)
    end
  end

  context "static pages" do
    [ :bugs, :units, :browser_support, :disclaimer,
      :privacy_statement].each do |page|
      describe "#{page} page" do
        it "should work" do
          get page
          expect(response).to be_success
          expect(response).to render_template(page)
        end
      end
    end
  end

  context "setting locale" do
    it "should set the locale and redirect", :focus do
      expect {
        put :set_locale, params: { locale: 'nl' }
        expect(response).to be_success
      }.to change { I18n.locale }.from(:en).to(:nl)
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
          expect(session[p]). to be(true)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "#info" do
    it "should render title and description" do
      s = FactoryGirl.create :sidebar_item, section: 'foo', key: 'bar'
      t = FactoryGirl.create :text, key: 'foo_bar'

      get :info, params: { ctrl: 'foo', act: 'bar' }
      expect(response).to be_success
      expect(response).to render_template(:info)
    end
  end

  describe "#feedback" do
    it "should render the form" do
      get :feedback, xhr: true
      expect(response).to be_success
      expect(response).to render_template(:feedback)
    end

    it "should let the user post some feedback and send a couple emails" do
      ActionMailer::Base.deliveries = []
      post :feedback, xhr: true, params: { feedback: {
        name: 'Schwarzenegger',
        email: 'arnold@quintel.com',
        msg: "I'll be back"
      }, format: :js }

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
