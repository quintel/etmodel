require 'spec_helper'

describe Carrier do

  describe "#create" do
    before do
      Carrier.delete_all
      @carrier_id = 10
      @blueprint_carrier = Carrier.create :carrier_id => @carrier_id
    end
    subject { @blueprint_carrier }

    its(:id) { should == @carrier_id }
    it "is actually stored in the db with the id" do
      Carrier.find(@carrier_id).should_not be_nil
    end
  end

end

# == Schema Information
#
# Table name: blueprint_carriers
#
#  id           :integer(4)      not null, primary key
#  blueprint_id :integer(4)
#  excel_id     :integer(4)
#  key          :string(255)
#  name         :string(255)
#  infinite     :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

