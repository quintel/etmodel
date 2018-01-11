require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ConstraintHelper do
  describe 'area_map_path' do
    let(:area) { double(area: area_code, base_dataset: base_dataset) }
    let(:area_code) { nil }
    let(:base_dataset) { nil }

    before do
      allow(helper).to receive(:area_setting).and_return(area)
    end

    context 'with "nl"' do
      let(:area_code) { 'nl' }

      it 'returns the path to the NL image' do
        expect(helper.area_map_path).to end_with('/nl_map.png')
      end

      context 'and a suffix "_grey"' do
        it 'returns the path to the grey NL image' do
          expect(helper.area_map_path('_grey')).to end_with('/nl_map_grey.png')
        end
      end
    end

    context 'with nl2013' do
      let(:area_code) { 'nl2013' }

      it 'returns the path to the NL image' do
        expect(helper.area_map_path).to end_with('/nl_map.png')
      end
    end

    context 'with nl-hi' do
      let(:area_code) { 'nl-hi' }

      it 'returns the path to the NL image' do
        expect(helper.area_map_path).to end_with('/nl_map.png')
      end
    end

    context 'with a base_dataset=de' do
      let(:area_code) { 'frankfurt' }
      let(:base_dataset) { 'de' }

      it 'returns the path to the DE image' do
        expect(helper.area_map_path).to end_with('/de_map.png')
      end
    end
  end
end
