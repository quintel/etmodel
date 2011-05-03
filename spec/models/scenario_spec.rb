require 'spec_helper'

describe Scenario do
  before { @scenario = Scenario.new }
  subject { @scenario }

  describe "#default" do
    subject { Scenario.default }
    its(:complexity) { should == 3}
    its(:country) { should == 'nl'}
    its(:region) { should == nil}
    its(:user_values) { should == {} }
    its(:end_year) { should == 2040 }
    its(:start_year) { should == 2010 }

    describe "#years" do
      its(:years) { should == 30 }
    end
  end

  describe "#complexities" do
    context "simple" do
      subject { Scenario.new(:complexity => 1) }
      its(:simple?) { should be_true}
      its(:medium?) { should be_false}
      its(:advanced?) { should be_false}
    end
    context "medium" do
      subject { Scenario.new(:complexity => 2) }
      its(:simple?) { should be_false }
      its(:medium?) { should be_true }
      its(:advanced?) { should be_false }
    end
    context "advanced" do
      subject { Scenario.new(:complexity => 3) }
      its(:simple?) { should be_false }
      its(:medium?) { should be_false }
      its(:advanced?) { should be_true }
    end
    describe "#complexity = " do
      before { 
        @scenario = Scenario.new
        @scenario.complexity = "1"
      }
      specify { @scenario.complexity.should == 1}
    end
  end

  describe "set_country_and_region" do
    before { @scenario = Scenario.new }
    context "region = nil" do
      before { @scenario.set_country_and_region('nl', nil)}
      subject { @scenario }
      its(:country) { should == 'nl' }
      its(:region) { should == nil }
      its(:region_or_country) { should == 'nl' }
    end
    context "region = ''" do
      before { @scenario.set_country_and_region('nl', '')}
      subject { @scenario }
      its(:country) { should == 'nl' }
      its(:region) { should == nil }
      its(:region_or_country) { should == 'nl' }
    end
    context "region = 'flevaland'" do
      before { @scenario.set_country_and_region('nl', 'flevaland')}
      subject { @scenario }
      its(:region) { should == 'flevaland' }
      its(:region_or_country) { should == 'flevaland' }
    end
    context "region = {'nl' => 'flevaland'}" do
      before { @scenario.set_country_and_region('nl', {'nl' => 'flevaland'}) }
      subject { @scenario }
      its(:region) { should == 'flevaland' }
    end
    context "unmatched country ('ch') in region = {'nl' => 'flevaland'}" do
      before { @scenario.set_country_and_region('ch', {'nl' => 'flevaland'}) }
      subject { @scenario }
      its(:region) { should be_nil }
    end
  end

  describe "#area" do
    before { 
      @scenario = Scenario.default
      @area = Area.new
      Area.should_receive(:find_by_country).with(@scenario.region_or_country).and_return(@area)
    }
    it "should return area" do
      @scenario.area.should == @area
    end
    it "should memoize area" do
      @scenario.area
      # if it Area is called twice the should_receive would raise an exception
      @scenario.area
    end
  end

  describe "#area_country" do
    before { @scenario = Scenario.default }
    it "should return area" do
      Area.should_receive(:find_by_country).with(@scenario.country).and_return(:foo)
      @scenario.area_country
    end
  end

  describe "#area_region" do
    before { @scenario = Scenario.default }
    it "should return area" do
      Area.should_receive(:find_by_country).with(@scenario.region).and_return(:foo)
      @scenario.area_region
    end
  end

  describe "#municipality?, #has_buildings?, #use_network_calculations?, #number_of_households, #number_of_existing_households" do
    {
      :municipality? => :is_municipality?,
      :has_buildings? => :has_buildings,
      :use_network_calculations? => :use_network_calculations,
      :number_of_households => :number_households,
      :number_of_existing_households => :number_of_existing_households
    }.each do |scenario_method_name, area_method_name|
      describe "##{scenario_method_name} should be true if area##{area_method_name} is true" do
        before { @scenario.stub!(:area).and_return(mock_model(Area, area_method_name => true))}
        specify { @scenario.send(scenario_method_name).should be_true}
      end
      describe "##{scenario_method_name} with no area should be false" do
        before { @scenario.stub!(:area).and_return(nil)}
        specify { @scenario.send(scenario_method_name).should be_false}
      end
    end
  end

  describe "number_of_households is memoized (does not lookup value from area when present)" do
    before { @scenario = Scenario.new(:number_of_households => 15, :number_of_existing_households => 20)}
    specify { @scenario.number_of_households.should == 15}
    specify { @scenario.number_of_existing_households.should == 20}
  end

  describe "#number_of_households=" do
    before { @scenario.number_of_households = 15}
    specify { @scenario.number_of_households.should == 15 }
  end

  describe "#number_of_existing_households=" do
    before { @scenario.number_of_existing_households = 15}
    specify { @scenario.number_of_existing_households.should == 15 }
  end

  describe "#use_peak_load" do
    context "Scenario != advanced" do
      before {@scenario.stub!(:advanced?).and_return(false)}
      specify { @scenario.use_peak_load.should be_false}
    end
    context "Scenario is advanced" do
      before {@scenario.stub!(:advanced?).and_return(true)}
      [true, false].each do |flag|
        context "use_network_calculations? = #{flag}" do
          before {@scenario.stub!(:use_network_calculations?).and_return(flag)}
          specify { @scenario.use_peak_load.should == flag}
        end
      end
    end
  end

  describe "setting and retrieving user_values" do
    before do
      @input_element = mock_model(InputElement, :id => 1)
      @scenario.store_user_value(@input_element, 10)
    end
    specify { @scenario.user_value_for(@input_element).should == 10}

    it "should return the value when store_user_value" do
      @scenario.store_user_value(@input_element, 10).should == 10
    end

    describe "overwriting user_value" do
      before { @scenario.store_user_value(@input_element, 20) }
      specify { @scenario.user_value_for(@input_element).should == 20}
    end
  end

  describe "#user_values" do
    context ":user_values = YAMLized object (when coming from db)" do
      before {@scenario = Scenario.new(:user_values => {:foo => :bar})}
      it "should unyaml,overwrite and return :user_values" do
        @scenario.user_values.should == {:foo => :bar}
        @scenario.user_values[:foo].should == :bar
      end
     
    end
    context ":user_values = nil" do
      before {@scenario = Scenario.new(:user_values => {})}
      its(:user_values) { should == {} }
    end
    context ":user_values = obj" do
      before {@scenario = Scenario.new(:user_values => {})}
      its(:user_values) { should == {} }
    end
  end


  context "municipality" do
    describe "#input_element_scaled_for_municipality?" do
      before do
        @input_element = mock_model(InputElement)
        @input_element.stub_chain(:slide, :name).and_return('slide_name')
      end
      context "input_elements slide is in supply" do
        before  { @input_element.stub_chain(:slide, :controller_name).and_return('supply') }
        specify { @scenario.input_element_scaled_for_municipality?(@input_element).should be_true }
      end
      context "input_elements slide is not in supply" do
        before  { @input_element.stub_chain(:slide, :controller_name).and_return('demand')}
        specify { @scenario.input_element_scaled_for_municipality?(@input_element).should be_false }
      end
      context "input_elements slide is nil" do
        before  { @input_element.stub!(:slide).and_return(nil)}
        specify { @scenario.input_element_scaled_for_municipality?(@input_element).should be_false }
      end      
    end
  end

  describe "#scale_factor_for_municipality" do
    context "input_element is locked_for_municipalities" do
      before { @input_element = mock_model("InputElement", :locked_for_municipalities => true)}
      specify { @scenario.scale_factor_for_municipality(@input_element).should be_nil}
    end
    context "and not locked_for_municipalities" do
      before { @input_element = mock_model("InputElement", :locked_for_municipalities => false)}

      context "and scaled for municipality" do
        before do
          @scenario.should_receive(:input_element_scaled_for_municipality?).with(any_args).and_return(true) 
          @scenario.should_receive(:area_region).and_return(mock_model("Area", :current_electricity_demand_in_mj => 30.0))
          @scenario.should_receive(:area_country).and_return(mock_model("Area", :current_electricity_demand_in_mj => 50.0))
        end
        specify { @scenario.scale_factor_for_municipality(@input_element).should be_within(0.1).of(50.0/30.0)}
      end

      context "and not scaled for municipality" do
        before do
          @scenario.should_receive(:input_element_scaled_for_municipality?).with(any_args).and_return(false) 
        end
        specify { @scenario.scale_factor_for_municipality(@input_element).should be_nil }
      end
    end
  end

  describe "#add_update_statements" do
    before do
      @scenario.update_statements = {'converters' => {
        'hot_water_demand_households_energetic' => {'growth_rate' => '0.1', 'other_metric' => '1000'}
      }}      
    end

    context "with calculated gql" do
      before do
        Current.stub!(:gql_calculated?).and_return(true)
      end
      it "should raise an exception" do
        lambda {
          @scenario.update_statements['converters']['hot_water_demand_households_energetic']['growth_rate'].should eql("0.2")
        }.should raise_exception(Exception)
      end
    end

    context "with uncalculated gql" do
      before do
        Current.stub!(:gql_calculated?).and_return(false)
      end

      describe "update existing" do
        before do
          @scenario.add_update_statements({'converters' => {
            'hot_water_demand_households_energetic' => {'growth_rate' => '0.2'}
          }})
        end
        it "should update metric" do
          @scenario.update_statements['converters']['hot_water_demand_households_energetic']['growth_rate'].should eql("0.2")
        end
        it "should keep other metrics" do
          @scenario.update_statements['converters']['hot_water_demand_households_energetic']['other_metric'].should eql("1000")
        end
      end

      describe "creating new" do
        before do
          @scenario.add_update_statements({'converters' => {
            'hot_water_demand_industry_energetic' => {'growth_rate' => '0.2'}
          }})
        end

        it "creates new values" do
          @scenario.update_statements['converters']['hot_water_demand_industry_energetic']['growth_rate'].should eql("0.2")
        end

        it "does not change other items" do
          @scenario.update_statements['converters'].should have(2).items
        end
      end    
    end
  end

  describe "#update_input_element" do
    before do
      @value = 13.3
      @input_element = mock_model(InputElement)
      @input_element.stub!(:update_statement).with(@value).and_return({})
      Current.stub!(:gql_calculated?).and_return(false)
    end
    it "should store the user value" do
      @scenario.should_receive(:store_user_value).with(@input_element, @value)
      @scenario.update_input_element(@input_element, @value)
    end
    it "should add update_statements" do
      @scenario.should_receive(:add_update_statements).with({})
      @scenario.update_input_element(@input_element, @value)
    end
  end

  describe "#build_update_statements_for_element" do
    before do
      @input_element = mock_model(InputElement, :id => 5)
      InputElement.stub!(:find).with(@input_element.id).and_return(@input_element)
    end
    context "with scale_factor" do
      before { @scenario.stub!(:scale_factor_for_municipality).and_return(0.5) }
      it "should update_input_element scaled when load_as_municipality" do
        @scenario.should_receive(:update_input_element).with(@input_element, 2.0 / 0.5)
        @scenario.build_update_statements_for_element(true, @input_element.id, 2.0)
      end
      it "should update_input_element unscaled when not load_as_municipality" do
        @scenario.should_receive(:update_input_element).with(@input_element, 2.0)
        @scenario.build_update_statements_for_element(false, @input_element.id, 2.0)
      end
    end
    context "if no input_element found" do
      before { InputElement.stub!(:find).and_raise(ActiveRecord::RecordNotFound) }
      it "should catch the error" do
        @scenario.build_update_statements_for_element(false, @input_element.id, 2.0)
      end
    end
  end

  describe "#reset!" do
    before do
      @scenario.stub!(:area).and_return(mock_model("Area", 
        :number_households => 120, 
        :number_of_existing_households => 130))
      @scenario.number_of_households = 140
      @scenario.number_of_existing_households = 160
      @scenario.user_values = {}
      @scenario.update_statements = {:foo => :bar}
      @scenario.reset!
    end
    subject {@scenario}
    its(:number_of_households) { should == 120}
    its(:number_of_existing_households) { should == 130}
    its(:user_values) { should == {}}
    its(:update_statements) { should == {}}
  end
  
  
  
  describe "#attachments" do
    before do
      @file = File.new(File.join("spec", "fixtures", "attachments", "screenshot.png"))
    end
    context "attachments" do
      it "should save as attachment" do
        @scenario = Scenario.default
        attachment = @scenario.attachments.build(:file => @file)
        attachment.save.should be true
      end
    end
  end
  
  describe "Scenario preset" do
    before(:each) do
      @preset_scenario = Scenario.create!(:title => "Preset scenario")
      @preset_scenario.user_values = {}
    end
    
    it "should be able to have preset" do
      @scenario = Scenario.create!(:preset_scenario => @preset_scenario, :title => "Scenario that was built from a preset")
      @scenario.reload.preset_scenario.should == @preset_scenario
      @scenario.user_values.should == {}
    end
  end


  describe "#used_groups_add_up?" do
    before do
      @scenario = Scenario.default
      InputElement.stub!(:input_elements_grouped).and_return({
        'share_group' => [
          mock_model(InputElement, :id => 1, :key => 'element_1', :share_group => 'share_group'),
          mock_model(InputElement, :id => 2, :key => 'element_2', :share_group => 'share_group'),
          mock_model(InputElement, :id => 3, :key => 'element_3', :share_group => 'share_group')
        ],
        'share_group_unused' => [
          mock_model(InputElement, :id => 5, :key => 'element_5', :share_group => 'share_group_unused'),
          mock_model(InputElement, :id => 6, :key => 'element_6', :share_group => 'share_group_unused'),
        ]
      })
    end
    subject { @scenario }

    describe "#used_groups" do
      context "no user_values" do
        its(:used_groups) { should be_empty }
      end
      context "with 1 user_values" do
        before { @scenario.user_values = {1 => 2}}
        its(:used_groups) { should_not be_empty }
      end
    end

    describe "#used_groups_add_up?" do
      context "no user_values" do
        its(:used_groups_add_up?) { should be_true }
      end
      context "user_valeus but without groups" do
        before { @scenario.user_values = {10 => 2}}
        its(:used_groups_add_up?) { should be_true }
      end
      context "user_values that don't add up to 100" do
        before { @scenario.user_values = {1 => 50}}
        its(:used_groups_add_up?) { should be_false }
        its(:used_groups_not_adding_up) { should have(1).items }
      end
      context "user_values that add up to 100" do
        before { @scenario.user_values = {1 => 50, 2 => 30, 3 => 20}}
        its(:used_groups_add_up?) { should be_true }
      end
    end
  end
end



# == Schema Information
#
# Table name: scenarios
#
#  id                 :integer(4)      not null, primary key
#  author             :string(255)
#  title              :string(255)
#  description        :text
#  user_updates       :text
#  created_at         :datetime
#  updated_at         :datetime
#  user_values        :text
#  end_year           :integer(4)      default(2040)
#  country            :string(255)
#  in_start_menu      :boolean(1)
#  region             :string(255)
#  user_id            :integer(4)
#  complexity         :integer(4)      default(3)
#  scenario_type      :string(255)
#  preset_scenario_id :integer(4)
#  type               :string(255)
#  api_session_key    :string(255)
#  lce_settings       :text
#

