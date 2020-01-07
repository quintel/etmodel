class RemoveP2hSlideAndSlider < ActiveRecord::Migration[5.2]
  def up
      ActiveRecord::Base.transaction do
        InputElement.find_by_key('households_flexibility_p2h_electricity_market_penetration').destroy!
        Slide.find_by_key('flexibility_flexibility_power_to_heat').destroy!
    end
  end

  def down
      raise ActiveRecord::IrreversibleMigration
  end
end
