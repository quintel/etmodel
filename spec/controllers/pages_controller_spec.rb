require 'spec_helper'

describe PagesController do
  render_views

  before do
    ApplicationController.stub!(:ensure_valid_browser)
    Current.stub!(:teardown_after_request!)
    Current.stub!(:graph)
    @area = Area.create(:country => 'nl')
    Area.create(:country => 'ch')
  end

  {'nl' => '2030', 'de' => '2050'}.each do |country, year|
    describe "selecting #{country} #{year}" do
      before do
        post :root, :country => country.dup, :end_year => year.dup
      end

      specify { response.should redirect_to(:action => 'intro') }
      specify { assigns(:current).scenario.end_year.should eql(year.to_i) }
      specify { assigns(:current).scenario.country.should eql(country) }
    end
  end

  describe "selected a country and a region" do
    before do
      post :root, "country" => "nl", "end_year" => "2010", :region => {"nl" => 'flevoland', "uk" => 'london'}
    end

    specify { response.should redirect_to(:action => 'intro')}
    specify { assigns(:current).scenario.region.should eql('flevoland') }
  end

  describe "selected a country without region" do
    before do
      post :root, :country => "ch", :end_year => "2010", :region => {"nl" => 'flevoland', "uk" => 'london'}
    end

    specify { response.should redirect_to(:action => 'intro')}
    specify { assigns(:current).scenario.country.should eql('ch') }
    specify { assigns(:current).scenario.region.should be_nil }
  end
  
  
  context "setting custom year values" do
    it "should have custom year field" do
      get :root
      response.should have_selector("form") do |form|
        form.should have_selector("select", :name => 'other_year')
      end
    end
    
    it "should not select custom year values if it's not selected" do
      post :root, :country => "nl", :other_year => '2034'
      Current.scenario.end_year.should_not == 2034
    end
    
    it "should not select other field" do
      post :root, :country => "nl", :end_year => 'other', :other_year => '2036'
      assigns(:current).scenario.end_year.should == 2036
    end                                        
  end
  
  
  describe "selected municipality page" do  
   

    describe "selected an area that is a municipality" do
      before(:each) do 
        @scenario_mock = mock("scenario")
        [:update_statements=, :user_values=, :load_scenario, :user].each do |m|
          @scenario_mock.stub! m
        end
      end

     

      it "should go to intro page if posted with scenario selected" do
        Current.stub_chain(:scenario, :municipality?).and_return(true)
        Current.stub_chain(:scenario, :region).and_return(Area.new(:entity => 'municipality'))
        id = "1"
        Scenario.should_receive(:find).with(id).and_return(@scenario_mock)
        post :municipality, :scenario => id
        flash[:error].should be_nil 
        response.should redirect_to(:action => 'intro')
      end
    end
  end
end
