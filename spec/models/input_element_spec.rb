require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe InputElement do
  it_behaves_like 'a model with a position attribute'

  describe '#url_components' do
    context 'when the input a slide, sidebar item, and tab' do
      let(:slide) { Slide.visible.first }
      let(:input) { FactoryBot.create(:input_element, slide: slide) }

      it 'returns the slide URL components' do
        expect(input.url_components).to eq(slide.url_components)
      end
    end

    context 'when the input has no slide' do
      let(:input) { FactoryBot.create(:input_element, slide: nil) }

      it 'returns an empty array' do
        expect(input.url_components).to eq([])
      end
    end
  end
end
