class ColorOutputElementSeriesForHourlySupplyMerit < ActiveRecord::Migration
  def change
    colors = ["#bbdd77", "#aa77dd", "#b277dd", "#bb77dd", "#c377dd", "#cc77dd", "#d477dd", "#dd77dd", "#dd77d4", "#dd77cc", "#dd77c3", "#dd77bb", "#dd77b2", "#dd77aa", "#dd77a1", "#dd7799", "#dd7790", "#dd7788", "#dd777f", "#dd7777", "#dd7f77", "#dd8877", "#dd9077", "#dd9977", "#dda177", "#ddaa77", "#ddb277", "#ddbb77", "#ddc377", "#ddcc77", "#ddd477", "#dddd77", "#d4dd77", "#ccdd77", "#c3dd77", "#bbdd77", "#b2dd77", "#aadd77", "#a1dd77", "#99dd77", "#90dd77", "#88dd77", "#7fdd77", "#77dd77", "#77dd7f", "#77dd88", "#77dd90", "#77dd99", "#77dda1", "#77ddaa", "#77ddb2", "#77ddbb", "#77ddc3", "#77ddcc", "#77ddd4", "#77dddd", "#77d4dd", "#77ccdd", "#77c3dd", "#77bbdd", "#77b2dd", "#77aadd", "#77a1dd", "#7799dd", "#7790dd", "#7788dd", "#777fdd", "#7777dd", "#7f77dd", "#8877dd"]

    oe = OutputElement.find_by_key('merit_order_hourly_supply')
    oe.update_attribute('unit', 'MW')

    oe.output_element_series.each_with_index do |serie, index|
      serie.update_attribute('color', colors[index])
    end
  end
end
