# frozen_string_literal: true

require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe Slide do
  describe '.' do
    subject { described_class }

    it { is_expected.to respond_to :ordered }
    it { is_expected.to respond_to :controller }
    it { is_expected.to respond_to :visible }
  end

  describe '.new' do
    subject { described_class.new }
    # Relations
    it { is_expected.to respond_to(:sliders) }
    it { is_expected.to respond_to(:output_element) }
    it { is_expected.to respond_to(:alt_output_element) }
    it { is_expected.to respond_to(:sidebar_item) }
    it { is_expected.to respond_to(:tab) }

    # Attributes
    it { is_expected.to respond_to(:image) }
    it { is_expected.to respond_to(:general_sub_header) }
    it { is_expected.to respond_to(:group_sub_header) }
    it { is_expected.to respond_to(:subheader_image) }
    it { is_expected.to respond_to(:key) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:sidebar_item_id) }
    it { is_expected.to respond_to(:output_element_id) }
    it { is_expected.to respond_to(:alt_output_element_id) }

    # Methods
    it { is_expected.to respond_to(:image_path) }
    it { is_expected.to respond_to(:title_for_description) }
    it { is_expected.to respond_to(:short_name) }
    it { is_expected.to respond_to(:safe_input_elements) }
    it { is_expected.to respond_to(:input_elements_not_belonging_to_a_group) }
    it { is_expected.to respond_to(:grouped_input_elements) }
    it { is_expected.to respond_to(:short_name_for_admin) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:url_components) }
    it { is_expected.to respond_to(:removed_from_interface?) }
  end

  describe '#url_components' do
    context 'when the slide has a sidebar item and tab' do
      let(:slide) { described_class.all.first }

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
      let(:slide) { described_class.where(sidebar_item_id: nil).first }

      it 'returns an empty array' do
        expect(slide.url_components).to eq([])
      end
    end

    context 'when the sidebar item has no tab' do
      let(:slide) do
        described_class.new(sidebar_item: SidebarItem.new(tab_id: nil))
      end

      it 'returns an empty array' do
        expect(slide.url_components).to eq([])
      end
    end
  end

  describe '#input_elements' do
    it 'is an alias of #sliders' do
      expect(subject.input_elements).to eq(subject.sliders)
    end
  end
end
