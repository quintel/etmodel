# == Schema Information
#
# Table name: policy_goals
#
#  id               :integer(4)      not null, primary key
#  key              :string(255)
#  query            :string(255)
#  unit             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  display_format   :string(255)
#  reached_query    :string(255)
#  target_query     :string(255)
#  user_value_query :string(255)
#

class PolicyGoal < ActiveRecord::Base
  include AreaDependent
  include GqlHelper

  has_one :area_dependency, :as => :dependable, :dependent => :destroy
  has_paper_trail

  accepts_nested_attributes_for :area_dependency

  scope :gquery_contains, lambda{|search| where([
    "query LIKE :q OR reached_query LIKE :q OR target_query LIKE :q OR user_value_query LIKE :q",
    {:q => "%#{search}%"}]
  )}

  # attributes used by the backbone js object def js_attributes
  def js_attributes
    {
      :goal_id          => id,
      :name             => I18n.t("policy_goals.#{key}"),
      :success_query    => gquery_id(reached_query).to_s,
      :value_query      => gquery_id(query).to_s,
      :target_query     => gquery_id(target_query).to_s,
      :user_value_query => gquery_id(user_value_query).to_s,
      :unit             => unit,
      :display_fmt      => display_format,
      :key              => key
    }
  end
end
