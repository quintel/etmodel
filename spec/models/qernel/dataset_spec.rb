require 'spec_helper'

module Qernel

describe Dataset do
  before do
    @dataset = Qernel::Dataset.new(1)
  end

  describe "#<<" do
    before do
      @dataset << {:foo => {:bar => 1}}
    end

    it "should assign " do
      @dataset.get(:foo, :bar).should be(1)
    end
  end

  describe "set :foo, :bar, 2" do
    before do
      @dataset << {:foo => {:bar => 1}}
      @dataset.set :foo, :bar, 2
    end

    it "should assign " do
      @dataset.get(:foo, :bar).should be(2)
    end
  end

  describe "add" do
    before do
      @dataset.add(
        [mock_model(Qernel::Converter, :dataset_attributes => {:converter_key => {:value => 3}}, :each => nil)]
      )
    end

#    it "should assign " do
#      @dataset.get(:converter_key, :value).should be(3)
#    end
  end


end

end
