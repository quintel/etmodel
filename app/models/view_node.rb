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

##
# In the user-facing front end, ViewNode and all depending classes
# should not be used. Use {ViewSetting} instead!
#
#
# ViewNodes manage what elements will be shown to the end user.
# It starts with a root element, that is referenced by the attribute
# key (e.g. 'advanced', 'simple'). It is followed then by Tabs, SidebarItem
# Slides, InputElements.
#
# e.g.
# - advanced
# +- Demand
#  ++ Households
#   +- Growth
#   +- Insulation
#  +- etc.
#
# The ViewNodes themselves only refer to other items using polymorphic 
# associations.
#
# == Single Table Inheritance and different ViewNode types
#
# ViewNode uses STI to differentiate between different NodeTypes.
# Currently:
# RootNode (advanced)
# +- TabNode (demand)
#  +- SidebarItemNode (households)
#   +- SlideNode (insulation)
#    +- InputElementNode
#
#
#
# == Nested Tree implementation: Ancestry Gem + acts_as_list for ordering
# https://github.com/stefankroes/ancestry
# https://github.com/stefankroes/ancestry/wiki/Integrating-with-Acts-As-List
#
# The reason I (seb 2011-01-03) chose Ancestry over any other nested_tree implementation
# is the ability to easily understand and modify the structure in mysql.
# While most nested_tree implementations use complicated lft and rgt 
# or slow parent_id implementations. Also it is properly documented and 
# (apparently) well tested.
# 
#
class ViewNode < ActiveRecord::Base
  has_ancestry :cache_depth => true
  acts_as_list :scope => 'ancestry = \'#{ancestry}\''
  # scope :ordered, :order=> "ancestry_depth, position ASC"

  # we order type first because of input_elements/output_elements
  scope :element_list, :order => "type ASC, position ASC", :include => "element"

  belongs_to :element, :polymorphic => true

  TYPES = %w[root tab sidebar_item slide input_element output_element]

  TYPES.each do |type|
    node_class_name = "#{type.camelcase}Node"

    ##
    # e.g.
    # def root?
    #   self.type == "RootNode"
    # end
    #
    define_method "#{type}?" do
      self.type == node_class_name
    end

    ##
    # e.g.
    # def parent_is_root
    #   unless parent.andand.send(root?)
    #     errors.add(:parent_id, "parent has to be root")
    #   end
    # end
    #
    define_method "parent_is_#{type}" do
      unless parent.andand.send("#{type}?")
        errors.add(:parent_id, "parent has to be #{type}")
      end
    end
  end

  def category?;      self.type == "SidebarItemNode"; end

  def element_type_or_default
    self[:element_type] || default_element_type
  end

  def default_element_type
    case parent.depth
    when 0 then 'Tab'
    when 1 then 'SidebarItem'
    when 2 then 'Slide'
    when 3 then 'InputElement'
    else ''
    end
  end

  def self.build_typed(attributes)
    element_type = attributes[:element_type]
    if attributes[:parent_id].blank?
      attributes[:element_type] = nil 
      element_type = "Root"
    end
    
    type = "#{element_type.camelcase}Node".constantize
    type.new(attributes)
  end


  ##
  # Sorting!
  #
  # Copy pasted from https://github.com/stefankroes/ancestry/wiki/Integrating-with-Acts-As-List
  #
  # I haven't tested or used those methods. I just added them for completeness sake.
  # 
  #
  #
  # Accepts the typical array of ids from a scriptaculous sortable. 
  # It is called on the instance being moved
  def sort(array_of_ids)
    if array_of_ids.first == id.to_s
      move_to_left_of siblings.find(array_of_ids.second)
    else
      move_to_right_of siblings.find(array_of_ids[array_of_ids.index(id.to_s) - 1])
    end
  end

  def move_to_child_of(reference_instance)
    transaction do
      remove_from_list
      self.update_attributes!(:parent => reference_instance)
      add_to_list_bottom
      save!
    end
  end

  def move_to_left_of(reference_instance)
    transaction do
      remove_from_list
      reference_instance.reload # Things have possibly changed in this list
      self.update_attributes!(:parent_id => reference_instance.parent_id)
      reference_item_position = reference_instance.position
      increment_positions_on_lower_items(reference_item_position)
      self.update_attribute(:position, reference_item_position)
    end
  end

  def move_to_right_of(reference_instance)
    transaction do
      remove_from_list
      reference_instance.reload # Things have possibly changed in this list
      self.update_attributes!(:parent_id => reference_instance.parent_id)
      if reference_instance.lower_item
        lower_item_position = reference_instance.lower_item.position
        increment_positions_on_lower_items(lower_item_position)
        self.update_attribute(:position, lower_item_position)
      else
        add_to_list_bottom
        save!
      end
    end   
  end
  def self.create_new_view(old_view,new_view)
    old_view = ViewNode.find_by_key(old_view)
    new_view = RootNode.new(:key=>new_view)
    new_view.save
    old_view.children.each do |old_tab|
      #generate tabs
      new_tab = TabNode.new(:element_id=> old_tab.element_id, :element_type=>'Tab',:ancestry=>"#{new_view.id}",:position=>old_tab.position,:ancestry_depth=>old_tab.ancestry_depth)
      new_tab.save
      old_tab.children.each do |old_sidebar|
        #generate sidebars
        new_sidebar = SidebarItemNode.new(:element_id=> old_sidebar.element_id, :element_type=>'SidebarItem',:ancestry=>"#{new_view.id}/#{new_tab.id}",:position=>old_sidebar.position,:ancestry_depth=>old_sidebar.ancestry_depth)
        new_sidebar.save
        old_sidebar.children.each do |old_slide|
          #generate sidebars
          new_slide = SlideNode.new(:element_id=> old_slide.element_id, :element_type=>'Slide',:ancestry=>"#{new_view.id}/#{new_tab.id}/#{new_sidebar.id}",:position=>old_slide.position,:ancestry_depth=>old_slide.ancestry_depth)
          new_slide.save
          old_slide.children.each do |old_input|
            #generate inputelements
            InputElementNode.new(:element_id=> old_input.element_id, :element_type=>'InputElement',:ancestry=>"#{new_view.id}/#{new_tab.id}/#{new_sidebar.id}/#{new_slide.id}",:position=>old_input.position,:ancestry_depth=>old_input.ancestry_depth).save
          end
        end
      end
    end
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
