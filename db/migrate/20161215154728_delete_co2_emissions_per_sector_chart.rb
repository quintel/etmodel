class DeleteCo2EmissionsPerSectorChart < ActiveRecord::Migration
  def up
    OutputElement.find_by_key(:co2_emissions_per_sector).destroy!
  end

  def down
    raise NotImplementedError
  end
end
