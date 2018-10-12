# frozen_string_literal: true

module OutputElementsHelper
  # Public: Sorts an array of output elements in alphabetical order using their
  # translated names.
  #
  # Returns an array.
  def i18n_sorted_output_elements(elements)
    elements.sort_by { |el| t("output_elements.#{el.key}").downcase }
  end
end
