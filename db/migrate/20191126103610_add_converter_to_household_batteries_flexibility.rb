class AddNodeToHouseholdBatteriesFlexibility < ActiveRecord::Migration[5.2]

  def up
    slider.update!(related_node: 'households_flexibility_p2p_electricity')
  end

  def down
    slider.update!(related_node: '')
  end

  private

  def slider
    InputElement.find_by_key('households_flexibility_p2p_electricity_market_penetration')
  end
end
