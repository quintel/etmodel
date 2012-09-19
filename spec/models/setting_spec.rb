require 'spec_helper'

describe Setting do
  before  { @setting = Setting.new }
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
        @setting = Setting.new(:track_peak_load => :bar, :use_fce =>:baz)
      end
      subject { @setting }
      its(:track_peak_load) { should == :bar}
      its(:use_fce) { should == :baz}
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
      before do
        @s = Setting.new
        @s.stub!(:use_peak_load).and_return(false)
      end

      context "track_peak_load on" do
        before { @s.track_peak_load = true }
        subject { @s }
        its(:track_peak_load?) { should be_false }
      end
      context "track_peak_load off" do
        before { @s.track_peak_load = false }
        subject { @s }
        its(:track_peak_load?) { should be_false }
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

  describe "ActiveResource-based area" do
    describe "#area" do
      before {
        @setting = Setting.default
        @area = Api::Area.new
        Api::Area.should_receive(:find_by_country_memoized).with(@setting.area_code).and_return(@area)
      }
      it "should return area" do
        @setting.area.should == @area
      end
    end
  end

  describe "#use_peak_load" do
    [true, false].each do |flag|
      context "use_network_calculations? = #{flag}" do
        before  { @setting.stub!(:use_network_calculations?).and_return(flag) }
        specify { @setting.use_peak_load.should == flag}
      end
    end
  end

  describe "#use_network_calculations?" do
    {
      :use_network_calculations? => :use_network_calculations?
    }.each do |setting_method_name, area_method_name|
      describe "##{setting_method_name} should be true if area##{area_method_name} is true" do
        before { @setting.stub!(:area).and_return(mock_model(Api::Area, area_method_name => true))}
        specify { @setting.send(setting_method_name).should be_true}
      end
      describe "##{setting_method_name} with no area should be false" do
        before { @setting.stub!(:area).and_return(nil)}
        specify { @setting.send(setting_method_name).should be_false}
      end
    end
  end

  describe "regression tests" do
    describe "DEFAULT_ATTRIBUTES" do
      it "should not persist default values that are objects, e.g. Array" do
        # BUG: Storing default_attributes in constant DEFAULT_ATTRIBUTES
        #      messes with arrays as default_attributes.
        s1 = Setting.default
        s1.network_parts_affected << :network
        Setting.default_attributes[:network_parts_affected].should be_empty
      end
    end
  end
end
