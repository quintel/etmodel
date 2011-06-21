##
# TODO rename to View
#
class ViewSetting
  attr_reader :setting_key, :tab_key, :sidebar_item_key, :slide_key

  def initialize(setting_key, tab_key, sidebar_item_key, slide_key = nil)
    @setting_key      = setting_key.to_s
    @tab_key          = tab_key.to_s
    @sidebar_item_key = sidebar_item_key.to_s
    @slide_key        = slide_key
  end


  def interface
    @interface ||= Interface.find_by_key(setting_key)
  end
 
  def tabs
    interface.tabs rescue []
  end

  def sidebar_items
    interface.sidebar_items_for(tab_key).reject(&:area_dependent) rescue []
  end

  def slides
    interface.slides_for(tab_key, sidebar_item_key) rescue []
  end

  def constraints
    interface.constraints rescue []
  end
  
  def policy_goals
    interface.allowed_policy_goals rescue []
  end
  
  ##################
  # OutputElement
  ##################

    def default_output_element_for_slide(slide)
      interface.default_chart_for_slide(tab_key, sidebar_item_key, slide.key)
    end

    def default_output_element_for_current_sidebar_item
      interface.default_chart_for_sidebar_item(tab_key, sidebar_item_key) rescue nil
    end

  ##################
  # InputElements
  ##################

    ##
    # @param [Slide] slide
    # @return [Array<InputElement>]
    #
    def input_elements_for(slide)
      @input_elements_for_slide ||= {}
      @input_elements_for_slide[slide.id] ||= 
        interface.input_elements_for(tab_key, sidebar_item_key, slide.key).
          compact.reject(&:area_dependent)
    end

    ##
    # Gets the input elements without a interface group for a slide
    #
    # @param [Slide] slide
    # @return [Array<InputElement>]
    #
    def ungrouped_input_elements_for(slide)
      input_elements_for(slide).select{|i| i.interface_group.blank? }
    end

    ##
    # Gets a interface groups hash with an array of input elements.
    #
    # @return [Hash] interface_group => [InputElement]
    #
    def interface_groups_with_input_elements_for(slide)
      interface_groups = {}
      input_elements = input_elements_for(slide).reject{|i| i.interface_group.blank? }

      input_elements.each do |i|
        interface_groups[i.interface_group] ||= [] 
        interface_groups[i.interface_group] << i
      end

      interface_groups
    end
end