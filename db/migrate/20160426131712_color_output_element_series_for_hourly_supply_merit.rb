class ColorOutputElementSeriesForHourlySupplyMerit < ActiveRecord::Migration
  def change
    colors = [
      "#DC1912",
      "#771108",
      "#AA2D02",
      "#EE9F6E",
      "#F76814",
      "#F27D3A",
      "#F0904C",
      "#CE7013",
      "#CE8814",
      "#FFDEAC",
      "#4A3609",
      "#EDB406",
      "#896F0F",
      "#D7B00F",
      "#9B9303",
      "#FBE875",
      "#D7E91D",
      "#566D0B",
      "#3D6B0D",
      "#94F95C",
      "#08A549",
      "#398E4A",
      "#D0F2B4",
      "#065530",
      "#75EEA3",
      "#2ACD99",
      "#C2FFD1",
      "#0B7E6D",
      "#3BFAEB",
      "#DFFBE5",
      "#131D1C",
      "#00A7B4",
      "#407A8E",
      "#C6E0E9",
      "#9DD5FA",
      "#295888",
      "#A3BFF6",
      "#629DF9",
      "#4E60D1",
      "#201A39",
      "#2F2661",
      "#B895F6",
      "#9977EE",
      "#AF63F1",
      "#8643A9",
      "#953ABC",
      "#431B51",
      "#D54CF7",
      "#F364F0",
      "#FDC2D8",
      "#772467",
      "#D92EBF",
      "#A72E77",
      "#FA66A9",
      "#CF2886",
      "#EDC2B7",
      "#F12A72",
      "#F64571",
      "#A41C35",
      "#390905"
    ]

    oe = OutputElement.find_by_key('merit_order_hourly_supply')
    oe.update_attribute('unit', 'MW')

    oe.output_element_series.each_with_index do |serie, index|
      serie.update_attribute('color', colors[index])
    end

    serie = oe.output_element_series.find_by_label('total_demand')
    serie.update_attribute('color', '#CC0000')
  end
end
