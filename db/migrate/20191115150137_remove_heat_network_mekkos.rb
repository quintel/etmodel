class RemoveHeatNetworkMekkos < ActiveRecord::Migration[5.2]
  def up
    OutputElement.find_by_key(:mekko_agricultural_heat_network).destroy!
    OutputElement.find_by_key(:mekko_overview_of_all_heat_networks).destroy!
    OutputElement.find_by_key(:mekko_of_heat_network).destroy!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
