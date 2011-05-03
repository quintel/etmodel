require 'spec_helper'

module Qernel
  describe ConverterApi do
#    describe "calculations" do
#      before do
#        @attrs = ConverterApi::ATTRIBUTES_USED.inject({}) {|hsh, key| hsh.merge key.to_s => 100}
#        @converter_cost = ConverterApi.new(nil, @attrs)
#      end
#
##      it "all derived attributes are based on static attributes"
#    end
#
#    describe "initializing" do
#      before do
#        @attrs = ConverterApi::ATTRIBUTES_USED.inject({}) {|hsh, key| hsh.merge key.to_s => 100}
#        @converter_cost = ConverterApi.new(nil, @attrs)
#      end
#
#      ConverterApi::ATTRIBUTES_USED.each do |key|
#        it "should assign @#{key}" do
#          @converter_cost.instance_variable_get("@#{key}").should be(100)
#        end
#
#        it "should create accessor @#{key}" do
#          @converter_cost.send(key).should be(100)
#        end
#      end
#    end
#
#    describe "fuel_cost_raw_material" do
#      before do
#        @dataset = Qernel::Dataset.new(1)
#        @converter = Qernel::Converter.new(1,"Converter")
#        @converter.dataset = @dataset
#        @converter2 = Qernel::Converter.new(2,"Converter2")
#        @converter2.dataset = @dataset
#        @c1 = Qernel::Carrier.new(1, :natural_gas, 'natural gas')
#        @c1.dataset = @dataset
#        @c1.cost_per_mj = 0.003051111
#        @c1.co2_per_mj = 56060.59661
#        @c2 = Qernel::Carrier.new(2, :other_gas, 'other gas')
#        @c2.dataset = @dataset
#        @c2.cost_per_mj = 0.005
#        @c2.co2_per_mj = 3000.59661
#
#        @link1 = Qernel::Link.new(1, @converter, @converter2, @c1, :share)
#        @link1.dataset = @dataset
#        @link1.share = 1.0
#        @link2 = Qernel::Link.new(2, @converter, @converter2, @c2, :share)
#        @link2.dataset = @dataset
#        @link2.share = 1.0
#
#        @converter.stub!(:input_links).and_return([@link1, @link2])
##        @converter.stub!(:output_for_carrier).with(@c1).and_return(10.0**6)
##        @converter.stub!(:output_for_carrier).with(@c2).and_return(10.0**6)
#        @converter_cost = ConverterApi.new(@converter,{})
#      end
#
##      it "should calculate fuel_cost_raw_material_for_carrier" do
##        @converter_cost.fuel_cost_raw_material_for_carrier(@c1).should be_within( 0.01).of(((@c1.cost_per_mj * 10.0**6)) )
##        @converter_cost.fuel_cost_raw_material_for_carrier(@c2).should be_within( 0.01).of(((@c2.cost_per_mj * 10.0**6)) )
##      end
##
##      it "should sum every fuel_cost_raw_material_for_carrier" do
##        @converter_cost.fuel_cost_raw_material.should be_close(
##          @converter_cost.fuel_cost_raw_material_for_carrier(@c1) +
##          @converter_cost.fuel_cost_raw_material_for_carrier(@c2),
##          0.01
##        )
##      end
#    end
#
#
#  describe "expected?" do
#    before do
#      @qernel = ConverterApi.new(nil, {})
#    end
#
#    context "demand nil" do
#      before  { @qernel.stub!(:demand).and_return(nil) }
#      specify { @qernel.demand_expected?.should be_nil }
#    end
#
#    context "demand 1Mio" do
#      before { @qernel.stub!(:demand).and_return(10.0**6) }
#
#      context "expected outside tolerance" do
#        before  { @qernel.stub!(:demand_expected_value).and_return(@qernel.demand*(1+ConverterApi::EXPECTED_DEMAND_TOLERANCE * 1.1)) }
#        specify { @qernel.demand_expected?.should be_false }
#      end
#
#      context "expected inside tolerance" do
#        before  { @qernel.stub!(:demand_expected_value).and_return(@qernel.demand*(1+ConverterApi::EXPECTED_DEMAND_TOLERANCE * 0.9)) }
#        specify { @qernel.demand_expected?.should be_true }
#      end
#
#      context "expected is nil" do
#        before { @qernel.stub!(:demand_expected_value).and_return(nil) }
#        specify { @qernel.demand_expected?.should be_nil }
#      end
#    end
#
#    it "should be true if both values are 0" do
#      @qernel.stub!(:demand).and_return(0)
#      @qernel.stub!(:demand_expected_value).and_return(0)
#      @qernel.demand_expected?.should be_true
#    end
#  end
#
#  describe Converter, 'method_missing' do
#    before do
#      @carrier = Qernel::Carrier.new(1, :electricity, 'Electricity')
#      @carrier.dataset = Qernel::Dataset.new(1)
#      @carrier.cost_per_mj = 0.1
#      @carrier.co2_per_mj = 0.1
#
#      @calculator = Qernel::ConverterApi.new(nil, {})
#      @calculator.stub!(:output_of_carrier).with(@carrier).and_return(300.0)
#      @calculator.stub!(:input_of_carrier).with(@carrier).and_return(290.0)
#      ::Carrier.stub!(:lookup).with(:electricity).and_return(@carrier)
#    end
#
#    it "should return demand_of_electricity" do
#      @calculator.output_of_electricity.should be_within( 0.01).of(300.0)
#    end
#
#    it "should return supply_of_electricity" do
#      @calculator.input_of_electricity.should be_within( 0.01).of(290.0)
#    end
#  end
#
end

end
