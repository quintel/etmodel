# Presents a simplfied version of a slide and its sliders as JSON.
class SlidePresenter
  # Public: Presents a single Slide as a JSON-compatible Hash.
  def self.present(slide)
    new(slide).as_json
  end

  # Public: Presents multiple Slides as an array.
  def self.collection(slides)
    # Sort by tab > sidebar_item > slide
    slides = slides.sort_by do |slide|
      [ slide.sidebar_item.tab.position,
        slide.sidebar_item.position,
        slide.position ]
    end

    slides.map { |slide| present(slide) }
  end

  def initialize(slide)
    @slide = slide
  end

  def as_json(*)
    { path: path, input_elements: inputs }
  end

  private

  def path
    [ translate_item(:tabs, @slide.sidebar_item.tab),
      translate_item(:sidebar_items, @slide.sidebar_item),
      translate_item(:slides, @slide) ]
  end

  def inputs
    # Sort in Ruby to avoid N+1 query.
    @slide.sliders.sort_by(&:position).map do |ie|
      ie.as_json(only: %i[key unit]).merge(
        name: translate_item(:input_elements, ie)
      )
    end
  end

  # Internal: Simplfies translations of input element, slide, sidebar
  # item, and tab names.
  #
  # Returns the name of the item. If the translation contains both a long
  # and short name, the short version is returned.
  def translate_item(namespace, item)
    name = I18n.t("#{ namespace }.#{ item.key }")
    name.is_a?(Hash) ? name[:short_name] : name
  end
end
