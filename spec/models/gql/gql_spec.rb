require 'spec_helper'

module Gql

describe Gql do
  describe "initalize" do
    before {@gql = ::Gql::Gql.new(:testing)}
    specify {@gql.should_not be_nil}
  end
  describe "initalize" do
    before do
      @present = mock_model(::Qernel::Graph, :area => :area_present, 'year=' => nil)
      @future = mock_model(::Qernel::Graph, :area => :area_future, 'year=' => nil)
      @graph_model = mock_model(::Graph, 
        :present => @present,
        :future => @future
      )
      Current.stub!(:year).and_return(2010)
      Current.stub!(:end_year).and_return(2040)
      @gql = ::Gql::Gql.new(@graph_model)
    end
    subject { @gql}
    its(:present) { should == @present }
    its(:future) { should == @future }

    describe "#policy" do
      subject { @gql.policy }
      # TODO refactor This actually does not belong in here. should be tested in policy_spec
      its(:present_graph) { should == @present }
      its(:future_graph) { should == @future }
      its(:area) { should == :area_future }
      its(:present_area) { should == :area_present }
    end
  end

  

#  before do
#    Current.stub!(:update_statements).and_return({})
#    @c = Qernel::Converter.new(1, 'test')
#    @c.calculator = @calc = Qernel::ConverterApi.new(@c, {})
#    dataset = Qernel::Dataset.new(1)
#    @present = Qernel::Graph.new([@c], dataset)
#    @future = Qernel::Graph.new([@c], dataset)
#    @gql = Gql.new(@present, @future).prepare_graphs
#    @gql.stub!(:select).and_return([@c])
#  end
#
#  it "should call graph_query for future and present graph" do
#    @gql.should_receive(:query_present).with("sum.abc").and_return('foo')
#    @gql.should_receive(:query_future).with("sum.abc").and_return('foo')
#    @gql.query("sum.abc")
#  end
#
#  describe "return an array of arrays [[2010,foo], [2040,bar]]" do
#    before do
#      @calc.should_receive(:bar).twice
#      @res = @gql.query("sum.abc.bar")
#    end
#
#    specify { @res.should have(2).items }
#    specify { @res.first.should have(2).items }
#    specify { @res.last.should have(2).items }
#  end
#
#  describe "sum.abc.foo,abc.bar" do
#    before do
#      @calc.should_receive(:foo).twice.and_return(1)
#      @calc.should_receive(:bar).twice.and_return(2)
#      @res = @gql.query("sum.abc.foo,abc.bar")
#    end
#
#    it "should return an array of two arrays" do
#      @res.present_value.should be(3)
#    end
#  end
#
#  describe "sum.abc.foo," do
#    before do
#      @calc.should_receive(:foo).twice.and_return(1)
#      @res = @gql.query("sum.abc.foo,")
#    end
#
#    it "should return an array of two arrays" do
#      @res.present_value.should be(1)
#    end
#  end
#
#  describe "bad method_names" do
#    [
#     "sum.abc.",
#     "sum.abc",
#     "sum.abc.method_unknown"
#    ].each do |query|
#
#      it "raises GqlError for: #{query}" do
#        lambda {@gql.query(query)}.should raise_exception(GqlError)
#      end
#    end
#  end
end

end
