# frozen_string_literal: true

require 'rails_helper'

describe Engine::Scenario do
  let(:attributes) do
    {
      area_code: 'nl',
      balanced_values: {},
      end_year: 2050,
      esdl_exportable: false,
      id: 123,
      keep_compatible: false,
      coupling: false,
      metadata: {},
      private: false,
      user_values: {}
    }
  end

  describe '#title' do
    context 'when the scenario has metadata but no title' do
      let(:scenario) do
        described_class.new(attributes.merge(metadata: {}))
      end

      it 'returns nil' do
        expect(scenario.title).to be_nil
      end
    end

    context 'when the metadata has an empty title' do
      let(:scenario) do
        described_class.new(attributes.merge(metadata: { 'title' => '' }))
      end

      it 'returns nil' do
        expect(scenario.title).to be_nil
      end
    end

    context 'when the metadata has a title' do
      let(:scenario) do
        described_class.new(attributes.merge(metadata: { 'title' => 'My scenario title' }))
      end

      it 'returns the title' do
        expect(scenario.title).to eq('My scenario title')
      end
    end
  end
end
