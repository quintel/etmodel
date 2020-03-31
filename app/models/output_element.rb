# frozen_string_literal: true

# == Schema Information
#
# Table name: output_elements
#
#  id                     :integer          not null, primary key
#  output_element_type_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  under_construction     :boolean          default(FALSE)
#  unit                   :string(255)
#  percentage             :boolean
#  group                  :string(255)
#  show_point_label       :boolean
#  growth_chart           :boolean
#  key                    :string(255)
#  max_axis_value         :float
#  min_axis_value         :float
#  hidden                 :boolean          default(FALSE)
#

# Entity used for filling charts
class OutputElement < YModel::Base
  MENU_ORDER = %w[Overview Merit Supply Demand Cost Network Policy FCE].freeze

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

    merit_order
    flexibility
    import_export
  ].freeze

  include AreaDependent::YModel
  include Describable

  has_many :output_element_series #, -> { order(:order_by) }
  belongs_to :output_element_type

  # Charts may link to other charts to provide a user with additional insight.
  belongs_to :related_output_element, class_name: 'OutputElement'

  has_many :relatee_output_elements, class_name: 'OutputElement',
                                     foreign_key: 'related_output_element_id'

  # accepts_nested_attributes_for :description, :area_dependency

  # validates :key, presence: true, uniqueness: true
  delegate :html_table?, to: :output_element_type

  def self.not_hidden
    where(hidden: false)
  end

  def title_for_description
    "output_elements.#{key}"
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

  def sankey?
    type == 'sankey'
  end

  # TODO: fix this code with predicate naming.
  # rubocop:disable Naming/PredicateName
  # some charts don't have their series defined in the database. This method
  # makes view code simpler
  #
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
        elements = elements.group_by(&:sub_group)
      end

      [group, elements]
    end]
  end

  def self.whitelisted
    not_hidden.reject(&:area_dependent)
      .reject(&:block_chart?)
      .reject(&:not_allowed_in_this_area)
      .sort_by do |c|
        [
          MENU_ORDER.index(c.group) || Float::INFINITY,
          SUB_GROUP_ORDER.index(c.sub_group) || Float::INFINITY
        ]
      end
  end

  def allowed_output_element_series
    output_element_series.reject(&:area_dependent)
  end

  # returns the type of chart (bezier, html_table, ...)
  def type
    output_element_type.try(:name)
  end

  # Icon shown on the select chart popup
  def icon
    d3_chart? && !sankey? ? "#{key}.png" : "#{type}.png"
  end

  # Some charts require custom HTML. This method returns the appropriate
  # template
  def template
    return nil if jqplot_based? || d3_chart?

    if html_table?
      "output_elements/tables/#{key}"
    else
      'output_elements/block_chart'
    end
  end

  def slides
    Slide.where(output_element_id: id)
  end
end
