# == Schema Information
#
# Table name: rounds
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  active         :boolean(1)
#  position       :integer(4)
#  value          :integer(4)
#  policy_goal_id :integer(4)
#  completed      :boolean(1)
#  created_at     :datetime
#  updated_at     :datetime
#

class Round < ActiveRecord::Base

  belongs_to :policy_goal
  def generate_policy_update_params(value)
    {"#{InputElement.where("`update_type` = 'policies' AND `keys` = '#{policy_goal.key}'").first.id}" => value}
  end

  def get_input_element
    InputElement.where("`update_type` = 'policies' AND `keys` = '#{policy_goal.key}'").first
  end

end
