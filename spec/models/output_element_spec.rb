require 'rails_helper'

describe OutputElement do
  include YmodelFixtures

  subject { described_class.new }

  let(:output_element) { described_class.all.first }

  it { is_expected.to respond_to(:output_element_series) }

  it 'contains series' do
    expect(output_element.output_element_series).not_to be_empty
  end

  context 'with a relatee output_element' do
    let(:relatee) do
      described_class.all.second
    end

    it 'has one related output element' do
      expect(output_element.relatee_output_elements).to eq([relatee])
    end

    it 'has an association between relatee and output element' do
      expect(relatee.related_output_element).to eq(output_element)
    end
  end
end
