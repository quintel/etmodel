class RemoveOldNoardeastFryslanMunicipalities < ActiveRecord::Migration[5.2]
  OLD_NAMES = %w[
  	GM0058_dongeradeel
  	GM0079_kollumerland_en_nieuwkruisland
  	GM1722_ferwerderadiel
  ].freeze

  def up
    MultiYearChart.where(area_code: OLD_NAMES).update_all(area_code: "GM1970_noardeast_fryslan")
    SavedScenario.where(area_code: OLD_NAMES).update_all(area_code: "GM1970_noardeast_fryslan")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
