class Round < ActiveRecord::Base

  belongs_to :policy_goal
  def generate_policy_update_params(value)
    {"#{InputElement.where("`update_type` = 'policies' AND `keys` = '#{policy_goal.key}'").first.id}" => value}
  end

  def get_input_element
    InputElement.where("`update_type` = 'policies' AND `keys` = '#{policy_goal.key}'").first
  end

end
