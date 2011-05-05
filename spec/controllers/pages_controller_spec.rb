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
        post :root, :region => country.dup, :end_year => year.dup
      end

      specify { response.should redirect_to(:action => 'intro') }
      specify { assigns(:current).scenario.end_year.should eql(year.to_i) }
      specify { assigns(:current).scenario.country.should eql(country) }
    end
  end

  describe "selected a country and a region" do
    before do
      post :root, "region" => "nl-flevoland", "end_year" => "2010"
    end

    specify { response.should redirect_to(:action => 'intro')}
    it "should assign the right country and region" do
      assigns(:current).scenario.region.should  == 'nl-flevoland'
      assigns(:current).scenario.country.should == 'nl'
    end
  end

  describe "selected a country without region" do
    before do
      post :root, :region => "ch", :end_year => "2010"
    end

    specify { response.should redirect_to(:action => 'intro')}
    specify { assigns(:current).scenario.country.should eql('ch') }
    specify { assigns(:current).scenario.region.should == 'ch' }
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
      Current.scenario.end_year.should_not == 2034
    end
    
    it "should not select other field" do
      post :root, :region => "nl", :end_year => 'other', :other_year => '2036'
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
        Current.stub_chain(:scenario, :complexity_key).and_return(1)
        id = "1"
        Scenario.should_receive(:find).with(id).and_return(@scenario_mock)
        post :municipality, :scenario => id
        flash[:error].should be_nil 
        response.should redirect_to(:action => 'intro')
      end
    end
  end
end
