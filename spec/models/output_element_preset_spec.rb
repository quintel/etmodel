# frozen_string_literal: true

require 'rails_helper'

describe OutputElementPreset do
  describe '#output_elements_for_js' do
    it 'returns an array of output elements in chart form' do
      preset = described_class.new(output_elements: %w[foo bar])
      expect(preset.output_elements_for_js).to eq(%w[foo-C bar-C])
    end
  end

  describe '.for_list' do
    it 'returns a list of output elements sorted by title' do
      allow(OutputElementPreset).to receive(:all).and_return([
        instance_double(OutputElementPreset, title: 'B', not_allowed_in_this_area: false),
        instance_double(OutputElementPreset, title: 'A', not_allowed_in_this_area: false),
        instance_double(OutputElementPreset, title: 'C', not_allowed_in_this_area: false)
      ])

      expect(OutputElementPreset.for_list.map(&:title)).to eq(%w[A B C])
    end
  end
end
