require 'rails_helper'

describe OutputElement do

  subject { described_class.new }

  it { is_expected.to respond_to(:output_element_series) }

  subject { OutputElement.all.first }

  it 'contains series' do
    expect(subject.output_element_series).to_not be_empty
  end
  # context 'a chart with a relatee' do
  #   let(:output_element) do
  #     FactoryBot.create(:output_element)
  #   end

  #   let!(:relatee) do
  #     FactoryBot.create(:output_element, related_output_element: output_element)
  #   end

  #   it 'has one related output element' do
  #     expect(output_element.relatee_output_elements).to eq([relatee])
  #   end

  #   it 'has an association between relatee and output element' do
  #     expect(relatee.related_output_element).to eq(output_element)
  #   end

  #   it 'nullifies the relatee related_output_element_id when deleted' do
  #     expect { output_element.destroy }
  #       .to change { relatee.reload.related_output_element_id }
  #       .from(output_element.id)
  #       .to(nil)
  #   end
  # end
end
