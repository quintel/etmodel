require 'spec_helper'

module Qernel

describe ConverterApi, 'FuelCost' do
  before do
    @c = Converter.new(1, :key, 'name')
    @calculator = ConverterApi.new(@c, {})
  end


  describe "#fuel_cost_raw_material_per_mj" do
    context "with values" do
      before do
        @calculator.should_receive(:required_attributes_contain_nil?).and_return(false)
        [:electricity_output_efficiency].each do |key|
          @calculator.should_receive(key).and_return(1.0)
        end

        context "with carrier" do
          before do
            @dataset = Qernel::Dataset.new(1)
            carrier = Carrier.new(1,:a,'a')
            carrier.dataset = @dataset
            carrier.cost_per_mj = 1.0
            carrier.co2_per_mj = 1.0

            @c.should_receive(:input_conversion).with(carrier).and_return(0.5)
            @c.should_receive(:input_carriers).and_return(carrier)
          end

          specify { @calculator.fuel_cost_raw_material_per_mj.should be_within( 0.1).of(0.5)}
        end
      end
    end

    #context "methods required" do
    #  before {
    #    [:electricity_output_efficiency].each do |key|
    #      @calculator.should_receive(key).and_return(nil)
    #    end
    #  }
    #  specify { @calculator.fuel_cost_raw_material_per_mj.should be_nil }
    #end

  end
end

end
