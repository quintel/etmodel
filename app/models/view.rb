class View
  def initialize(tab_key, sidebar_item_key)
    @tab_key          = tab_key
    @sidebar_item_key = sidebar_item_key
  end

  def tabs
    Tab.ordered
  end

  def tab
    @tab ||= Tab.find_by_key @tab_key
  end

  def sidebar
    @sidebar ||= SidebarItem.find_by_key @sidebar_item_key
  end

  def slides
    sidebar.slides.ordered
  end

  def default_slide
    slides.first
  end

  def default_chart
    default_slide.output_element
  end

  def sidebar_items
    tab.sidebar_items.reject(&:area_dependent)
  end

  def constraints
    Constraint.default.ordered
  end

  def targets
    Target.all.reject(&:area_dependent)
  end
end
