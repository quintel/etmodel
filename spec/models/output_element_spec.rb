# frozen_string_literal: true

require 'rails_helper'

describe OutputElement do
  subject { described_class.new }

  # Using an input element here that has some relatees
  let(:output_element) do
    described_class.find('household_heat_demand_and_production')
  end

  it { is_expected.to respond_to(:output_element_series) }

  it 'contains series' do
    expect(output_element.output_element_series).not_to be_empty
  end

  context 'with a relatee output_element' do
    let(:relatee) do
      described_class.find('source_of_heat_used_in_households')
    end

    it 'has one related output element' do
      expect(output_element.relatee_output_elements).to include relatee
    end

    it 'has an association between relatee and output element' do
      expect(relatee.related_output_element).to eq(output_element)
    end
  end

  it '#max_axis_value has a default value' do
    expect(subject.max_axis_value).to eq nil
  end

  it '#show_point_label has a default value' do
    expect(subject.show_point_label).to eq false
  end

  it '#requires_merit_order has a default value' do
    expect(subject.requires_merit_order).to eq false
  end

  it '#under_construction has a default value' do
    expect(subject.under_construction).to eq false
  end

  it '#growth_chart has a default value' do
    expect(subject.growth_chart).to eq false
  end
end
