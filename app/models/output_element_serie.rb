# == Schema Information
#
# Table name: output_element_series
#
#  id                   :integer(4)      not null, primary key
#  output_element_id    :integer(4)
#  label                :string(255)
#  color                :string(255)
#  order_by             :integer(4)
#  group                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  show_at_first        :boolean(1)
#  is_target_line       :boolean(1)
#  target_line_position :string(255)
#  gquery               :string(255)     not null
#


## For html_table output_element:
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
class OutputElementSerie < ActiveRecord::Base
  include Colors
  include AreaDependent

  has_paper_trail

  belongs_to :output_element
  has_one :description, :as => :describable
  has_one :area_dependency, :as => :dependable

  scope :gquery_contains, lambda {|q| where("gquery LIKE ?", "%#{q}%")}
  scope :ordered_for_admin, order("output_elements.`key`").includes('output_element')
  # Hmmm ugly
  scope :block_charts, where(:output_element_id => OutputElementType::BLOCK_CHART_ID)

  scope :contains, lambda{|search| where("`key` LIKE ?", "%#{search}%")}

  validates :gquery, :presence => true

  accepts_nested_attributes_for :description, :reject_if => :all_blank
  accepts_nested_attributes_for :area_dependency, :reject_if => :all_blank

  # delegate :name, :to => :output_element, :prefix => 'output_element', :allow_nil => true

  def title_for_description
    "output_element_series.#{label}" unless label.blank?
  end

  def title_translated
    I18n.t("output_element_series.#{label}") unless label.blank?
  end

  def group_translated
    I18n.t("output_element_series.groups.#{group}") unless group.blank?
  end

  # Attributes used by the js application
  def options_for_js
    {
      :id => id, # needed for block charts
      :gquery_key => gquery,
      :color => color,
      :label => title_translated,
      :group => group, #used to group series
      :group_translated => group_translated, # used to display groups in mekkos's & horizontal_stacked_bar
      :is_target_line => is_target_line,
      :target_line_position => target_line_position
    }
  end

  def url_in_etengine
    "#{APP_CONFIG[:gquery_detail_url]}#{gquery}"
  end
end
