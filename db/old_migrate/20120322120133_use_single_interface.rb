class Interface < ActiveRecord::Base
end
class UseSingleInterface < ActiveRecord::Migration
  def self.up
    add_column :tabs, :position, :integer
    add_column :sidebar_items, :tab_id, :integer
    add_column :sidebar_items, :position, :integer
    add_column :slides, :position, :integer
    add_column :slides, :sidebar_item_id, :integer
    add_column :slides, :output_element_id, :integer
    add_column :input_elements, :position, :integer
    add_column :input_elements, :slide_id, :integer
    add_column :constraints, :position, :integer
    add_index :tabs, :position
    add_index :sidebar_items, :position
    add_index :sidebar_items, :tab_id
    add_index :slides, :sidebar_item_id
    add_index :slides, :position
    add_index :input_elements, :position
    add_index :input_elements, :slide_id
    add_index :constraints, :position

    Tab.reset_column_information
    SidebarItem.reset_column_information
    Slide.reset_column_information
    InputElement.reset_column_information
    Constraint.reset_column_information


    int = YAML::load Interface.find_by_key('advanced').structure

    ct = 0
    int[:dashboard].each do |key|
      ct += 1
      c = Constraint.find_by_key key
      c.update_attribute :position, ct
    end

    tabct = 0
    int[:tabs].each do |tab_key, tab_content|
      tabct += 1
      tab = Tab.find_by_key(tab_key)
      tab.update_attribute :position, tabct
      sidect = 0
      tab_content.each do |sidebar_item_key, sidebar_content|
        sidect += 1
        sidebar_item = SidebarItem.find_by_key sidebar_item_key
        sidebar_item.update_attribute :position, sidect
        sidebar_item.update_attribute :tab_id, tab.id
        slidect = 0
        sidebar_content.each do |slide_key, slide_content|
          slidect += 1
          slide = Slide.find_by_key slide_key
          slide.update_attribute :position, slidect
          slide.update_attribute :sidebar_item_id, sidebar_item.id
          # set the default chart
          output_element_id = OutputElement.find_by_key(slide_content[:output_elements][0]).id rescue nil
          slide.update_attribute :output_element_id, output_element_id if output_element_id
          # slider
          sliderct = 0
          slide_content[:input_elements].each do |slider_key|
            sliderct += 1
            slider = InputElement.find_by_key slider_key
            slider.update_attribute :position, sliderct
            slider.update_attribute :slide_id, slide.id
          end
        end
      end
    end
  end

  def self.down
    remove_column :tabs, :position
    remove_column :sidebar_items, :position
    remove_column :sidebar_items, :tab_id
    remove_column :slides, :position
    remove_column :slides, :sidebar_item_id
    remove_column :slides, :output_element_id
    remove_column :input_elements, :position
    remove_column :input_elements, :slide_id
    remove_column :constraint, :position
  end
end
