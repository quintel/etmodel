class UpdateAreasOfEuDatasets < ActiveRecord::Migration[6.0]
  RENAME = {
    be: :BE_belgium,
    es: :ES_spain,
    fr: :FR_france,
    pl: :PL_poland,
    uk: :UK_united_kingdom
  }.freeze

  def up
    RENAME.each do |old_name, new_name|
      say_with_time "#{old_name} -> #{new_name}" do
        SavedScenario.where(area_code: old_name).update_all(area_code: new_name)
      end
    end
  end

  def down
    RENAME.each do |old_name, new_name|
      say_with_time "#{new_name} -> #{old_name}" do
        SavedScenario.where(area_code: new_name).update_all(area_code: old_name)
      end
    end
  end
end
