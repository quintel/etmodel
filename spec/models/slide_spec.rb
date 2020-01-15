require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe Slide do
  it { is_expected.to validate_presence_of :key }
  it_behaves_like 'a model with a position attribute'

  describe '#url_components' do
    context 'when the slide has a sidebar item and tab' do
      let(:slide) { FactoryBot.create(:slide) }

      it 'returns the tab key first' do
        expect(slide.url_components[0]).to eq(slide.sidebar_item.tab.key)
      end

      it 'returns the sidebar item key second' do
        expect(slide.url_components[1]).to eq(slide.sidebar_item.key)
      end

      it 'returns the slide name last' do
        expect(slide.url_components[2]).to eq(slide.short_name)
      end
    end

    context 'when the slide has no sidebar item' do
      let(:slide) { FactoryBot.create(:slide, sidebar_item: nil) }

      it 'returns an empty array' do
        expect(slide.url_components).to eq([])
      end
    end

    context 'when the sidebar item has no tab' do
      let(:slide) do
        Slide.new(sidebar_item: SidebarItem.new(tab_id: nil))
      end

      it 'returns an empty array' do
        expect(slide.url_components).to eq([])
      end
    end
  end
end
