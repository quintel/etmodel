class AddDrawToMinToInsulationInputs < ActiveRecord::Migration[5.2]
  KEYS = %i[
    buildings_insulation_level
    households_insulation_level_apartments
    households_insulation_level_corner_houses
    households_insulation_level_detached_houses
    households_insulation_level_semi_detached_houses
    households_insulation_level_terraced_houses
  ]

  def change
    inputs = InputElement.where(key: KEYS)

    reversible do |dir|
      dir.up { inputs.update_all(draw_to_min: 0.0 )}
      dir.down { inputs.update_all(draw_to_min: nil) }
    end
  end
end
