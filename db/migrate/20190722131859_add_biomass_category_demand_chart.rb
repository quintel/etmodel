class AddBiomassCategoryDemandChart < ActiveRecord::Migration[5.2]
  COLORS = {
    'bio_fuels' => '#2296F3',
    'chp_heat_and_electricity' => '#FFB300',
    'electricity' => '#E91E63',
    'export' => '#999999',
    'greengas' => '#4BAF50',
    'heat' => '#FF5722',
    'hydrogen' => '#68C3E8',
    'wood' => '#8D6E63'
  }

  def up
    ActiveRecord::Base.transaction do
      type = OutputElementType.create!(name: :category_bar)

      el = OutputElement.create!(
        key: :biomass_demand_by_category,
        group: 'Supply',
        output_element_type: type,
        sub_group: 'biomass',
        unit: 'PJ'
      )

      # Wet Biomass

      create_ouput_series(el, 'bio_fuels_from_wet_biomass', 1)
      create_ouput_series(el, 'chp_heat_and_electricity_from_wet_biomass', 5)
      create_ouput_series(el, 'electricity_from_wet_biomass', 10)
      create_ouput_series(el, 'export_of_wet_biomass', 15)
      create_ouput_series(el, 'greengas_from_wet_biomass', 20)
      create_ouput_series(el, 'heat_from_wet_biomass', 25)
      create_ouput_series(el, 'hydrogen_from_wet_biomass', 30)

      create_potential_series(el, 'max_demand_wet_biomass', 35, 1)
      create_potential_series(el, 'max_demand_wet_biomass', 40, 2)

      # Dry Biomass

      create_ouput_series(el, 'chp_heat_and_electricity_from_dry_biomass', 101)
      create_ouput_series(el, 'electricity_from_dry_biomass', 105)
      create_ouput_series(el, 'export_of_dry_biomass', 110)
      create_ouput_series(el, 'greengas_from_dry_biomass', 115)
      create_ouput_series(el, 'heat_from_dry_biomass', 120)
      create_ouput_series(el, 'hydrogen_from_dry_biomass', 125)
      create_ouput_series(el, 'wood_from_dry_biomass', 130)

      create_potential_series(el, 'max_demand_dry_biomass', 135, 1)
      create_potential_series(el, 'max_demand_dry_biomass', 140, 2)

      # Oily Biomass

      create_ouput_series(el, 'bio_fuels_from_oily_biomass', 201)
      create_ouput_series(el, 'export_of_oily_biomass', 205)

      create_potential_series(el, 'max_demand_oily_biomass', 210, 1)
      create_potential_series(el, 'max_demand_oily_biomass', 215, 2)

      # Biogenic Waste

      create_ouput_series(el, 'chp_heat_and_electricity_from_biogenic_waste', 301)
      create_ouput_series(el, 'electricity_from_biogenic_waste', 305)
      create_ouput_series(el, 'export_of_biogenic_waste', 310)
      create_ouput_series(el, 'heat_from_biogenic_waste', 315)

      create_potential_series(el, 'max_demand_biogenic_waste', 320, 1)
      create_potential_series(el, 'max_demand_biogenic_waste', 325, 2)
    end
  end

  def down
    ActiveRecord::Base.transaction do
      OutputElement.find_by_key(:biomass_demand_by_category).destroy!
      OutputElementType.find_by_name(:category_bar).destroy!
    end
  end

  private

  def create_ouput_series(element, gquery, order_by)
    element.output_element_series.create!(output_series_attrs(gquery, order_by))
  end

  def create_potential_series(element, gquery, order_by, tl_position)
    element.output_element_series.create!(
      output_series_attrs(gquery, order_by).merge(
        color: '#AB47BCCC',
        is_target_line: true,
        label: 'biomass_potential',
        target_line_position: tl_position
      )
    )
  end

  def carrier_from_query(gquery)
    gquery.split(/_(?:from|of)_/)[0]
  end

  def source_from_query(gquery)
    if gquery.start_with?('max_demand_')
      gquery[11..-1].sub(/_biomass$/, '')
    else
      gquery.split(/_(?:from|of)_/)[1].sub(/_biomass$/, '')
    end
  end

  def output_series_attrs(gquery, order_by)
    {
      color: COLORS[carrier_from_query(gquery)],
      gquery: gquery,
      group: source_from_query(gquery),
      label: carrier_from_query(gquery),
      order_by: order_by
    }
  end
end
