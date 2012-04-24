class UpdateViewNodesTable < ActiveRecord::Migration
  def self.up
    ViewNode.update_all("type = 'ViewNode::Root'",          "type='RootNode'")
    ViewNode.update_all("type = 'ViewNode::Tab'",           "type='TabNode'")
    ViewNode.update_all("type = 'ViewNode::Sidebar'",       "type='SidebarNode'")
    ViewNode.update_all("type = 'ViewNode::SidebarItem'",   "type='SidebarItemNode'")
    ViewNode.update_all("type = 'ViewNode::Slide'",         "type='SlideNode'")
    ViewNode.update_all("type = 'ViewNode::InputElement'",  "type='InputElementNode'")
    ViewNode.update_all("type = 'ViewNode::OutputElement'", "type='OutputElementNode'")
  end

  def self.down
    ViewNode.update_all("type = 'RootNode'",          "type='ViewNode::Root'")
    ViewNode.update_all("type = 'TabNode'",           "type='ViewNode::Tab'")
    ViewNode.update_all("type = 'SidebarNode'",       "type='ViewNode::Sidebar'")
    ViewNode.update_all("type = 'SidebarItemNode'",   "type='ViewNode::SidebarItem'")
    ViewNode.update_all("type = 'SlideNode'",         "type='ViewNode::Slide'")
    ViewNode.update_all("type = 'InputElementNode'",  "type='ViewNode::InputElement'")
    ViewNode.update_all("type = 'OutputElementNode'", "type='ViewNode::OutputElement'")
  end
end
