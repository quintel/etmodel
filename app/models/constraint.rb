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
  has_and_belongs_to_many :root_nodes
  
  scope :ordered, order('id')
end