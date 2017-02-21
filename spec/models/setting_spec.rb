require 'rails_helper'

describe Setting do
  before  { @setting = Setting.new }
  subject { @setting }

  let(:defaults) do
    Setting.default_attributes.merge(start_year: @setting.area.analysis_year)
  end

  describe "#new" do
    context "defaults", vcr: true do
      subject { Setting.new }

      Setting.default_attributes.each_key do |key|
        it "#{key} is set to the default" do
          expect(subject[key]).to eql(defaults[key])
        end
      end
    end

    context "other settings" do
      subject { Setting.new(track_peak_load: :bar, use_fce: :baz) }

      it 'sets a custom track_peak_load' do
        expect(subject[:track_peak_load]).to eql(:bar)
      end

      it 'sets a custom use_fce' do
        expect(subject[:use_fce]).to eql(:baz)
      end
    end
  end

  describe "Setting.default", vcr: true do
    it "should return a new Setting with default_values" do
      # twice: once in default and once in initialize
      setting = Setting.default
      expect(setting.class).to eq(Setting)

      Setting.default_attributes.each_key do |key|
        expect(setting[key]).to eq(defaults[key])
      end
    end
  end

  describe "#track_peak_load?" do
    context "use_peak_load is off" do
      before do
        @s = Setting.new
        allow(@s).to receive(:use_peak_load).and_return(false)
      end

      context "track_peak_load on" do
        before { @s.track_peak_load = true }
        subject { @s }

        it 'is not tracking peak load' do
          expect(subject.track_peak_load?).to be(false)
        end
      end

      context "track_peak_load off" do
        before { @s.track_peak_load = false }
        subject { @s }

        it 'is not tracking peak load' do
          expect(subject.track_peak_load?).to be(false)
        end
      end
    end

    context "use_peak_load is on" do
      before do
        @setting = Setting.new(track_peak_load: true)
      end

      it "should" do
        allow(@setting).to receive(:use_peak_load).and_return(true)
        expect(@setting.track_peak_load?).to be(true)
      end

      it "should" do
        allow(@setting).to receive(:use_peak_load).and_return(false)
        expect(@setting.track_peak_load?).to be(false)
      end
    end
  end

  describe "#reset!", vcr: true do
    before do
      @random_attributes = Setting.default_attributes.clone
      @random_attributes.each do |key, value|
        @random_attributes[key] = 11
      end
      @setting = Setting.new(@random_attributes)
    end
    it "should reset all attributes to default values" do
      @setting.reset!
      Setting.default_attributes.each_key do |key|
        expect(@setting.send(key)).to eql(defaults[key])
      end
    end
  end

  describe "ActiveResource-based area" do
    describe "#area" do
      before {
        @setting = Setting.default
        @area = Api::Area.new
        expect(Api::Area).to receive(:find_by_country_memoized).with(@setting.area_code).and_return(@area)
      }
      it "should return area" do
        expect(@setting.area).to eq(@area)
      end
    end
  end

  describe "#use_peak_load" do
    [true, false].each do |flag|
      context "use_network_calculations? = #{flag}" do
        before  { allow(@setting).to receive(:use_network_calculations?).and_return(flag) }
        specify { expect(@setting.use_peak_load).to eq(flag)}
      end
    end
  end

  describe "#use_network_calculations?" do
    {
      :use_network_calculations? => :use_network_calculations?
    }.each do |setting_method_name, area_method_name|
      describe "##{setting_method_name} should be true if area##{area_method_name} is true" do
        before do
          area = Api::Area.new
          allow(area).to receive(area_method_name).and_return(true)
          allow(@setting).to receive(:area).and_return(area)
        end

        specify { expect(@setting.send(setting_method_name)).to be_truthy }
      end

      describe "##{setting_method_name} with no area should be false" do
        before do
          allow(@setting).to receive(:area).and_return(nil)
        end

        specify { expect(@setting.send(setting_method_name)).to be_falsey }
      end
    end
  end

  describe "regression tests" do
    describe "DEFAULT_ATTRIBUTES", vcr: true do
      it "should not persist default values that are objects, e.g. Array" do
        # BUG: Storing default_attributes in constant DEFAULT_ATTRIBUTES
        #      messes with arrays as default_attributes.
        s1 = Setting.default
        s1.network_parts_affected << :network
        expect(Setting.default_attributes[:network_parts_affected]).to be_empty
      end
    end
  end
end
