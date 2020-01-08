# frozen_string_literal: true

require 'rails_helper'



describe InputElementsController do
  include FactoryBot::Syntax::Methods

  render_views

  describe 'by_slide' do
    # Tab 1
    #   SidebarItem 1
    #     Slide 1
    #       InputElement 1
    #       InputElement 2
    #     Slide 2
    #       InputElement 3
    #   SidebarItem 2
    #     Slide 3
    #       InputElement 4
    # Tab 2
    #   SidebarItem 4

    #     Slide 4
    #       InputElement 5

    let!(:t1) { Tab.all.first }
    let!(:t2) { Tab.all.second }

    let!(:si1) { create :sidebar_item, tab_id: t1.id }
    let!(:si2) { create :sidebar_item, tab_id: t1.id }
    let!(:si3) { create :sidebar_item, tab_id: t2.id }

    let!(:sl1) { create :slide, sidebar_item: si1 }
    let!(:sl2) { create :slide, sidebar_item: si1 }
    let!(:sl3) { create :slide, sidebar_item: si2 }
    let!(:sl4) { create :slide, sidebar_item: si3 }

    let!(:ie1) { create :input_element, slide: sl1 }
    let!(:ie2) { create :input_element, slide: sl1 }
    let!(:ie3) { create :input_element, slide: sl2 }
    let!(:ie4) { create :input_element, slide: sl3 }
    let!(:ie5) { create :input_element, slide: sl4 }

    let(:json) do
      get(:by_slide)
      JSON.parse(response.body)
    end

    it 'contains 4 slides' do
      expect(json.length).to eq(4)
    end

    it 'groups sliders by slide' do
      expect(json[0]['input_elements'].length).to eq(2)

      expect(json[0]['input_elements'][0]['key']).to eq(ie1.key)
      expect(json[0]['input_elements'][1]['key']).to eq(ie2.key)

      expect(json[1]['input_elements'][0]['key']).to eq(ie3.key)
      expect(json[2]['input_elements'][0]['key']).to eq(ie4.key)
      expect(json[3]['input_elements'][0]['key']).to eq(ie5.key)
    end

    describe "json[path]" do
      # this translation code is quite similar to that in "slide_presenter.rb"
      let(:translator) { ->(ns, n) { I18n.t("#{ns}.#{n}") } }

      subject{ json[0]['path'] }

      it { is_expected.to satisfy { |path| path.length == 3 } }
      it { is_expected.to include translator.('tabs', t1.key) }
      it { is_expected.to include translator.('sidebar_items', si1.key) }
      it { is_expected.to include translator.('slides', sl1.key) }
    end

    context 'the inputs' do
      let(:input) { json[0]['input_elements'].first }

      it 'includes each input key' do
        expect(input).to have_key('key')
        expect(input['key']).to eq(ie1.key)
      end

      it 'includes each input translated name' do
        expect(input).to have_key('name')
        expect(input['name']).to include(ie1.key)
      end

      it 'includes each input unit' do
        expect(input).to have_key('unit')
        expect(input['unit']).to eq(ie1.unit)
      end
    end
  end
end
