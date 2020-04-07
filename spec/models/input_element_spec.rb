# frozen_string_literal: true

require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe InputElement do
  describe '.' do
    subject { described_class }

    it { is_expected.to respond_to :ordered }
    it { is_expected.to respond_to :households_heating_sliders }
  end

  describe '.new' do
    subject { described_class.new }
    # Relations

    it { is_expected.to respond_to(:slide) }

    # Attributes
    it { is_expected.to respond_to(:key) }
    it { is_expected.to respond_to(:share_group) }
    it { is_expected.to respond_to(:step_value) }
    it { is_expected.to respond_to(:unit) }
    it { is_expected.to respond_to(:fixed) }
    it { is_expected.to respond_to(:interface_group) }
    it { is_expected.to respond_to(:command_type) }
    it { is_expected.to respond_to(:related_converter) }
    it { is_expected.to respond_to(:position) }

    # Methods
    it { is_expected.to respond_to(:title_for_description) }
    it { is_expected.to respond_to(:translated_name) }
    it { is_expected.to respond_to(:belongs_to_a_group?) }
    it { is_expected.to respond_to(:disabled) }
    it { is_expected.to respond_to(:json_attributes) }
    it { is_expected.to respond_to(:parsed_name_for_admin) }
    it { is_expected.to respond_to(:has_flash_movie) }
    it { is_expected.to respond_to(:sanitized_description) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:url_components) }
    it { is_expected.to respond_to(:ie8_sanitize) }
    it { is_expected.to respond_to(:enum?) }
  end

  describe '.with_related_converter_like' do
    subject { described_class.with_related_converter_like('households') }

    let(:ie) do
      described_class
        .where(related_converter: 'households_solar_pv_solar_radiation')[0]
    end

    it { is_expected.to include ie }
  end

  describe '#url_components' do
    context 'when the input a slide, sidebar item, and tab' do
      let(:slide) { Slide.visible.first }
      let(:input) { slide.sliders.first }

      it 'returns the slide URL components' do
        expect(input.url_components).to eq(slide.url_components)
      end
    end

    context 'when the input has no slide' do
      let(:input) { described_class.new(slide_key: nil) }

      it 'returns an empty array' do
        expect(input.url_components).to eq([])
      end
    end
  end

  it '#slide returns the slide' do
    slide = Slide.all.first
    ie = described_class.new(slide_key: slide.key)
    expect(ie.slide).to eq slide
  end

  describe '#sanitized_description' do
    subject do
      ie = described_class.new
      allow(ie).to receive(:description).and_return "'foobar'"
      ie.sanitized_description
    end

    it { is_expected.to eq '&#39;foobar&#39;' }
  end

  # We might want to lift these preconditions to the applications from the
  # testsuite as it provides better feedback to the modelers that way.
  describe 'YAML file' do
    subject { described_class.all }

    it 'has unique keys' do
      keys = subject.map(&:key)
      expect(keys.size).to eq(keys.uniq.size)
    end

    it 'has unique ids' do
      ids = subject.map(&:id)
      expect(ids.size).to eq(ids.uniq.size)
    end
  end
end
