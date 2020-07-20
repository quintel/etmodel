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

# Polymorphic record which allows some UI components to be hidden depending on the current region.
# Deprecated.
class AreaDependency < ApplicationRecord
  belongs_to :dependable, polymorphic: true
end
