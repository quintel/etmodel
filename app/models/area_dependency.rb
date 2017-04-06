# == Schema Information
#
# Table name: area_dependencies
#
#  id              :integer          not null, primary key
#  dependent_on    :string(255)
#  description     :text
#  dependable_id   :integer
#  dependable_type :string(255)
#

class AreaDependency < ActiveRecord::Base
  belongs_to :dependable, polymorphic: true
end
