require 'spec_helper'

describe Setting do
  before { @setting = Setting.new }
  subject { @setting }


  describe "#new" do
    context "defaults" do
      before do
        @setting = Setting.new
      end
      subject { @setting }
      Setting.default_attributes.each do |key, default|
        its(key) { should == default }
      end
    end
    context "other settings" do
      before do
        @setting = Setting.new(:track_peak_load => :bar, :show_municipality_introduction => :foo)
      end
      subject { @setting }
      its(:track_peak_load) { should == :bar}
      its(:show_municipality_introduction) { should == :foo}
    end
  end

  describe "Setting.default" do
    it "should return a new Setting with default_values" do
      # twice: once in default and once in initialize
      Setting.should_receive(:default_attributes).twice.and_return({})
      setting = Setting.default
      setting.class.should == Setting
    end
  end

  describe "#track_peak_load?" do
    context "use_peak_load is off" do
      before { Current.setting.stub!(:use_peak_load).and_return(false) } 
      context "track_peak_load on" do
        subject { Setting.new(:track_peak_load => true) }
        its(:track_peak_load?) { should be_false}
      end
      context "track_peak_load off" do
        subject { Setting.new(:track_peak_load => false) }
        its(:track_peak_load?) { should be_false}
      end
    end

    context "use_peak_load is on" do
      before do
        @setting = Setting.new(:track_peak_load => true)
      end
      it "should" do
        @setting.stub!(:use_peak_load).and_return(true)
        @setting.track_peak_load?.should be_true
      end
      it "should" do
        @setting.stub!(:use_peak_load).and_return(false)
        @setting.track_peak_load?.should be_false
      end
    end
  end
  
  describe "#complexities" do
    context "simple" do
      subject { Setting.new(:complexity => 1) }
      its(:simple?) { should be_true}
      its(:medium?) { should be_false}
      its(:advanced?) { should be_false}
    end
    context "medium" do
      subject { Setting.new(:complexity => 2) }
      its(:simple?) { should be_false }
      its(:medium?) { should be_true }
      its(:advanced?) { should be_false }
    end
    context "advanced" do
      subject { Setting.new(:complexity => 3) }
      its(:simple?) { should be_false }
      its(:medium?) { should be_false }
      its(:advanced?) { should be_true }
    end
    describe "#complexity = " do
      before { 
        @setting = Setting.new
        @setting.complexity = "1"
      }
      specify { @setting.complexity.should == 1}
    end
  end
  
  describe "#reset!" do
    before do
      @random_attributes = Setting.default_attributes.clone
      @random_attributes.each do |key, value|
        @random_attributes[key] = 11
      end
      @setting = Setting.new(@random_attributes)
    end
    it "should reset all attributes to default values" do
      @setting.reset!
      Setting.default_attributes.each do |key, value|
        @setting.send(key).should eql(value)
      end
    end
  end


  describe "set_country_and_region" do
    before { @setting = Setting.new }
    context "region = nil" do
      before { @setting.set_country_and_region('nl', nil)}
      subject { @setting }
      its(:country) { should == 'nl' }
      its(:region) { should == nil }
      its(:region_or_country) { should == 'nl' }
    end
    context "region = ''" do
      before { @setting.set_country_and_region('nl', '')}
      subject { @setting }
      its(:country) { should == 'nl' }
      its(:region) { should == nil }
      its(:region_or_country) { should == 'nl' }
    end
    context "region = 'flevaland'" do
      before { @setting.set_country_and_region('nl', 'flevaland')}
      subject { @setting }
      its(:region) { should == 'flevaland' }
      its(:region_or_country) { should == 'flevaland' }
    end
  end




  describe "#area" do
    before { 
      @setting = Setting.default
      @area = Area.new
      Area.should_receive(:find_by_country_memoized).with(@setting.region_or_country).and_return(@area)
    }
    it "should return area" do
      @setting.area.should == @area
    end
  end

  describe "#area_region" do
    before { @setting = Setting.default }
    it "should return area" do
      Area.should_receive(:find_by_country).with(@setting.region).and_return(:foo)
      @setting.area_region
    end
  end


  describe "number_of_households is memoized (does not lookup value from area when present)" do
    before { @setting = Setting.new(:number_of_households => 15, :number_of_existing_households => 20)}
    specify { @setting.number_of_households.should == 15}
    specify { @setting.number_of_existing_households.should == 20}
  end

  describe "#number_of_households=" do
    before { @setting.number_of_households = 15}
    specify { @setting.number_of_households.should == 15 }
  end

  describe "#number_of_existing_households=" do
    before { @setting.number_of_existing_households = 15}
    specify { @setting.number_of_existing_households.should == 15 }
  end

  describe "#use_peak_load" do
    context "Setting != advanced" do
      before { Current.setting.stub!(:advanced?).and_return(false)}
      specify { @setting.use_peak_load.should be_false}
    end
    context "Setting is advanced" do
      before { Current.setting.stub!(:advanced?).and_return(true)}
      [true, false].each do |flag|
        context "use_network_calculations? = #{flag}" do
          before {@setting.stub!(:use_network_calculations?).and_return(flag)}
          specify { @setting.use_peak_load.should == flag}
        end
      end
    end
  end




  describe "#municipality?, #use_network_calculations?, #number_of_households, #number_of_existing_households" do
    {
      :municipality? => :is_municipality?,
      :use_network_calculations? => :use_network_calculations,
      :number_of_households => :number_households,
      :number_of_existing_households => :number_of_existing_households
    }.each do |setting_method_name, area_method_name|
      describe "##{setting_method_name} should be true if area##{area_method_name} is true" do
        before { @setting.stub!(:area).and_return(mock_model(Area, area_method_name => true))}
        specify { @setting.send(setting_method_name).should be_true}
      end
      describe "##{setting_method_name} with no area should be false" do
        before { @setting.stub!(:area).and_return(nil)}
        specify { @setting.send(setting_method_name).should be_false}
      end
    end
  end




  describe "#scale_factor_for_municipality" do
    context "input_element is locked_for_municipalities" do
      before  do
        @setting.should_receive(:input_element_scaled_for_municipality?).with(any_args).and_return(true) 
        @setting.should_receive(:area_country).and_return(mock("Area", :current_electricity_demand_in_mj => 50.0))
        @setting.should_receive(:area_region).and_return(mock("Area", :current_electricity_demand_in_mj => 30.0))
        @input_element = mock_model("InputElement", :locked_for_municipalities => true)
      end
      
      specify { @setting.scale_factor_for_municipality(@input_element).should be_within(0.1).of(50.0/30.0) }
    end
    
    context "and not locked_for_municipalities" do
      before { @input_element = mock_model("InputElement", :locked_for_municipalities => false)}

      context "and scaled for municipality" do
        specify { @setting.scale_factor_for_municipality(@input_element).should be_nil }
      end

      context "and not scaled for municipality" do
        specify do
          @setting.scale_factor_for_municipality(@input_element).should be_nil
        end
      end
    end
  end



  describe "#area_country" do
    before { @setting = Setting.default }
    it "should return area" do
      Area.should_receive(:find_by_country).with(@setting.country).and_return(:foo)
      @setting.area_country
    end
  end

end