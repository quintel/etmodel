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
        post :root, :region => country.dup, :end_year => year.dup
      end

      specify { response.should redirect_to(:action => 'intro') }
      specify { assigns(:current).setting.end_year.should eql(year.to_i) }
      specify { assigns(:current).setting.country.should eql(country) }
    end
  end

  describe "selected a country and a region" do
    before do
      post :root, "region" => "nl-flevoland", "end_year" => "2010"
    end

    specify { response.should redirect_to(:action => 'intro')}
    it "should assign the right country and region" do
      assigns(:current).setting.region.should  == 'nl-flevoland'
      assigns(:current).setting.country.should == 'nl'
    end
  end

  describe "selected a country without region" do
    before do
      post :root, :region => "ch", :end_year => "2010"
    end

    specify { response.should redirect_to(:action => 'intro')}
    specify { assigns(:current).setting.country.should eql('ch') }
    specify { assigns(:current).setting.region.should == 'ch' }
  end
  
  
  context "setting custom year values" do
    it "should have custom year field" do
      get :root
      response.should have_selector("form") do |form|
        form.should have_selector("select", :name => 'other_year')
      end
    end
    
    it "should not select custom year values if it's not selected" do
      post :root, :region => "nl", :other_year => '2034'
      Current.setting.end_year.should_not == 2034
    end
    
    it "should not select other field" do
      post :root, :region => "nl", :end_year => 'other', :other_year => '2036'
      assigns(:current).setting.end_year.should == 2036
    end                                        
  end
  

end
