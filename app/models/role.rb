# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Describes the role and responsibilities of a user.
class Role < ActiveRecord::Base
  has_many :users
end

