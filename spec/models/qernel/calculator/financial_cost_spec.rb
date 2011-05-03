require 'spec_helper'

module Qernel

describe ConverterApi do

  before do
    @calculator = ConverterApi.new(nil, {})
  end


  describe "#cost_of_capital" do
    context "without values" do
      before {@calculator.should_receive(:required_attributes_contain_nil?).and_return(true) }
      specify { @calculator.cost_of_capital }
    end

    context "with values" do
      before do
        @calculator.stub!(:required_attributes_contain_nil?).and_return(false)
        @calculator.stub!(:overnight_investment_total).and_return(1.0)
        @calculator.stub!(:typical_production).and_return(1.0)
        @calculator.stub!(:construction_time).and_return(1.0)
        @calculator.stub!(:technical_lifetime).and_return(1.0)
        @calculator.stub!(:wacc).and_return(1.0)
      end
      # 1.0 / 2 * 1.0 * (1.0 + 1.0) / 1.0 => 1
      specify { @calculator.cost_of_capital.should eql(1.0) }
    end
  end

  describe "#overnight_investment_total" do
    context "without values" do
      before {@calculator.should_receive(:required_attributes_contain_nil?).and_return(true) }
      specify { @calculator.overnight_investment_total }
    end

  end
end

end
