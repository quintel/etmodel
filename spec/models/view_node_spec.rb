require 'spec_helper'

# TODO: speed-up using let blocks wherever possible - PZ Tue 10 May 2011 14:59:14 CEST
describe ViewNode do
  describe "order of nodes" do
    context "TabNode" do
      before do
        @t = Factory :tab_node
      end
      
      it "only valid if parent is root" do
        @t.parent_id = Factory(:tab_node).id
        @t.should_not be_valid
        @t.should have(1).error_on(:parent_id)
      end
      
      it "only valid if element is a tab" do
        elem = Factory(:slide)
        @t.element = elem
        @t.should_not be_valid
        @t.should have(1).error_on(:element_type)

        elem = Factory(:tab)
        @t.element = elem
        @t.should be_valid
      end
    end
    
    context "SidebarItemNode" do
      before do
        @s = Factory :sidebar_item_node
      end
      
      it "only valid if parent is tab" do
        @s.parent_id = Factory(:root_node).id
        @s.should_not be_valid
        @s.should have(1).error_on(:parent_id)
      end

      it "only valid if element is a SidebarItem" do
        elem = Factory(:slide)
        @s.element = elem
        @s.should_not be_valid
        @s.should have(1).error_on(:element_type)

        elem = Factory(:sidebar_item)
        @s.element = elem
        @s.should be_valid
      end
    end
    
    context "SlideNode" do
      before do
        @s = Factory :slide_node
      end
      
      it "only valid if parent is sidebar item" do
        @s.parent_id = Factory(:root_node).id
        @s.should_not be_valid
        @s.should have(1).error_on(:parent_id)
      end
      
      it "only valid if element is a Slide" do
        elem = Factory(:sidebar_item)
        @s.element = elem
        @s.should_not be_valid
        @s.should have(1).error_on(:element_type)

        elem = Factory(:slide)
        @s.element = elem
        @s.should be_valid
      end
    end

    context "InputElementNode" do
      pending
    end

    context "OutputElementNode" do
      pending
    end
  end
end

# The structure is
# RootNode
#   Tab
#     SidebarItem
#       Slide
#         InputElement
#         OutputElement
