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
#

class OutputElement < ActiveRecord::Base
  BLOCK_CHART_ID = 32

  include AreaDependent

  has_paper_trail

  has_many :output_element_series, :order => "order_by"
  belongs_to :output_element_type
  has_one :description, :as => :describable
  has_one :area_dependency, :as => :dependable

  scope :for_update, includes([:output_element_series, :output_element_type])


  delegate :html_table?, :to => :output_element_type
  
  define_index do
    indexes name
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
  end

  def self.find_selected_or_default(selected_id, default_id)
    id = selected_id.present? ? selected_id : default_id
    OutputElement.for_update.find(id)
  end

  def title_for_description
    "output.#{name}"
  end

  def call_jqplot_function
    "alert('call_jqplot_function is deprecated')"  #"Initialize#{output_element_type.name.camelcase}(\"output_element_#{id}\",#{options.map(&:to_json).join(',')});".html_safe
  end

  def block_chart?
    id == BLOCK_CHART_ID
  end

  def options_for_js
    { 
      'id' => self.id,
      'type' => output_element_type.name,
      'percentage' => percentage == true ,
      'unit' => unit,
      'group' => group
    }
  end

  def options
    unless @options
      @options = call_method("series")
      # raise @options.inspect
      @options << call_method("axis_values")
      @options << call_method("colors")
      @options << call_method("labels")
      #CHANGED: moved unit into serie method (its now dependent on the size of the series)
      @options << number_of_ticks if output_element_type.name == "waterfall"
    end
    @options
  end
    
  def under_construction(opts = {})
    return true if opts[:country] == "de" && opts[:id] == "buildings"
    return true if self[:under_construction]
    return false
  end

  def call_method(method_name)
    specfic_method_name = "#{method_name}_#{output_element_type.name}"
    if respond_to? specfic_method_name
      send specfic_method_name
    else
      send method_name
    end
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



