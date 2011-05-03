require 'spec_helper'

describe Setting do
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
      before { Current.scenario.stub!(:use_peak_load).and_return(false) } 
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
      before { Current.scenario.stub!(:use_peak_load).and_return(true) } 
      context "track_peak_load on" do
        subject { Setting.new(:track_peak_load => true) }
        its(:track_peak_load?) { should be_true}
      end
      context "track_peak_load off" do
        subject { Setting.new(:track_peak_load => false) }
        its(:track_peak_load?) { should be_false}
      end
    end
  end

  describe "#reset!" do
    before do
      @random_attributes = Setting.default_attributes.clone
      @random_attributes.each do |key, value|
        @random_attributes[key] = :foo
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
end