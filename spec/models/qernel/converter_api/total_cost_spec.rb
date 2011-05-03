require 'spec_helper'

module Qernel

describe ConverterApi do
  before do
    @calculator = ConverterApi.new(nil, {})
  end


  describe "#total_cost" do
    #context "with values" do
    #  before do
    #    @calculator.should_receive(:required_attributes_contain_nil?).and_return(false)
    #    [:total_cost_per_mj, :demand, :electricity_output_efficiency].each do |key|
    #      @calculator.should_receive(key).and_return(1.0)
    #    end
    #  end
    #
    #  specify { @calculator.total_cost.should be_within( 0.1).of(1.0)}
    #end

    #context "methods required" do
    #  before {
    #    [:total_cost_per_mj, :demand, :electricity_output_efficiency].each do |key|
    #      @calculator.should_receive(key).and_return(nil)
    #    end
    #  }
    #  specify { @calculator.total_cost.should be_nil }
    #end

  end

  describe "#total_cost_per_mj" do
    context "" do
      before {
        @calculator.should_receive(:values_for_method).and_return([])
        @calculator.should_receive(:sum_unless_empty).and_return(1)
      }
      specify { @calculator.total_cost_per_mj }
    end
    specify { ConverterApi.involved_attributes(:total_cost_per_mj).should_not be_empty}
  end
end

end
