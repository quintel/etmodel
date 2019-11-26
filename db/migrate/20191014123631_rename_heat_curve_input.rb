class RenameHeatCurveInput < ActiveRecord::Migration[5.2]
  def up
    input = InputElement.find_by_key('settings_heat_curve_set')

    input.key = 'settings_weather_curve_set'
    input.unit = 'radio'

    input.save!
  end

  def down
    input = InputElement.find_by_key('settings_weather_curve_set')

    input.key = 'settings_heat_curve_set'
    input.unit = 'boolean'

    input.save!
  end
end
