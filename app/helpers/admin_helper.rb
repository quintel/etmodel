module AdminHelper
  def color_options(selected)
    base = Colors::COLORS.values.include?(selected) ? [] : ([[selected] * 2])
    Colors::COLORS.to_a + base
  end

  # Creates the list of area dependency options which may be used in a form in
  # the admin section.
  #
  # If the area dependency is for an invalid attribute, the option will be shown
  # with a suitable warning.
  #
  # Returns an array.
  def area_dependency_options(model)
    base_options     = Engine::Area::DEPENDABLE_ATTRIBUTES
    model_dependency = model.area_dependency&.dependent_on.presence

    if model_dependency && !base_options.include?(model_dependency.to_sym)
      base_options.map { |v| [v, v] } + [
        [
          "#{model_dependency} - unsupported attribute, will always be hidden",
          model_dependency
        ]
      ]
    else
      base_options
    end
  end
end
