require 'spec_helper'

module Gql::Update
  describe CommandFactory do
    # Make sure all classes have :responsible?(key) method
    COMMAND_TYPES.each do |klass|
      specify { klass.respond_to?(:responsible?).should be_true}
    end

    context "First Command is responsible" do
      before do
        @klass = ::Gql::Update::COMMAND_TYPES.first
        @klass.should_receive(:responsible?).with(anything()).and_return(true)
        @klass.should_receive(:create).with(any_args).and_return(:bla)
      end
      it "should call and return create on #{@klass}" do
        CommandFactory.create(:graph, :proxy, 'key', 0.0).should == :bla
      end
    end

    context "No Command is responsible" do
      before do
        ::Gql::Update::COMMAND_TYPES.each do |klass|
          klass.should_receive(:responsible?).with(anything()).and_return(false)
        end
      end

      specify {CommandFactory.create(:graph, :proxy, 'key', 0.0).should be_nil}
    end
  end
end
