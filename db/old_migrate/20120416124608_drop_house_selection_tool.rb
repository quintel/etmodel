class DropHouseSelectionTool < ActiveRecord::Migration
  def up
    remove_column :slides, :house_selection
  end

  def down
    add_column :slides, :house_selection, :integer
    # demand_households_{insulation|heating|decentral_electricity|hot_water|cooling}
  end
end
