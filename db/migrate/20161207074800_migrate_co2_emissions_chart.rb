class MigrateCo2EmissionsChart < ActiveRecord::Migration
  def build_series_from_old(chart, old_series, conditions, changed_attributes = {})
    old_series.
      select { |s| conditions.call(s) }.
      sort_by { |s| s.order_by }.
      each do |old_serie|
        chart.output_element_series.build(
          old_serie.attributes.
            merge(
              order_by:
                (chart.output_element_series.map(&:order_by).max || 0) + 1,
            ).
            merge(changed_attributes)
        )
    end
  end

  def up
    OutputElement.transaction do
      co2_chart = OutputElement.find_by_key(:co2_emissions)
      old_co2_chart_series = co2_chart.output_element_series.map {|s| s.dup}

      old_co2_sector_chart = OutputElement.find_by_key(:co2_emissions_per_sector)
      old_co2_sector_chart_series = old_co2_sector_chart.output_element_series.map {|s| s.dup}

      co2_chart.assign_attributes(
        output_element_type: OutputElementType.find_by_name(:vertical_stacked_bar),
        show_point_label: false)

      co2_chart.output_element_series.clear

      build_series_from_old(
        co2_chart,
        old_co2_sector_chart_series,
        ->(s) { s.label =~ /^groups\./ })

      build_series_from_old(
        co2_chart,
        old_co2_chart_series,
        ->(s) { s.label == 'co2_emission_imported_electricity' },
        {color: '#7149D1'})

      build_series_from_old(
        co2_chart,
        old_co2_chart_series,
        ->(s) { s.label == 'co2_emissions_1990' },
        {is_1990: true})

      build_series_from_old(
        co2_chart,
        old_co2_chart_series,
        ->(s) { s.label == 'target' && s.is_target_line })

      co2_chart.save!


      OutputElementType.find_by_name(:co2_emissions).destroy!
    end
  end

  def down
    raise NotImplementedError
  end
end
