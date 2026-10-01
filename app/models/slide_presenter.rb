# frozen_string_literal: true

# Presents a simplfied version of a slide and its sliders as JSON.
class SlidePresenter
  # Public: Presents a single Slide as a JSON-compatible Hash.
  def self.present(slide)
    new(slide).as_json
  end

  # Public: Presents multiple Slides as an array.
  def self.collection(slides)
    # Sort by tab > sidebar_item > slide
    slides =
      slides.sort_by do |slide|
        [slide.sidebar_item.tab.position,
         SlidePresenter.sidebar_item_position(slide),
         slide.position]
      end

    slides.map { |slide| present(slide) }
  end

  def initialize(slide)
    @slide = slide
  end

  def as_json(*)
    { path: path, display_unit: slide_display_unit, input_elements: inputs }
  end

  private



  def self.sidebar_item_position(slide)
    if parent_item = slide.sidebar_item.parent_key
      SidebarItem.find_by_key(parent_item).position +
        slide.sidebar_item.position / 10.0
    else
      slide.sidebar_item.position
    end
  end

  def path
    [translate_item(:tabs, @slide.sidebar_item.tab),
     *sidebar_item_path,
     translate_item(:slides, @slide)]
  end

  def sidebar_item_path
    [parent_sidebar_item, @slide.sidebar_item]
      .compact
      .map { |item| translate_item(:sidebar_items, item) }
  end

  def parent_sidebar_item
    key = @slide.sidebar_item.parent_key

    key && SidebarItem.find_by_key(key)
  end

  def inputs
    # Sort in Ruby to avoid N+1 query.
    @slide.sliders.sort_by(&:position).map do |ie|
      ie.as_json(only: %w[key unit interface_group]).merge(
        'name' => translate_item(:input_elements, ie),
        'display_unit' => display_unit(ie),
        'group_name' => ie.interface_group.present? ? I18n.t("accordion.#{ie.interface_group}") : nil
      )
    end
  end

  def slide_display_unit
    subheader(@slide.general_sub_header)
  end

  # See scenarios/_slide.html.haml
  def display_unit(input_element)
    return nil if input_element.interface_group.blank?

    subheader(input_element.interface_group) || subheader(@slide.group_sub_header)
  end

  def subheader(name)
    key = name.to_s.parameterize.underscore
    return nil if key.blank?

    value = I18n.t("subheaders.#{key}", default: nil)
    value.is_a?(String) && value.present? ? value : nil
  end

  # Internal: Simplfies translations of input element, slide, sidebar
  # item, and tab names.
  #
  # Returns the name of the item. If the translation contains both a long
  # and short title, the short version is returned.
  def translate_item(namespace, item)
    name = I18n.t("#{namespace}.#{item.key}")
    if name.is_a?(Hash)
      name[:short_title] || name[:title]
    else
      name
    end
  end
end
