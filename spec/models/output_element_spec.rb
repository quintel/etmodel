require 'rails_helper'

# Using fixtures
describe OutputElement do

  subject { described_class.new }

  it { is_expected.to respond_to(:output_element_series) }

  subject { OutputElement.all.first }

  it 'contains series' do
    expect(subject.output_element_series).to_not be_empty
  end
  context 'a chart with a relatee' do
    let(:output_element) do
      OutputElement.all.first
    end

    let(:relatee) do
      OutputElement.all.second
    end

    it 'has one related output element' do
      expect(output_element.relatee_output_elements).to eq([relatee])
    end

    it 'has an association between relatee and output element' do
      expect(relatee.related_output_element).to eq(output_element)
    end
  end
end
