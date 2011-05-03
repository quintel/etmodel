require 'spec_helper'

module Opt
  describe GqueryControl do
    before do
      @gquery_mock = mock(:gquery)
      @gquery_mock.stub!(:id)
    end

    describe "#fitness" do
      before(:each) do
        @control1 = GqueryControl.new(@gquery_mock, 100, 1)
        @control2 = GqueryControl.new(@gquery_mock, 100, 2)
      end
      subject { @control1 }

      context "higher future value" do
        before { @control1.stub(:future_value).and_return(110) }
        its(:fitness) { should be > 1.0 }
        context "compared to other control with even higher value" do
          before { @control2.stub(:future_value).and_return(120) }
          its(:fitness) { should be < @control2.fitness }
        end
      end

      context "lower future value" do
        before { @control1.stub(:future_value).and_return(90) }
        its(:fitness) { should be 0}
        its(:target_met?) { should be_true}
      end
    end

    describe "#weighted_fitness" do
      before do
        @control = GqueryControl.new(@gquery_mock, 100, 2.0)
        @control.stub!(:fitness).and_return(2.0)
      end
      subject { @control.weighted_fitness } 
      it { should be_near(2.0*2.0) }

      context "compared to a same fitness but higher weight" do
        before do
          @control2 = GqueryControl.new(@gquery_mock, 100, 5.0)
          @control2.stub!(:fitness).and_return(2.0)
        end
        it { should be < @control2.weighted_fitness}
      end
    end


    describe "#initialize" do
      before do
        @gquery_control = GqueryControl.new(mock_model(Gquery, :id => 2), "2.0", "3.0")
      end
      subject { @gquery_control}
      its(:id) { should == 2 }
      its(:target) { should be_near(2.0)}
      its(:weight) { should be_near(3.0)}
    end

  end
end