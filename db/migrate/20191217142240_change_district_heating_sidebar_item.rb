class ChangeDistrictHeatingSidebarItem < ActiveRecord::Migration[5.2]
  OLD_SLIDES = [
    'supply_heat_network_large_scale',
    'supply_heat_combined_heat_power',
    'supply_heat_network_buildings',
    'supply_heat_network_households',
    'supply_heat_network_agriculture'
    ]

  OLD_INPUTS = [
    'buildings_chp_engine_biogas_share',
    'buildings_collective_heatpump_water_water_electricity_share',
    'buildings_collective_geothermal_share',
    'buildings_collective_chp_wood_pellets_share',
    'buildings_collective_burner_network_gas_share',
    'buildings_collective_burner_hydrogen_share',
    'capacity_of_energy_chp_engine_biogas',
    'capacity_of_agriculture_chp_supercritical_wood_pellets',
    'capacity_of_agriculture_chp_engine_network_gas',
    'capacity_of_agriculture_chp_engine_biogas',
    'capacity_of_energy_heater_for_heat_network_wood_pellets',
    'capacity_of_energy_heater_for_heat_network_waste_mix',
    'capacity_of_energy_heater_for_heat_network_oil',
    'capacity_of_energy_heater_for_heat_network_network_gas',
    'capacity_of_energy_heater_for_heat_network_lignite',
    'capacity_of_energy_heater_for_heat_network_geothermal',
    'capacity_of_energy_heater_for_heat_network_coal',
    'households_collective_heatpump_water_water_electricity_share',
    'households_collective_geothermal_share',
    'households_collective_chp_wood_pellets_share',
    'households_collective_chp_network_gas_share',
    'households_collective_chp_biogas_share',
    'households_collective_burner_network_gas_share',
    'households_collective_burner_hydrogen_share'
    ]

  HEAT_INPUTS = {
    'geothermal' => {
      'query' => 'capacity_of_energy_heat_well_geothermal',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 1,
      'description' => {
        'content_nl' => "Aardwarmte dieper dan 500 meter wordt geothermie genoemd. Deze warmte kan gebruikt worden om gebouwen mee te verwarmen. Hoeveel warmte haal jij in je scenario uit geothermie? Let op: geothermieputten schakelen niet makkelijk op en af, maar produceren een constante hoeveelheid warmte. Als je veel geothermie inzet, is seizoensopslag onmisbaar om de productie in de zomer in de winter in te kunnen zetten.",
        'content_en' => "Thermal energy from below 500 meters depth is called geothermal energy. This heat can be used to heat buildings. How much heat in your scenario comes from geothermal heat pumps? Caution: geothermal heat pumps typically produce a (more or less) constant amount of heat year round. If your scenario makes use of a lot of geothermal heat, seasonal storage is crucial to ensure that heat produced in summer can be utilised in winter"
      },
      'options' => {
        'related_converter' => 'energy_heat_well_geothermal',
        'interface_group' => 'non_dispatchable_heat'
      }
    },
    'solar_thermal' => {
      'query' => 'capacity_of_energy_heat_solar_thermal',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 2,
      'description' => {
        'content_nl' => "Bij zonthermie wordt de warmte van de zon omgezet in warm water. Deze warmteproductie is vooral groot in de zomer, terwijl de vraag naar warmte hoog is in de winter. Maak gebruik van seizoensopslag voor een effectieve inzet.",
        'content_en' => "Solar thermal collectors generate heat from the sun and use this to heat water. This heat production is especially high in the summer. Heat demand, on the other hand, peaks in the winter. Use seasonal heat storage for effective deployment."
      },
      'options' => {
        'related_converter' => 'energy_heat_solar_thermal',
        'interface_group' => 'non_dispatchable_heat'
      }
    },
    'biogas' => {
      'query' => 'capacity_of_energy_chp_local_engine_biogas',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 3,
      'description' => {
        'content_nl' => "Een WKK produceert zowel warmte als elektriciteit. Stel hier het vermogen aan biogas-WKKs in dat warmte levert aan warmtenetten.",
        'content_en' => "A CHP produces both heat and electricity. Here you can set the capacity of biogas CHPs that supply heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_chp_local_engine_biogas',
        'interface_group' => 'non_dispatchable_heat'
      }
    },
    'heat_pump' => {
      'query' => 'capacity_of_energy_heat_heatpump_water_water_electricity',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 6,
      'description' => {
        'content_nl' => "Een warmtepomp produceert warmte uit elektriciteit en omgevingswarmte. Stel hier het vermogen aan collectieve warmtepompen in dat warmte levert aan warmtenetten.",
        'content_en' => "A heat pump produces heat with electricity and ambient heat. Specify here the capacity of collective heat pumps that supplies heat for district heating"
      },
      'options' => {
        'related_converter' => 'energy_heat_heatpump_water_water_electricity',
        'interface_group' => 'dispatchable_heat'
      }
    },
    'gas_burner' => {
      'query' => 'capacity_of_energy_heat_burner_network_gas',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 7,
      'description' => {
        'content_nl' => "Een ketel produceert warmte. Stel hier het vermogen aan gasketels in dat warmte levert aan warmtenetten.",
        'content_en' => "A burner produces heat. Specify here the capacity of gas heaters that supplies heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_heat_burner_network_gas',
        'interface_group' => 'dispatchable_heat'
      }
    },
    'hydrogen_burner' => {
      'query' => 'capacity_of_energy_heat_burner_hydrogen',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 8,
      'description' => {
        'content_nl' => "Een ketel produceert warmte. Stel hier het vermogen aan waterstofketels in dat warmte levert aan warmtenetten.",
        'content_en' => "A burner produces heat. Specify here the capacity of hydrogen heaters that supplies heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_heat_burner_hydrogen',
        'interface_group' => 'dispatchable_heat'
      }
    },
    'biomass_burner' => {
      'query' => 'capacity_of_energy_heat_burner_wood_pellets',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 9,
      'description' => {
        'content_nl' => "Een ketel produceert warmte. Stel hier het vermogen aan biomassaketels in dat warmte levert aan warmtenetten.",
        'content_en' => "A burner produces heat. Specify here the capacity of biomass heaters that supplies heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_heat_burner_wood_pellets',
        'interface_group' => 'dispatchable_heat'
      }
    },
    'waste_burner' => {
      'query' => 'capacity_of_energy_heat_burner_waste_mix',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 10,
      'description' => {
        'content_nl' => "Een ketel produceert warmte. Stel hier het vermogen aan afvalverbranders in dat warmte levert aan warmtenetten.",
        'content_en' => "A burner produces heat. Specify here the capacity of waste heaters that supplies heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_heat_burner_waste_mix',
        'interface_group' => 'dispatchable_heat'
      }
    },
    'coal_burner' => {
      'query' => 'capacity_of_energy_heat_burner_coal',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 11,
      'description' => {
        'content_nl' => "Een ketel produceert warmte. Stel hier het vermogen aan kolenketels in dat warmte levert aan warmtenetten.",
        'content_en' => "A burner produces heat. Specify here the capacity of coal heaters that supplies heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_heat_burner_coal',
        'interface_group' => 'dispatchable_heat'
      }
    },
    'oil_burner' => {
      'query' => 'capacity_of_energy_heat_burner_crude_oil',
      'step_value' => 1,
      'unit' => 'MW',
      'position' => 12,
      'description' => {
        'content_nl' => "Een ketel produceert warmte. Stel hier het vermogen aan olieketels in dat warmte levert aan warmtenetten.",
        'content_en' => "A boiler produces heat. Specify here the capacity of oil heaters that supplies heat for district heating."
      },
      'options' => {
        'related_converter' => 'energy_heat_burner_crude_oil',
        'interface_group' => 'dispatchable_heat'
      }
    }
  }

  def up
     ActiveRecord::Base.transaction do
      # Remove old series


      OLD_SLIDES.each do |key|
        Slide.find_by(key: key).destroy!
      end

      OLD_INPUTS.each do |key|
        InputElement.find_by(key: key).destroy!
      end

      heat_sources = Slide.create!(
        'key': 'supply_heat_sources',
        'image': 'house_direct_heating.gif',
        'position': 1,
        'sidebar_item_id': 24,
        'output_element_id': 248,
        'general_sub_header': 'heat output'
        )

      HEAT_INPUTS.each do |key, attrs|
        create_input_element(heat_sources.id, attrs['query'], attrs['step_value'], attrs['unit'], attrs['position'], attrs['description'], attrs['options'])
      end

      residual_heat_input = InputElement.find_by_key(:volume_of_imported_heat)
      residual_heat_input.update_attributes!(slide_id: heat_sources.id, position: 4)

      residual_heat_co2_input = InputElement.find_by_key(:co2_emissions_of_imported_heat)
      residual_heat_co2_input.update_attributes!(slide_id: heat_sources.id, position: 5)

    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_input_element(slide_id, gquery, step_value, unit, position, description, options)
    # create slider
    input = InputElement.create!(input_element_attrs(slide_id, gquery, step_value, unit, position, options: options))
    # create tooltip
    Description.create!(
        describable_id: input.id,
        describable_type: 'InputElement',
        content_en: description['content_en'],
        content_nl: description['content_nl']
        )
  end

  def input_element_attrs(slide_id, gquery, step_value, unit, position, options: {})
    {
      slide_id: slide_id,
      key: gquery,
      step_value: step_value,
      unit: unit,
      position: position,
    }.merge(options)
  end
end
