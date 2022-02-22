# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Scenario, vcr: true do
  let(:scenario) { described_class.find(648_696) }

  describe '#created_at' do
    it 'parses the value as a Time' do
      expect(scenario.created_at).to eq(Time.utc(2017, 3, 13, 19, 22, 55))
    end

    it 'sets the timezone to UTC' do
      expect(scenario.created_at.zone).to eq('UTC')
    end
  end

  describe '#updated_at' do
    it 'parses the value as a Time' do
      expect(scenario.updated_at).to eq(Time.utc(2019, 5, 8, 14, 15, 24))
    end

    it 'sets the timezone to UTC' do
      expect(scenario.updated_at.zone).to eq('UTC')
    end
  end

  describe '#title' do
    let(:scenario) { described_class.find(1_604_100, params: { detailed: true }) }

    context 'when the scenario has no metadata' do
      it 'returns nil' do
        expect(scenario.title).to be_nil
      end
    end

    context 'when the scenario has metadata but no title' do
      before do
        allow(scenario).to receive(:metadata).and_return(Struct.new(:attributes).new({}))
      end

      it 'returns nil' do
        expect(scenario.title).to be_nil
      end
    end

    context 'when the metadata has an empty title' do
      before do
        allow(scenario).to receive(:metadata).and_return(
          Struct.new(:attributes).new({ 'title' => '' })
        )
      end

      it 'returns nil' do
        expect(scenario.title).to be_nil
      end
    end

    context 'when the metadata has a title' do
      before do
        allow(scenario).to receive(:metadata).and_return(
          Struct.new(:attributes).new({ 'title' => 'My scenario title' })
        )
      end

      it 'returns the title' do
        expect(scenario.title).to eq('My scenario title')
      end
    end
  end
end
