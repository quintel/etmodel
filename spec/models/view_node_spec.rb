require 'spec_helper'

describe ViewNode do
  
  describe "order of nodes" do
    before { r = RootNode.create :key => 'test'}
    context "TabNode" do
      pending "only valid if parent is root"
      pending "only valid if element is a tab"
    end
    context "SlideNode" do
      pending "only valid if parent is tab"
      pending "only valid if element is a Slide"
    end
    context "SidebarItemNode" do
      pending "only valid if parent is slide"
      pending "only valid if element is a SidebarItem"
    end
    # etc
  end
end

# == Schema Information
#
# Table name: view_nodes
#
#  id             :integer(4)      not null, primary key
#  key            :string(255)
#  element_id     :integer(4)
#  element_type   :string(255)
#  ancestry       :string(255)
#  position       :integer(4)
#  ancestry_depth :integer(4)      default(0)
#  type           :string(255)
#
