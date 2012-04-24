class CreateAdvancedView < ActiveRecord::Migration
  def self.up
    advanced = RootNode.create :key => 'advanced'
    Tab.all.each do |tab|
      puts tab.key
      tab_node = TabNode.create(:element => tab, :type => 'TabNode', :parent => advanced)
      sidebar_items = SidebarItem.find_all_by_section(tab.key)
      sidebar_items.each do |sidebar_item|
        puts "- #{sidebar_item.key}"
        sidebar_node = SidebarItemNode.create(:element => sidebar_item, :parent => tab_node)
        slides = Slide.find_all_by_controller_name_and_action_name(sidebar_item.section, sidebar_item.key)
        
        slides.each do |slide|
          puts "+- #{slide.name}"
          slide_node = SlideNode.create :element => slide, :parent => sidebar_node
          slide.input_elements.each do |input_element|
            puts " +- #{input_element.name}"
            InputElementNode.create :element => input_element, :parent => slide_node
          end
        end
      end
    end
  end

  def self.down
    ViewNode.find_by_key('advanced').destroy
  end
end
