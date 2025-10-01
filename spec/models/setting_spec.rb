require 'rails_helper'

describe Setting do
  before  { @setting = Setting.new }
  subject { @setting }

  let(:defaults) do
    Setting.default_attributes.merge(start_year: @setting.area.analysis_year)
  end

  it{ is_expected.to respond_to :active_saved_scenario_id }
  it{ is_expected.to respond_to :active_saved_scenario_id= }
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
      subject { Setting.new(use_merit_order: :bar) }

      it 'sets a custom use_merit_order' do
        expect(subject[:use_merit_order]).to eql(:bar)
      end
    end
  end

  describe '#active_scenario?' do
    context 'when the setting has no scenario ID' do
      let(:setting) { described_class.new(api_session_id: nil) }

      it 'returns false' do
        expect(setting.active_scenario?).to be(false)
      end
    end

    context 'when the setting has a scenario ID, but no area' do
      let(:setting) { described_class.new(api_session_id: 1, area_code: nil) }

      it 'returns false' do
        expect(setting.active_scenario?).to be(false)
      end
    end

    context 'when the setting has a scenario ID, but an invalid area' do
      let(:setting) { described_class.new(api_session_id: 1, area_code: 'invalid') }

      before do
        allow(Engine::Area).to receive(:find_by_country_memoized).and_return(nil)
      end

      it 'returns false' do
        expect(setting.active_scenario?).to be(false)
      end

      it 'will have checked for a valid area' do
        setting.active_scenario?
        expect(Engine::Area).to have_received(:find_by_country_memoized).with('invalid')
      end
    end

    context 'when the setting has a scenario ID and an area' do
      let(:setting) { described_class.new(api_session_id: 1, area_code: 'nl') }

      before do
        allow(Engine::Area).to receive(:find_by_country_memoized).with('nl').and_return(Object.new)
      end

      it 'returns true' do
        expect(setting.active_scenario?).to be(true)
      end

      it 'will have checked for a valid area' do
        setting.active_scenario?
        expect(Engine::Area).to have_received(:find_by_country_memoized).with('nl')
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

  describe '#to_hash', vcr: true do
    context 'when locked_charts is nil' do
      let(:setting) { Setting.new(locked_charts: nil) }

      it 'uses an empty array for the charts' do
        expect(setting.to_hash[:locked_charts]).to eq([])
      end
    end

    context 'when locked_charts is an array' do
      let(:setting) { Setting.new(locked_charts: %w[d e f]) }

      it 'does no alter the charts' do
        expect(setting.to_hash[:locked_charts]).to eq(%w[d e f])
      end
    end

    context 'when the scenario ID is set and the scenario is active' do
      let(:setting) { described_class.new(api_session_id: 1) }
      let(:hash) { setting.to_hash }

      before { allow(setting).to receive(:active_scenario?).and_return(true) }

      it 'includes the scenario ID' do
        expect(hash[:api_session_id]).to eq(1)
      end

      it 'asks if the scenario is active' do
        hash
        expect(setting).to have_received(:active_scenario?)
      end
    end

    context 'when the scenario ID is set and the scenario is not active' do
      let(:setting) { described_class.new(api_session_id: 1) }
      let(:hash) { setting.to_hash }

      before { allow(setting).to receive(:active_scenario?).and_return(false) }

      it 'includes the scenario ID' do
        expect(hash[:api_session_id]).to eq(nil)
      end

      it 'asks if the scenario is active' do
        hash
        expect(setting).to have_received(:active_scenario?)
      end
    end
  end

  describe "#reset!", vcr: true do
    before do
      @random_attributes = Setting.default_attributes.clone
      @random_attributes.each do |key, value|
        @random_attributes[key] =
          case value
          when Array then %w[a b c]
          when Hash  then { a: 'b' }
          else 11
          end
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
        @area = Engine::Area.new
        expect(Engine::Area).to receive(:find_by_country_memoized).with(@setting.area_code).and_return(@area)
      }
      it "should return area" do
        expect(@setting.area).to eq(@area)
      end
    end
  end


  describe ".load_from_scenario" do
    let(:setting) do
      described_class.load_from_scenario(
        ete_scenario_mock,
        active_saved_scenario: { id: 1234, title: 'test' }
      )
    end

    it "returns a scenario" do
      expect( Setting.load_from_scenario ete_scenario_mock ).to be_a Setting
    end

    it 'takes an optional saved_scenario id' do
      expect(setting.active_saved_scenario_id)
        .to eq(1234)
    end

    it 'takes an optional saved_scenario title' do
      expect(setting.active_scenario_title)
        .to eq('test')
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
