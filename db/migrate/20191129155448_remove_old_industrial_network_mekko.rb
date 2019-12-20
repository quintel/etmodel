class RemoveOldIndustrialNetworkMekko < ActiveRecord::Migration[5.2]

  def up
    OutputElement.find_by_key(:mekko_industrial_heat_network).destroy!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
