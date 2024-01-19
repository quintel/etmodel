# frozen_string_literal: true

require 'rails_helper'

# TODO: All these tests are convoluted. Its hard to understand what is being
# tested exactly and there a pretty brittle because they use real yaml data.
describe SlidePresenter do
  # Tab 1
  #   SidebarItem 1
  #     Slide 1
  #       InputElement 1
  #       InputElement 2
  #     Slide 2
  #   SidebarItem 2
  #     Slide 3
  # Tab 2
  #   SidebarItem 3
  #     Slide 4

  let(:t1) { Tab.all.second } # demand
  let(:t2) { Tab.all.third } # supply

  let(:si1) { t1.sidebar_items.first }
  let(:si2) { t1.sidebar_items.second }

  let(:sl1) { si1.slides.second }
  let(:sl2) { si1.slides.third }
  let(:sl3) { si2.slides.first }
  let(:sl4) { t2.sidebar_items.first.slides.first }

  # input_elements
  let(:ie1) { sl1.sliders.first }
  let(:ie2) { sl1.sliders.second }

  let(:collection) do
    described_class.collection([sl1, sl2, sl3, sl4])
  end

  describe '.collection' do
    it { expect(collection.length).to eq(4) }

    describe 'slide -> input elements' do
      subject { collection[0][:input_elements] }

      it { is_expected.to be_a Enumerable }
    end

    describe  'slide -> input elements -> first' do
      subject { collection[0][:input_elements][0] }

      it { is_expected.to have_key('name') }
      it { is_expected.to have_value(ie1.translated_name) }

      it { is_expected.to have_key('unit') }
      it { is_expected.to have_value(ie1.unit) }
    end

    describe 'slide -> path -> first' do
      subject { collection[0][:path] }

      let(:translator) { ->(ns, n) { I18n.t("#{ns}.#{n}") } }

      it 'has the expected short name' do
        expect(subject)
          .to include translator.call('sidebar_items', "#{si1.key}.short_title")
      end

      it { is_expected.to include translator.call('tabs', t1.key) }
      it {
        is_expected.to include translator.call('slides', "#{sl1.key}.title")
      }
    end
  end
end
