class CreateViewNodesForSimpleAndMedium < ActiveRecord::Migration
  def self.up
    
    {
      'medium' => 2, # name => complexity
      'simple' => 1
    }.each do |name, complexity|
      RootNode.find_by_key(name).andand.destroy

      root_node = RootNode.create :key => name
      Tab.all.each do |tab|
        puts tab.key
        tab_node = TabNode.create(:element => tab, :type => 'TabNode', :parent => root_node)
        sidebar_items = SidebarItem.find_all_by_section(tab.key)
        sidebar_items.each do |sidebar_item|

          slides = Slide.controller(sidebar_item.section).
            action(sidebar_item.key).
            max_complexity( complexity ).ordered

          if slides.present?
            puts "- #{sidebar_item.key}"

            sidebar_node = SidebarItemNode.create(:element => sidebar_item, :parent => tab_node)

            slides.each do |slide|
              puts "+- #{slide.name}"
              slide_node = SlideNode.create :element => slide, :parent => sidebar_node
              slide.input_elements.max_complexity( complexity ).each do |input_element|
                puts " +- #{input_element.name}"
                InputElementNode.create :element => input_element, :parent => slide_node
              end
            end
          else # if slides.empty?
            puts "                     #{sidebar_item.key} has no slides"
            next 
          end
        end
      end
    end


  end

  def self.down
  end
end
