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
    it { is_expected.to respond_to(:key) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:sidebar_item_key) }
    it { is_expected.to respond_to(:output_element_key) }

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

    context 'when the sidebar item has no tab' do
      let(:slide) do
        described_class.new(sidebar_item: SidebarItem.new(tab_id: nil))
      end

      it 'returns an empty array' do
        expect(slide.url_components).to eq([])
      end
    end
  end

  describe '#short_name' do
    context 'when the name contains "&"' do
      it 'replaces the ampersand with "and"' do
        slide = described_class.new(key: 'hello')

        allow(I18n).to receive(:t).and_call_original
        allow(I18n).to receive(:t).with('slides.hello.title', locale: :en).and_return('one & two')

        expect(slide.short_name).to eq('one-and-two')
      end
    end
  end

  describe '#input_elements' do
    it 'is an alias of #sliders' do
      expect(subject.input_elements).to eq(subject.sliders)
    end
  end

  describe '#tab' do
    it 'the same tab as the tab of its sidebar_item' do
      sidebar_item = Tab.all.first.sidebar_items.first
      slide = described_class.new(sidebar_item_key: sidebar_item.key)
      expect(slide.tab).to eq(sidebar_item.tab)
    end
  end

  describe '#sidebar_item' do
    it 'returns a sidebar_item' do
      expect(described_class.all.first.sidebar_item)
        .to be_a(SidebarItem)
    end

    it 'returns the related sidebar_item' do
      sidebar_item = SidebarItem.all.first
      subject { described_class.find_by(sidebar_item_id: sidebar_item.id) }
    end
  end

  describe '.index' do
    it 'is indexed on :key' do
      expect(described_class.index).to eq(:key)
    end
  end

  # We might want to lift these preconditions to the applications from the
  # testsuite as it provides better feedback to the modelers that way.
  describe 'YAML file' do
    subject { described_class.all }

    it 'has unique keys' do
      keys = subject.map(&:key)
      expect(keys.size).to eq(keys.uniq.size)
    end
  end
end
