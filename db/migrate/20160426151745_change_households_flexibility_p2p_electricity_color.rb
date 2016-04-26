class ChangeHouseholdsFlexibilityP2pElectricityColor < ActiveRecord::Migration
  def change
    o = OutputElementSerie.find_by_label('households_flexibility_p2p_electricity')
    o.update_attribute('color', '#dd33cc')
  end
end
