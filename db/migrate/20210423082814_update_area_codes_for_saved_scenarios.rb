class UpdateAreaCodesForSavedScenarios < ActiveRecord::Migration[6.0]
  RENAME = {
    haven_stad: :RGAMS01_haven_stad,
    PV25_gelderland_plus: :RGGLD01_gelderland_plus,
    hengstdal: :nl
  }.freeze

  REMOVE_SUFFIX = %w[_no_highways _no_steel]

  def up
    # Rename datasets
    RENAME.each do |old_name, new_name|
      say_with_time "#{old_name} -> #{new_name}" do
        SavedScenario.where(area_code: old_name).update_all(area_code: new_name)
      end
    end

    # Remove suffixes
    REMOVE_SUFFIX.each do |suffix|
      say_with_time "removing suffix '#{suffix}'" do
        affected_scenarios(suffix).each do |scenario|
          scenario.area_code = scenario.area_code.delete_suffix(suffix)
          scenario.save(validate: false, touch: false)
        end
      end
    end
  end

  private

  def affected_scenarios(suffix)
    SavedScenario.where('area_code LIKE :suffix', suffix: "%_#{suffix}")
  end
end
