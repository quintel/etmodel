require 'rails_helper'

RSpec.describe ETModel::Version do
  describe '.date' do
    it 'is the release date MyETM sends for this version' do
      allow(MyEtm::Version).to receive(:listed).and_return([
        MyEtm::Version.new({ tag: 'latest', released_on: '2026-10-15' }, true),
        MyEtm::Version.new({ tag: '2027', released_on: '2027-01-12' }, true)
      ])
      stub_const('ETModel::Version::TAG', '2027')

      expect(described_class.date).to eq(Date.new(2027, 1, 12))
    end

    it 'is empty while this version is hidden' do
      allow(MyEtm::Version).to receive(:listed).and_return([MyEtm::Version.new(tag: '2027')])
      stub_const('ETModel::Version::TAG', '2027')

      expect(described_class.date).to be_nil
    end
  end
end
