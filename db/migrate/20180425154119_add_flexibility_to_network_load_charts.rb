class AddFlexibilityToNetworkLoadCharts < ActiveRecord::Migration[5.1]
  # [chart key, series query, series label]
  SERIES = [
    [
      :dynamic_demand_curve,
      'merit_other_flexibility_demand',
      'flexibility'
    ],
    [
      :lv_demand_curves,
      'lv_flexibility_load_curve',
      'flexibility'
    ],
    [
      :mv_demand_curves,
      'mv_flexibility_load_curve',
      'flexibility'
    ],
    [
      :hv_demand_curves,
      'hv_flexibility_load_curve',
      'flexibility'
    ]
  ]

  def up
    SERIES.each do |(chart_key, query, label)|
      OutputElement
        .find_by_key!(chart_key)
        .output_element_series
        .create!(
          label: label,
          gquery: query,
          color: '#94F95C'
        )
    end
  end

  def down
    SERIES.each do |(chart_key, query, *)|
      OutputElement
        .find_by_key!(chart_key)
        .output_element_series
        .find_by_gquery!(query)
        .destroy
    end
  end
end
