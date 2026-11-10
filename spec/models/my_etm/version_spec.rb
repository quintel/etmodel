require 'rails_helper'

RSpec.describe MyEtm::Version do
  # A version as MyETM lists it.
  def listed(tag, **attributes)
    described_class.new(
      { tag:, label: tag.delete_suffix('.01'), model_url: "https://#{tag}" }.merge(attributes),
      true
    )
  end

  describe '#label' do
    it 'is the label MyETM sends' do
      expect(described_class.new(tag: '2025.01', label: '2025').label).to eq('2025')
    end

    it 'is the tag when MyETM sends no label' do
      expect(described_class.new(tag: '2025.01').label).to eq('2025.01')
    end
  end

  describe '.listed' do
    let(:versions) do
      [listed('2025.01'), listed('latest', released_on: '2026-10-15'), listed('2027')]
    end

    before { allow(described_class).to receive(:find).with(:all).and_return(versions) }

    it 'puts latest first, then the newest' do
      expect(described_class.listed.map(&:tag)).to eq(%w[latest 2027 2025.01])
    end

    it 'adds this version when MyETM does not list it' do
      stub_const('ETModel::Version::TAG', '2028')
      expect(described_class.listed.map(&:tag)).to eq(%w[latest 2028 2027 2025.01])
    end

    context 'when on beta' do
      before do
        allow(Settings).to receive(:version).and_return('beta')
        stub_const('ETModel::Version::TAG', 'beta')
      end

      it 'lists only beta' do
        expect(described_class.listed.map(&:tag)).to eq(%w[beta])
      end

      it "gives beta latest's release date" do
        expect(described_class.listed.first.released_on).to eq(Date.new(2026, 10, 15))
      end
    end
  end

  describe '#name' do
    it 'is the release date for latest' do
      expect(listed('latest', released_on: '2026-10-15').name)
        .to eq(I18n.l(Date.new(2026, 10, 15), format: :long))
    end

    it 'is the release date for beta' do
      expect(described_class.new(tag: 'beta', released_on: '2026-10-15').name)
        .to eq(I18n.l(Date.new(2026, 10, 15), format: :long))
    end

    it 'is the label for latest without a release date' do
      expect(listed('latest').name).to eq('latest')
    end

    it 'is the label for a stable version' do
      expect(listed('2025.01', released_on: '2025-04-03').name).to eq('2025')
    end
  end

  describe '#short_name' do
    it 'is Latest for latest' do
      expect(listed('latest', released_on: '2026-10-15').short_name).to eq('Latest')
    end

    it 'is Beta for beta' do
      expect(described_class.new(tag: 'beta', released_on: '2026-10-15').short_name).to eq('Beta')
    end

    it 'is the label for a stable version' do
      expect(listed('2025.01').short_name).to eq('2025')
    end
  end

  describe '#badge' do
    it 'is latest for latest' do
      expect(listed('latest').badge).to eq(:latest)
    end

    it 'is beta for beta' do
      expect(described_class.new(tag: 'beta').badge).to eq(:beta)
    end

    it 'is stable for another version MyETM lists' do
      expect(listed('2027').badge).to eq(:stable)
    end

    it 'is empty for a stable version MyETM does not list' do
      expect(described_class.new(tag: '2027').badge).to be_nil
    end
  end

  describe '#current?' do
    it 'is true for the version this ETModel runs as' do
      stub_const('ETModel::Version::TAG', '2027')
      expect(listed('2027')).to be_current
    end

    it 'is false for another version' do
      stub_const('ETModel::Version::TAG', '2027')
      expect(listed('latest')).not_to be_current
    end
  end
end
