class SetWeatherCurveInputUnit < ActiveRecord::Migration[5.2]
  def up
    input.update!(unit: 'weather-curves')
  end

  def down
    input.update!(unit: 'radio')
  end

  private

  def input
    InputElement.find_by_key('settings_weather_curve_set')
  end
end
