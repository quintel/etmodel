class RemoveBezier110And119 < ActiveRecord::Migration[5.2]

  def up
    OutputElement.find_by_key(:source_of_district_heating_in_households).destroy!
    OutputElement.find_by_key(:source_of_district_heating_in_buildings).destroy!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
