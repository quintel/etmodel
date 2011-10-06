# == Schema Information
#
# Table name: constraints
#
#  id             :integer(4)      not null, primary key
#  key            :string(255)
#  name           :string(255)
#  extended_title :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  gquery_key     :string(255)
#

class Constraint < ActiveRecord::Base
  has_paper_trail

  has_one :description, :as => :describable, :dependent => :destroy

  accepts_nested_attributes_for :description

  scope :ordered, order('id')
  scope :gquery_contains, lambda{|search| where("`gquery_key` LIKE ?", "%#{search}%")}
end
