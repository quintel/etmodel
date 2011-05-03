require 'spec_helper'

describe Converter do

  describe "#create" do
    before do
      @converter_id = 10000
      @converter = Converter.create :converter_id => @converter_id
    end
    subject { @converter }
    its(:id) { should == @converter_id }
    it "is actually stored in the db with the id" do
      Converter.find(@converter_id).should_not be_nil
    end
  end

end

# == Schema Information
#
# Table name: blueprint_converters
#
#  id           :integer(4)      not null, primary key
#  blueprint_id :integer(4)
#  converter_id     :integer(4)
#  key          :string(255)
#  name         :string(255)
#  use_id       :integer(4)
#  sector_id    :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

