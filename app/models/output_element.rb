# == Schema Information
#
# Table name: output_elements
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  output_element_type_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  under_construction     :boolean(1)      default(FALSE)
#  legend_columns         :integer(4)
#  legend_location        :string(255)
#  unit                   :string(255)
#  percentage             :boolean(1)
#  group                  :string(255)
#  show_point_label       :boolean(1)
#  growth_chart           :boolean(1)
#  key                    :string(255)
#  max_axis_value         :float
#  min_axis_value         :float
#

class OutputElement < ActiveRecord::Base
  BLOCK_CHART_ID = 32

  include AreaDependent

  has_paper_trail

  has_many :output_element_series, :order => "order_by", :dependent => :destroy
  belongs_to :output_element_type
  has_one :description, :as => :describable, :dependent => :destroy
  has_one :area_dependency, :as => :dependable

  validates :key, :presence => true, :uniqueness => true

  delegate :html_table?, :to => :output_element_type
  
  accepts_nested_attributes_for :description
  
  define_index do
    indexes name
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
  end

  def title_for_description
    "output.#{name}"
  end

  def block_chart?
    id == BLOCK_CHART_ID
  end

  def options_for_js
    { 
      'id'         => self.id,
      'type'       => output_element_type.name,
      'percentage' => percentage == true ,
      'unit'       => unit,
      'group'      => group,
      'name'       => I18n.t("output.#{name}").html_safe,
      'show_point_label' => show_point_label,
      'max_axis_value' => max_axis_value,
      'min_axis_value' => min_axis_value,
      'growth_chart' => growth_chart
    }
  end

  # DEBT
  def under_construction(opts = {})
    return true if opts[:country] == "de" && opts[:id] == "buildings"
    return true if self[:under_construction]
    return false
  end

  def self.select_by_group(group)
    where("`group` = '#{group}'").reject(&:area_dependent)
  end

  def allowed_output_element_series
    output_element_series.includes(:area_dependency).reject(&:area_dependent)
  end
  
  def parsed_name_for_admin
    "#{group} | #{name} | #{description.andand.short_content}"
  end
  
  # returns the type of chart (bezier, html_table, ...)
  def type
    output_element_type.try(:name)
  end
end
