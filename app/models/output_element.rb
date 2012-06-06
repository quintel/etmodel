# == Schema Information
#
# Table name: output_elements
#
#  id                     :integer(4)      not null, primary key
#  output_element_type_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  under_construction     :boolean(1)      default(FALSE)
#  unit                   :string(255)
#  percentage             :boolean(1)
#  group                  :string(255)
#  show_point_label       :boolean(1)
#  growth_chart           :boolean(1)
#  key                    :string(255)
#  max_axis_value         :float
#  min_axis_value         :float
#  hidden                 :boolean(1)      default(FALSE)
#

class OutputElement < ActiveRecord::Base
  include AreaDependent

  has_paper_trail

  has_many :output_element_series, :order => "order_by", :dependent => :destroy
  belongs_to :output_element_type
  has_one :description, :as => :describable, :dependent => :destroy
  has_one :area_dependency, :as => :dependable, :dependent => :destroy

  accepts_nested_attributes_for :description, :area_dependency

  validates :key, :presence => true, :uniqueness => true
  delegate :html_table?, :to => :output_element_type

  scope :not_hidden, where(:hidden => false)

  define_index do
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
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
    type == 'd3'
  end

  def jqplot_based?
    !block_chart? && !html_table? && !d3_chart?
  end

  # some charts don't have their series defined in the database. This method
  # makes view code simpler
  #
  def has_series_in_db?
    !(html_table? || d3_chart?)
  end

  def options_for_js
    {
      :id                 => id,
      :type               => output_element_type.name,
      :percentage         => percentage == true,
      :unit               => unit,
      :group              => group,
      :name               => I18n.t("output_elements.#{key}").html_safe,
      :show_point_label   => show_point_label,
      :max_axis_value     => max_axis_value,
      :min_axis_value     => min_axis_value,
      :growth_chart       => growth_chart,
      :key                => key,
      :under_construction => under_construction
    }
  end

  def self.select_by_group(group)
    where("`group` = '#{group}'").reject(&:area_dependent)
  end

  def allowed_output_element_series
    output_element_series.includes(:area_dependency).reject(&:area_dependent)
  end

  # returns the type of chart (bezier, html_table, ...)
  def type
    output_element_type.try(:name)
  end

  # Icon shown on the select chart popup
  def icon
    if d3_chart?
      "#{key}.png"
    else
      "#{type}.png"
    end
  end

  # Some charts require custom HTML. This method returns the appropriate
  # template
  def template
    return nil if jqplot_based? || d3_chart?
    template = if html_table?
      "output_elements/tables/chart_#{id}"
    else
      "output_elements/block_chart"
    end
  end
end
