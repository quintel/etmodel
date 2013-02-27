class Interface
  def initialize(tab = 'demand', sidebar = nil, slide = nil)
    @tab = tab
    @sidebar = sidebar
    @slide = slide
  end

  # Returns the available tabs (AR object)
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
      (sidebar_items.find{|s| s.key == @sidebar} || sidebar_items.first)
  end

  def slides
    current_sidebar_item.slides.includes(:description).ordered
  end

  def current_slide
    @current_slide ||=
      (current_sidebar_item.slides.find{|s| s.short_name == @slide} || slides.ordered.first)
  end

  def default_chart
    current_slide.output_element
  end

  def targets
    @targets ||= Target.includes(:area_dependency).reject(&:area_dependent)
  end

  def current_tutorial_movie
    current_sidebar_item.send "#{I18n.locale}_vimeo_id"
  end

  def tutorial_movie_path
    Rails.application.routes.url_helpers.tutorial_path tab: current_tab.key,
      sidebar: current_sidebar_item.key
  end

  def tab_info_path
    Rails.application.routes.url_helpers.tab_info_path ctrl: current_tab.key,
      act: current_sidebar_item.key
  end
end
