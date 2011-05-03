require 'spec_helper'

describe OutputElement do
  before(:all) do 
    @output_element = OutputElement.new
  end

  describe "#under_construction" do
    it "should return true when country = DE and id = buildings" do
      Current.stub(:country).and_return("de")
      @output_element.under_construction(:country => Current.country, :id => 'buildings').should be_true
    end
    it "should return true when country = DE and id = households" do
      Current.stub(:country).and_return("de")
      @output_element.under_construction(:country => Current.country, :id => 'households').should be_false
    end
    it "should return true when country = NL and id = buildings" do
      Current.stub(:country).and_return("nl")
      @output_element.under_construction(:country => Current.country, :id => 'buildings').should be_false
    end
    it "should return true when country = NL and id = households" do
      Current.stub(:country).and_return("nl")
      @output_element.under_construction(:country => Current.country, :id => 'houdeholds').should be_false
    end
    it "should return true when attribute under_construction is true" do
      @output_element.under_construction = true
      @output_element.under_construction.should be_true
    end
    it "should return false when attribute under_construction is false" do
      @output_element.under_construction = false
      @output_element.under_construction.should be_false
    end
  end

  describe "Blockchart" do
    before { @block_chart = OutputElement.new }
    it "should be a block_chart? if it has the ID 32" do
      @block_chart.stub!(:id).and_return(32)
      @block_chart.block_chart?.should be_true
    end
    
  end

end

# == Schema Information
#
# Table name: output_elements
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  output_element_type_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  under_construction     :boolean(1)      default(FALSE)
#  legend_columns         :integer(4)
#  legend_location        :string(255)
#  unit                   :string(255)
#  percentage             :boolean(1)
#  group                  :string(255)
#  show_point_label       :boolean(1)
#  growth_chart           :boolean(1)
#

# == Schema Information
#
# Table name: output_elements
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  output_element_type_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  under_construction     :boolean(1)      default(FALSE)
#  legend_columns         :integer(4)
#  legend_location        :string(255)
#  unit                   :string(255)
#  percentage             :boolean(1)
#  group                  :string(255)
#  show_point_label       :boolean(1)
#  growth_chart           :boolean(1)
#
