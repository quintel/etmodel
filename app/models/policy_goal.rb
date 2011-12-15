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

  has_one :area_dependency, :as => :dependable, :dependent => :destroy
  has_paper_trail
  
  accepts_nested_attributes_for :area_dependency

  scope :gquery_contains, lambda{|search| where([
    "query LIKE :q OR reached_query LIKE :q OR target_query LIKE :q OR user_value_query LIKE :q",
    {:q => "%#{search}%"}]
  )}
end
