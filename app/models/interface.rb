class Interface
  def initialize(tab = 'demand', sidebar = 'households')
    @tab = tab
    @sidebar = sidebar
  end

  def tabs
    @tabs ||= Tab.ordered
  end

  def current_tab
    @current_tab ||= Tab.find_by_key @tab
  end

  def sidebar_items
    @sidebar_items ||= current_tab.sidebar_items.ordered
      .includes(:area_dependency).reject(&:area_dependent)
  end

  def current_sidebar_item
    @current_sidebar_item ||=
      (SidebarItem.find_by_key(@sidebar) || sidebar_items.first)
  end

  def slides
    current_sidebar_item.slides.includes(:description).ordered
  end

  def current_slide
    @current_slide ||= slides.first
  end

  def default_chart
    current_slide.output_element
  end

  def targets
    @targets ||= Target.includes(:area_dependency).reject(&:area_dependent)
  end
end