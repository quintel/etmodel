# frozen_string_literal: true

# == Schema Information
#
# Table name: output_elements
#
#  key                        :string(255),     primary key
#  output_element_type_name   :string
#  related_output_element_key :string
#  under_construction         :boolean          default(FALSE)
#  unit                       :string(255)
#  percentage                 :boolean
#  group                      :string(255)
#  show_point_label           :boolean
#  growth_chart               :boolean
#  max_axis_value             :float
#  min_axis_value             :float
#  hidden                     :boolean          default(FALSE)
#

# Entity used for filling charts
class OutputElement < YModel::Base
  MENU_ORDER = %w[Overview import_export Flexibility Supply Demand Cost Network ccus emissions].freeze

  SUB_GROUP_ORDER = %w[
    overview
    households
    buildings
    transport
    industry
    agriculture
    other

    electricity
    network_gas
    collective_heat
    hydrogen
    transport_fuels
    biomass
    production_curves_and_import

  ].freeze

  include AreaDependent::YModel

  index_on :key
  source_file 'config/interface/output_elements'

  default_attribute :max_axis_value, with: nil
  default_attribute :fixed, with: false
  default_attribute :show_point_label, with: false
  default_attribute :requires_merit_order, with: false
  default_attribute :under_construction, with: false
  default_attribute :growth_chart, with: false
  default_attribute :config, with: -> { {} }

  has_many :output_element_series
  belongs_to :output_element_type
  has_many :slides
  has_many :dashboard_items

  # Charts may link to other charts to provide a user with additional insight.
  belongs_to :related_output_element, class_name: 'OutputElement'
  has_many :relatee_output_elements, class_name: 'OutputElement',
                                     foreign_key: 'related_output_element_key'

  delegate :html_table?, to: :output_element_type

  def self.not_hidden
    where(hidden: false)
  end

  def title_for_description
    "output_elements.#{key}.title"
  end

  # Descriptions are optional for output elements
  def description
    I18n.t("output_elements.#{key}.description", default: '')
  end

  def description_embeds_player?
    description&.include?('player') ||
      description&.include?('object')
  end

  def block_chart?
    type == 'block'
  end

  # some charts need custom html. Others (jqplot and d3) just need a container
  # div
  def custom_html?
    block_chart? || html_table?
  end

  def d3_chart?
    %w[d3 sankey].include?(type)
  end

  def jqplot_based?
    !block_chart? && !html_table? && !d3_chart?
  end

  # TODO: fix this code with predicate naming.
  # rubocop:disable Naming/PredicateName
  # some charts don't have their series defined in the database. This method
  # makes view code simpler
  def has_series_in_db?
    !(html_table? || d3_chart?)
  end

  def has_description?
    description.present?
  end

  # rubocop:enable Naming/PredicateName

  def self.select_by_group
    Hash[whitelisted.group_by(&:group).each.map do |group, elements|
      if elements.map(&:sub_group).compact.any?
        elements = elements.group_by { |e| e.sub_group.presence }
      end

      [group, elements]
    end]
  end

  def self.whitelisted
    not_hidden.reject(&:area_dependent)
      .reject(&:not_allowed_in_this_area)
      .sort_by do |c|
        [
          MENU_ORDER.index(c.group) || Float::INFINITY,
          SUB_GROUP_ORDER.index(c.sub_group) || Float::INFINITY
        ]
      end
  end

  def allowed_output_element_series
    output_element_series.sort_by(&:order_by).reject(&:area_dependent)
  end

  # returns the type of chart (bezier, html_table, ...)
  def type
    output_element_type.try(:name)
  end

  # Icon shown on the select chart popup
  def icon
    type == 'd3' ? "#{key}.png" : "#{type}.png"
  end

  # Some charts require custom HTML. This method returns the appropriate
  # template
  def template
    return nil if jqplot_based? || d3_chart?

    return "output_elements/tables/#{key}" if html_table?

    'output_elements/block_chart'
  end
end
