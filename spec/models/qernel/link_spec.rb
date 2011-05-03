require 'spec_helper'

module Qernel

  describe Link do
#    before do
#      @dataset = Qernel::Dataset.new(1)
#      @link = Link.new(1, nil, nil, nil, :constant)
#      @link.dataset = @dataset
#    end
#
#    describe "using graph data" do
#      before do
#        attributes = {'value' => 0.4, 'share' => 0.7}
#        @link.dataset.<<(@link.dataset_key => attributes)
#      end
#
#
#      it "should get value" do @link.value.should be_near(0.4) end
#      it "should get share" do @link.share.should be_near(0.7) end
#      it "should set value" do @link.value = 0.6 ; @link.value.should be_near(0.6) end
#      it "should set share" do @link.share = 0.92 ; @link.share.should be_near(0.92) end
#    end
#
#    describe "with share" do
#      before do
#        # TODO: ejp make sure constant links have share == value, this is no longer done in Link#initialize
#        @link.dataset.<<(@link.dataset_key => {'value' => 100, 'share' => 100})
#      end
#
#      it "should assign share as value" do @link.value.should == 100 end
#      it "should be constant?" do @link.constant?.should be_true end
#      it "should be calculated_by_parent?" do @link.calculated_by_parent?.should be_true end
#    end
#
#    describe "without share" do
#      before do
#        @c = Converter.new(1,:c)
#        @c.dataset = @dataset
#        @c.preset_demand = 300.0
#        @link = Link.new(2, nil, @c, nil, :constant)
#        @link.stub!(:output).and_return(mock(Slot, :expected_external_value => 300.0))
#        @link.dataset = @dataset
#      end
#      it "should assign the child-converters output as share" do @link.calculate.should == 300.0 end
#      it "should be calculated_by_child?" do @link.calculated_by_child?.should be_true end
#      it "should have share == nil" do @link.share.should be_nil end
#    end
  end
end
