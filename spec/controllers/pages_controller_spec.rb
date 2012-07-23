require 'spec_helper'

describe PagesController do
  render_views

  before do
    ApplicationController.stub!(:ensure_valid_browser)
    Current.stub!(:teardown_after_request!)
    Current.stub!(:graph)
    Api::Scenario.stub(:all).and_return([])

    ActiveResource::HttpMock.respond_to do |mock|
      ["de", "nl", "nl-flevoland", "ch"].each do |code|
        area = [{ :id => 1, :country => code, :use_network_calculations => false, :entity => nil}].to_xml(:root => "area")
        mock.get "/api/v2/areas.xml?country=#{code}", { "Accept" => "application/xml" }, area
      end
      area = [{ :id => 1, :country => 'nl', :use_network_calculations => false}].to_xml(:root => "area")
      mock.get "/api/v2/areas.xml", { "Accept" => "application/xml" }, area
    end
  end

  {'nl' => '2030', 'de' => '2050'}.each do |country, year|
    describe "selecting #{country} #{year}" do
      before do
        post :root, :area_code => country.dup, :end_year => year.dup
      end

      specify { response.should redirect_to(:action => 'intro') }
      specify { assigns(:current).setting.end_year.should eql(year.to_i) }
      specify { assigns(:current).setting.area_code.should eql(country) }
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
      Current.setting.end_year.should_not == 2034
    end

    it "should not select other field" do
      post :root, :area_code => "nl", :end_year => 'other', :other_year => '2036'
      assigns(:current).setting.end_year.should == 2036
    end
  end

  context :static_pages do
    [ :bugs, :about, :units, :browser_support, :intro, :disclaimer,
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
