# Given an OutputElement, converts it to a JSON representation which may be
# consumed by the front-end.
class OutputElementPresenter
  # A list of attributes to be included with the JSON. Values may be true, in
  # which case the appropriate method is called on the element, or a block which
  # into which the element will be passed.
  ATTRIBUTES = {
    config: ->(oe) { oe.config || {} },
    group: true,
    growth_chart: true,
    has_description: ->(oe) { oe.has_description? },
    key: true,
    max_axis_value: true,
    min_axis_value: true,
    name: ->(oe) { I18n.t("output_elements.#{oe.key}.title").html_safe },
    percentage: ->(oe) { oe.percentage == true },
    related_id: ->(oe) { oe.related_output_element&.key },
    requires_merit_order: ->(oe) { oe.requires_merit_order },
    show_point_label: true,
    type: ->(oe) { oe.output_element_type.name },
    under_construction: true,
    unit: true
  }.freeze

  # Public: Presents a single element as a JSON-compatible Hash.
  def self.present(element, renderer)
    new(element, renderer).as_json
  end

  # Public: Presents multiple elements in a hash, keyed on their key.
  def self.collection(elements, renderer)
    elements.each_with_object({}) do |element, data|
      data[element.key] = present(element, renderer)
    end
  end

  # Public: Creates a new OutputElementPresenter.
  #
  # element  - The OutputElement
  # renderer - A callable which is compatible with the Rails 'render_to_string'
  #            API. Should return the rendered template for the output element
  #            when called.
  #
  # For example
  #   OutputElementPresenter.new(element, &method(:render_to_string))
  def initialize(element, renderer)
    @element  = element
    @renderer = renderer
  end

  def as_json(*)
    {
      attributes: json_attributes,
      html: template,
      series: @element.allowed_output_element_series.map(&:json_attributes)
    }
  end

  private

  # Internal: Extracts the presentable attributes from the output element for
  # inclusion with the JSON response.
  #
  # Returns a hash.
  def json_attributes
    ATTRIBUTES.each_with_object({}) do |(key, getter), data|
      data[key] = attribute(key, getter)
    end
  end

  # Internal: Determines the value for a particular output element attribute.
  def attribute(key, value)
    if value.respond_to?(:call)
      value.call(@element)
    else
      @element.public_send(key)
    end
  end

  # Internal: Renders the template for the output element, or nil if the element
  # has no template.
  #
  # Returns a string or nil.
  def template
    return unless @element.template

    @renderer.call(
      partial: @element.template,
      locals: { output_element: @element }
    )
  end
end
