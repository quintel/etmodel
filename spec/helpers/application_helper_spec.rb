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
describe ApplicationHelper do
  describe 'format_description' do
    it 'does not alter plain strings' do
      expect(format_description('test string')).to eq('test string')
    end

    it 'ignores blank interpolation keys' do
      expect(format_description('%{}')).to eq('%{}')
    end

    it 'ignores non-existent interpolation keys' do
      expect(format_description('%{nope}')).to eq('')
    end

    it 'permits stand-alone percent signs' do
      expect(format_description('test % str')).to eq('test % str')
    end

    it 'ignores sprintf-style formatting strings' do
      expect(format_description('test %f str')).to eq('test %f str')
    end

    it 'does not alter HTML substings' do
      expect(format_description('test <b>string</b>'))
        .to eq('test <b>string</b>')
    end

    it 'interpolates "end_year"' do
      expect(format_description('%{end_year}')).to eq('2050')
    end

    it 'interpolates "area_code"' do
      expect(format_description('%{area_code}')).to eq('nl')
    end
  end
end
