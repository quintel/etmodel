##
# TODO rename to View
#
class ViewSetting
  attr_reader :setting_key, :tab_key, :sidebar_item_key, :slide_key

  def initialize(setting_key, tab_key, sidebar_item_key, slide_key = nil)
    @setting_key = setting_key.to_s
    @tab_key = tab_key.to_s
    @sidebar_item_key = sidebar_item_key.to_s
    @slide_key = slide_key
  end

  def root
    @root ||= RootNode.find_by_key(setting_key)
  end
 
  # TODO use ids instead of 
  # TODO memoize those methods, so that they can be cached.

  ##
  # @return [Array<Tab>]
  #
  def tabs
    tab_nodes.map(&:element)
  end

  ##
  # @return [Array<SidebarItem>]
  #
  def sidebar_items
    sidebar_item_nodes.map(&:element).reject(&:area_dependent)
  end

  ##
  # @return [Array<Slide>]
  #
  def slides
    slide_nodes.map(&:element)
  end

  ##
  # @return [Tab]
  #
  def current_tab
    current_tab_node.element
  end

  ##
  # @return [SidebarItem]
  #
  def current_sidebar_item
    current_sidebar_item_node.element
  end

  ##################
  # OutputElement
  ##################

    ##
    # @param [Slide] slide
    # @return [OutputElement]
    #
    def default_output_element_for(slide)
      output_element_nodes(slide).first.andand.element || OutputElement.find(slide.default_output_element_id)
    end

    ##
    # @param [Slide] slide
    # @return [OutputElement]
    #
    def default_output_element_for_sidebar_item
      output_element_nodes(slides.first).first.andand.element
    end

  ##################
  # InputElements
  ##################

    ##
    # @param [Slide] slide
    # @return [Array<InputElement>]
    #
    def input_elements_for(slide)
      elements = input_element_nodes(slide).map(&:element)
      if elements.any?(&:nil?)
        Rails.logger.warn("ViewSetting: slide (#{slide.andand.id}, #{slide.andand.name}) contains nodes with NIL-elements") 
      end
      elements.compact.reject(&:area_dependent)
    end

    ##
    # Gets the input elements without a interface group for a slide
    #
    # @param [Slide] slide
    # @return [Array<InputElement>]
    #
    def ungrouped_input_elements_for(slide)
      input_elements_for(slide).
        select{|input_element| input_element.interface_group.blank? }
    end

    ##
    # Gets a interface groups hash with an array of input elements.
    #
    # @return [Hash] interface_group => [InputElement]
    #
    def interface_groups_with_input_elements_for(slide)
      interface_groups = {}
      input_elements = input_elements_for(slide).
        reject{|input_element| input_element.interface_group.blank? }

      input_elements.each do |input_element|
        interface_groups[input_element.interface_group] ||= [] 
        interface_groups[input_element.interface_group] << input_element
      end

      interface_groups
    end

private

  def tab_nodes
    @tab_nodes ||= root.children.element_list
  end

  def current_tab_node
    @current_tab_node ||= tab_nodes.detect{|tab| tab.element.key == tab_key}
  end

  def current_sidebar_item_node
    @current_sidebar_item_node ||= sidebar_item_nodes.detect{|s| s.element.key == sidebar_item_key}
  end

  def sidebar_item_nodes
    return [] unless current_tab_node
    @sidebar_item_nodes ||= current_tab_node.children.element_list
  end

  def slide_node(slide)
    return nil if slide.nil?
    slide_nodes.detect{|slide_node| slide_node.element_id == slide.id }
  end

  def input_element_nodes(slide)
    return [] if slide.nil?
    slide_node(slide).children.element_list.select{|c| c.input_element? }
  end

  def output_element_nodes(slide)
    return [] if slide.nil?
    slide_node(slide).children.element_list.select{|c| c.output_element? }
  end

  def slide_nodes
    if current_sidebar_item_node
      @slide_nodes ||= current_sidebar_item_node.children.element_list
    else
      []
    end
  end
end