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
    [ :bugs, :about, :units, :browser_support, :disclaimer,
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
end
