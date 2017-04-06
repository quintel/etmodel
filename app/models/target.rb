# == Schema Information
#
# Table name: targets
#
#  id             :integer          not null, primary key
#  code           :string(255)
#  query          :string(255)
#  unit           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  display_format :string(255)
#  reached_query  :string(255)
#  target_query   :string(255)
#

class Target < ActiveRecord::Base
  include AreaDependent

  has_one :area_dependency, as: :dependable, dependent: :destroy
  

  accepts_nested_attributes_for :area_dependency

  scope :gquery_contains, ->(search) { where([
    "query LIKE :q OR reached_query LIKE :q OR target_query LIKE :q",
    {q: "%#{search}%"}]
  ) }

  # attributes used by the backbone js object def js_attributes
  def js_attributes
    {
      goal_id: id,
      name: I18n.t("targets.#{code}"),
      success_query: reached_query,
      value_query: query,
      target_query: target_query,
      unit: unit,
      display_fmt: display_format,
      code: code
    }
  end
end
