require 'spec_helper'

module Gql::Update

describe MarketShareCommand do
  describe "initialize" do
    before do
      @graph = mock_model(Qernel::Graph)
      @parent_key = :truck_kms_demand_transport_energetic
      @flexible_key = :diesel_trucks_transport_energetic

      @flexible_link = mock_model(Qernel::Link, :child => mock_model(Qernel::Converter, :full_key => @flexible_key))
      @other_link = mock_model(Qernel::Link, :child => mock_model(Qernel::Converter, :full_key => :bla), :share => 0.2)

      @parent = mock_model(Qernel::Converter, :input_links => [@flexible_link, @other_link], :full_key => @parent_key)
      @child_link = mock_model(Qernel::Link, :parent => @parent)
      @object = mock_model(Qernel::Converter, :output_links => [@child_link])

      @command_value = 0.1
      @cmd = MarketShareCommand.new(@object, :truck_kms_market_share, @command_value)
    end

    subject { @cmd }

    specify { @object.output_links.detect{|l| l.parent.full_key == @parent_key.to_sym}.should == @child_link}
    specify { @child_link.parent.should == @parent}
    specify { @parent.input_links.detect{|l| l.child.full_key == @flexible_key.to_sym}.should == @flexible_link}

    its(:child_link) { should == @child_link }
    its(:flexible_link) { should == @flexible_link }
    its(:parent) { should == @parent }
    its(:remaining_links) { should have(1).items }

    it "should assign 0.1 to child_link.share" do
      @child_link.should_receive("share=").with(@command_value)
      @flexible_link.should_receive("share=").with(0.8)
      @cmd.execute
    end


    context "sample values and results" do
      
    end

  end
end

end
