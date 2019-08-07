# frozen_string_literal: true

class Interface
  DEFAULT_TAB = 'overview'

  attr_accessor :variant

  # Describes the features which are enabled in the normal ETM interface.
  class StandardVariant
    def charts?
      true
    end

    def results_tip?
      true
    end

    def body_class
      ''
    end
  end

  # Disables a number of features not needed when loading a minimal ETM
  # interface in an iframe.
  class LiteVariant
    def charts?
      false
    end

    def results_tip?
      false
    end

    def body_class
      'liteui'
    end
  end

  def initialize(tab = nil, sidebar = nil, slide = nil, variant = StandardVariant.new)
    @tab = tab || DEFAULT_TAB
    @sidebar = sidebar
    @slide = slide
    @variant = variant
  end

  # Returns the available tabs (AR object)
  def tabs
    @tabs ||= Tab.frontend
  end

  def valid?
    current_tab && current_sidebar_item && current_slide
  end

  def current_tab
    @current_tab ||= (Tab.find_by_key(@tab) || Tab.find_by_key(DEFAULT_TAB))
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
    current_sidebar_item.slides.ordered.includes(:area_dependency).
      includes(:description).reject(&:area_dependent)
  end

  def current_slide
    @current_slide ||=
      (current_sidebar_item.slides.find{|s| s.short_name == @slide} || slides.first)
  end

  def default_chart
    current_slide.output_element
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
