# == Schema Information
#
# Table name: area_dependencies
#
#  id              :integer(4)      not null, primary key
#  dependent_on    :string(255)
#  description     :text
#  dependable_id   :integer(4)
#  dependable_type :string(255)
#

class AreaDependency < ActiveRecord::Base
  belongs_to :dependendable, :polymorphic => true
end

