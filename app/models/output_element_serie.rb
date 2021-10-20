# frozen_string_literal: true

# == Schema Information
#
# Table name: output_element_series
#
#  key                  :integer
#  output_element_key   :integer
#  label                :string(255)
#  color                :string(255)
#  order_by             :integer
#  group                :string(255)
#  show_at_first        :boolean
#  is_target_line       :boolean
#  target_line_position :string(255)
#  gquery               :string(255)
#

# Old tables use the order_by attribute to specify the cell position:
# order_by = column_number * 100 + row_number
# e.g.:
# -------------------
# | 101 | 201 | 301 |
# -------------------
# | 102 | 202 | 302 |
# -------------------
#  ...
#
#
class OutputElementSerie < YModel::Base
  include Colors
  include AreaDependent::YModel

  index_on :key
  source_file 'config/interface/output_element_series'
  belongs_to :output_element
  default_attribute :order_by, with: Float::INFINITY

  class << self
    def contains(search)
      return all if search.blank? || search.empty?

      all.select { |oes| oes.key.include?(search) }
    end

    def gquery_contains(search)
      return all if search.blank? || search.empty?

      all.select { |oes| oes.gquery.include?(search) }
    end
  end

  def title_translated
    I18n.t("output_element_series.labels.#{label}") unless label.blank?
  end

  def group_translated
    I18n.t("output_element_series.groups.#{group}") unless group.blank?
  end

  def short_description
    I18n.t(
      "output_element_series.#{key}.short_description",
      default: ''
    )
  end

  #  Descriptions are optional for output element series
  def description
    I18n.t("output_element_series.#{key}.description", default: '')
  end

  # rubocop:disable Metrics/LineLength
  def json_attributes
    {
      id: key, # needed for block charts
      gquery_key: gquery,
      color: color,
      label: title_translated,
      label_key: label,
      group: group, # used to group series
      group_translated: group_translated, # used to display groups in mekkos's & horizontal_stacked_bar
      is_target_line: is_target_line,
      target_line_position: target_line_position,
      is_1990: is_1990
    }
  end
  # rubocop:enable Metrics/LineLength

  def url_in_etengine
    "#{Settings.gquery_detail_url}#{gquery}"
  end
end
