require 'spec_helper'

module Opt
  describe Mission do
    before do
      @mission = Mission.new([],[])
    end

    context "all targets met" do
      before do 
        @mission.stub!(:all_targets_met?).and_return(true)
      end
      subject { @mission }
      its(:fitness) { should be_near(1.0)}
    end

    describe "#fitness" do
      context "with results leading to nan? or infinite? numbers" do
        before { @mission.stub!(:all_targets_met?).and_return(false) }
        subject { @mission }
        its(:fitness) { should == 0.0 }
      end
      
    end

  end
end