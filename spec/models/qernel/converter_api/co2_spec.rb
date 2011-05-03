require 'spec_helper'

module Qernel

describe ConverterApi do
  before do
    @calculator = ConverterApi.new(nil, {})
  end


  describe "#co2_of_input" do
    before do
      @calculator.should_receive(:co2_of_input_including_co2_free).and_return(100.0)
    end
    subject { @calculator }
    context "with co2_free" do
      before { @calculator.should_receive(:co2_free).twice.and_return(50.0) }
      it "should subtract co2_free from co2_of_input" do
        @calculator.co2_of_input.should be_near(50.0)
      end
    end
    context "with undefined co2_free" do
      before { @calculator.should_receive(:co2_free).and_return(nil) }
      it "should not fail" do
        @calculator.co2_of_input.should be_near(100.0)
      end
    end
    context "co2_free higher then co2_of_input" do
      before { @calculator.should_receive(:co2_free).twice.and_return(150.0) }
      it "should return 0.0" do
        @calculator.co2_of_input.should be_near(0.0)
      end
    end
  end
end

end
