# frozen_string_literal: true

# == Schema Information
#
# Table name: output_element_presets
#
#  key                        String
#  output_elements            Array[String]
#  dependent_on               String
#

# Entity used for filling charts
class OutputElementPreset < YModel::Base
  include AreaDependent::YModel

  index_on :key
  source_file 'config/interface/output_element_presets.yml'

  default_attribute :output_elements, with: -> { [] }

  def title
    I18n.t("output_element_presets.#{key}.title")
  end

  def self.whitelisted
    all.reject(&:not_allowed_in_this_area)
  end

  def self.for_list
    whitelisted.sort_by(&:title)
  end

  def output_elements_for_js
    output_elements.map { |el_key| "#{el_key}-C" }
  end
end
