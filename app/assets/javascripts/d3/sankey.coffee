D3.sankey =
  charts:
    sankey_energy_overview:
      data:
        nodes: [
          {id: 'imported_electricity',         column: 0, label: 'imported_electricity',              color: '#1f77b4'},
          {id: 'solar_electricity',            column: 0, label: 'solar_electricity',                 color: '#ffcc00'},
          {id: 'wind_electricity',             column: 0, label: 'wind_electricity',                  color: '#63A1C9'},
          {id: 'hydro_electricity',            column: 0, label: 'hydro_electricity',                 color: '#4465c6'},
          {id: 'uranium',                      column: 0, label: 'uranium',                           color: '#ff7f0e'},
          {id: 'biomass_products',             column: 0, label: 'biomass_products',                  color: '#2ca02c'},
          {id: 'coal_and_coal_products',       column: 0, label: 'coal_and_coal_products',            color: '#252525'},
          {id: 'ambient_heat',                 column: 0, label: 'ambient_heat',                      color: '#ADDE4C'},
          {id: 'geothermal',                   column: 0, label: 'geothermal',                        color: '#FF8400'},
          {id: 'imported_heat',                column: 0, label: 'imported_heat',                     color: '#cc0000'},
          {id: 'residual_heat',                column: 0, label: 'residual_heat',                     color: '#cc0000'},
          {id: 'natural_gas',                  column: 0, label: 'natural_gas',                       color: '#7f7f7f'},
          {id: 'non_biogenic_waste',           column: 0, label: 'non_biogenic_waste',                color: '#BA7D40'},
          {id: 'solar_thermal',                column: 0, label: 'solar_thermal',                     color: '#ffcc00'},
          {id: 'imported_hydrogen',            column: 0, label: 'imported_hydrogen',                 color: '#87cfeb'},
          {id: 'imported_liquid_hydrogen',     column: 0, label: 'imported_liquid_hydrogen',          color: '#87cfeb'},
          {id: 'imported_lohc',                column: 0, label: 'imported_lohc',                     color: '#87cfeb'},
          {id: 'imported_ammonia',             column: 0, label: 'imported_ammonia',                  color: '#1ce6d6'},
          {id: 'extracted_oil',                column: 0, label: 'extracted_oil',                     color: '#8c564b'},
          {id: 'imported_oil',                 column: 0, label: 'imported_oil',                      color: '#8c564b'},
          {id: 'imported_biofuels',            column: 0, label: 'imported_biofuels',                 color: '#2ca02c'},
          {id: 'oil_products',                 column: 0, label: 'oil_products',                      color: '#8c564b'},
          {id: 'imported_methanol',            column: 0, label: 'imported_methanol',                 color: '#FF8C8C'},
          {id: 'not_defined',                  column: 0, label: 'not_defined',                       color: '#DCDCDC'},

          {id: 'electricity',                  column: 1, label: 'electricity',                       color: '#1f77b4'},
          {id: 'heat',                         column: 1, label: 'heat',                              color: '#cc0000'},
          {id: 'hydrogen',                     column: 1, label: 'hydrogen',                          color: '#87cfeb'},
          {id: 'oil_and_oil_products',         column: 1, label: 'oil_and_oil_products',              color: '#8c564b'},
          {id: 'waste_mix',                    column: 1, label: 'waste_mix',                         color: '#CE7013'},
          {id: 'biofuels',                     column: 1, label: 'biofuels',                          color: '#2ca02c'},
          {id: 'methanol',                     column: 1, label: 'methanol',                          color: '#FF8C8C'},
          {id: 'network_gas',                  column: 1, label: 'network_gas',                       color: '#7f7f7f'},
          {id: 'ammonia',                      column: 1, label: 'ammonia',                           color: '#1ce6d6'},

          {id: 'agriculture',                  column: 2, label: 'agriculture',                       color: '#332288'},
          {id: 'households',                   column: 2, label: 'households',                        color: '#117733'},
          {id: 'buildings',                    column: 2, label: 'buildings',                         color: '#44AA99'},
          {id: 'transport',                    column: 2, label: 'transport',                         color: '#88CCEE'},
          {id: 'industry',                     column: 2, label: 'industry',                          color: '#DDCC77'},
          {id: 'energy',                       column: 2, label: 'energy',                            color: '#CC6677'},
          {id: 'other',                        column: 2, label: 'other',                             color: '#AA4499'},
          {id: 'bunkers',                      column: 2, label: 'bunkers',                           color: '#882255'},
          {id: 'feedstock',                    column: 2, label: 'feedstock',                         color: '#013220'},
          {id: 'export',                       column: 2, label: 'export',                            color: '#43464B'},
          {id: 'losses',                       column: 2, label: 'losses',                            color: '#DCDCDC'}
        ]

        links: [

          {left: 'natural_gas',                  right: 'biofuels',                  gquery: 'sankey_0_to_1_natural_gas_to_biofuels',          color: '#7f7f7f'},
          {left: 'not_defined',                  right: 'biofuels',                  gquery: 'sankey_0_to_1_not_defined_to_biofuels',          color: '#DCDCDC'},

          {left: 'hydro_electricity',            right: 'electricity',               gquery: 'sankey_0_to_1_hydro_electricity_to_electricity',         color: '#4465c6'},
          {left: 'imported_electricity',         right: 'electricity',               gquery: 'sankey_0_to_1_imported_electricity_to_electricity',      color: '#1f77b4'},
          {left: 'solar_electricity',            right: 'electricity',               gquery: 'sankey_0_to_1_solar_electricity_to_electricity',         color: '#ffcc00'},
          {left: 'wind_electricity',             right: 'electricity',               gquery: 'sankey_0_to_1_wind_electricity_to_electricity',          color: '#63A1C9'},
          {left: 'uranium',                      right: 'electricity',               gquery: 'sankey_0_to_1_uranium_to_electricity',                   color: '#ff7f0e'},
          {left: 'coal_and_coal_products',       right: 'electricity',               gquery: 'sankey_0_to_1_coal_and_coal_products_to_electricity',    color: '#252525'},
          {left: 'geothermal',                   right: 'electricity',               gquery: 'sankey_0_to_1_geothermal_to_electricity',                color: '#FF8400'},

          {left: 'coal_and_coal_products',       right: 'heat',                      gquery: 'sankey_0_to_1_coal_and_coal_products_to_heat',           color: '#252525'},
          {left: 'solar_thermal',                right: 'heat',                      gquery: 'sankey_0_to_1_solar_thermal_to_heat',                    color: '#ffcc00'},
          {left: 'uranium',                      right: 'heat',                      gquery: 'sankey_0_to_1_uranium_to_heat',                          color: '#ff7f0e'},
          {left: 'ambient_heat',                 right: 'heat',                      gquery: 'sankey_0_to_1_ambient_heat_to_heat',                     color: '#ADDE4C'},
          {left: 'residual_heat',                right: 'heat',                      gquery: 'sankey_0_to_1_residual_heat_to_heat',                    color: '#cc0000'},
          {left: 'imported_heat',                right: 'heat',                      gquery: 'sankey_0_to_1_imported_heat_to_heat',                    color: '#cc0000'},
          {left: 'geothermal',                   right: 'heat',                      gquery: 'sankey_0_to_1_geothermal_to_heat',                       color: '#FF8400'},

          {left: 'natural_gas',                  right: 'hydrogen',                  gquery: 'sankey_0_to_1_natural_gas_to_hydrogen',                  color: '#7f7f7f'},
          {left: 'imported_hydrogen',            right: 'hydrogen',                  gquery: 'sankey_0_to_1_imported_hydrogen_to_hydrogen',            color: '#87cfeb'},
          {left: 'imported_liquid_hydrogen',     right: 'hydrogen',                  gquery: 'sankey_0_to_1_imported_liquid_hydrogen_to_hydrogen',     color: '#87cfeb'},
          {left: 'imported_lohc',                right: 'hydrogen',                  gquery: 'sankey_0_to_1_imported_lohc_to_hydrogen',                color: '#87cfeb'},
          {left: 'not_defined',                  right: 'hydrogen',                  gquery: 'sankey_0_to_1_not_defined_to_hydrogen',                  color: '#DCDCDC'},

          {left: 'extracted_oil',                right: 'oil_and_oil_products',      gquery: 'sankey_0_to_1_crude_oil_to_oil_and_oil_products',                       color: '#8c564b'},
          {left: 'natural_gas',                  right: 'oil_and_oil_products',      gquery: 'sankey_0_to_1_natural_gas_to_oil_and_oil_products',                     color: '#7f7f7f'},
          {left: 'non_biogenic_waste',           right: 'oil_and_oil_products',      gquery: 'sankey_0_to_1_non_biogenic_waste_to_oil_and_oil_products',              color: '#BA7D40'},
          {left: 'imported_oil',                 right: 'oil_and_oil_products',      gquery: 'sankey_0_to_1_imported_oil_and_oil_products_to_oil_and_oil_products',   color: '#8c564b'},
          {left: 'not_defined',                  right: 'oil_and_oil_products',      gquery: 'sankey_0_to_1_not_defined_to_oil_and_oil_products',                      color: '#DCDCDC'},

          {left: 'biomass_products',             right: 'waste_mix',                 gquery: 'sankey_0_to_1_biomass_products_to_waste_mix',            color: '#2ca02c'},
          {left: 'non_biogenic_waste',           right: 'waste_mix',                 gquery: 'sankey_0_to_1_non_biogenic_waste_to_waste_mix',          color: '#BA7D40'},

          {left: 'biomass_products',             right: 'biofuels',                 gquery: 'sankey_0_to_1_biomass_products_to_biofuels',            color: '#2ca02c'},
          {left: 'imported_biofuels',            right: 'biofuels',                 gquery: 'sankey_0_to_1_imported_biofuels_to_biofuels',             color: '#2ca02c'},


          {left: 'imported_methanol',            right: 'methanol',                  gquery: 'sankey_0_to_1_imported_methanol_to_methanol',            color: '#FF8C8C'},
          {left: 'non_biogenic_waste',           right: 'methanol',                  gquery: 'sankey_0_to_1_non_biogenic_waste_to_methanol',           color: '#cc0000'},
          {left: 'natural_gas',                  right: 'methanol',                  gquery: 'sankey_0_to_1_natural_gas_to_methanol',                  color: '#7f7f7f'},
          {left: 'not_defined',                  right: 'methanol',                  gquery: 'sankey_0_to_1_not_defined_to_methanol',                  color: '#DCDCDC'},

          {left: 'natural_gas',                  right: 'network_gas',               gquery: 'sankey_0_to_1_natural_gas_to_network_gas',               color: '#7f7f7f'},

          {left: 'imported_ammonia',             right: 'ammonia',                   gquery: 'sankey_0_to_1_imported_ammonia_to_ammonia',              color: '#1ce6d6'},
          {left: 'natural_gas',                  right: 'ammonia',                   gquery: 'sankey_0_to_1_natural_gas_to_ammonia',                   color: '#7f7f7f'},
          {left: 'not_defined',                  right: 'ammonia',                   gquery: 'sankey_0_to_1_not_defined_to_ammonia',                   color: '#DCDCDC'},

          {left: 'hydrogen',                     right: 'electricity',               gquery: 'sankey_1_to_1_hydrogen_to_electricity',                  color: '#87cfeb'},
          {left: 'oil_and_oil_products',         right: 'electricity',               gquery: 'sankey_1_to_1_oil_and_oil_products_to_electricity',      color: '#8c564b'},
          {left: 'waste_mix',                    right: 'electricity',               gquery: 'sankey_1_to_1_waste_mix_to_electricity',                 color: '#CE7013'},
          {left: 'network_gas',                  right: 'electricity',               gquery: 'sankey_1_to_1_network_gas_to_electricity',               color: '#7f7f7f'},
          {left: 'biofuels',                     right: 'electricity',               gquery: 'sankey_1_to_1_biofuels_to_electricity',                  color: '#2ca02c'},

          {left: 'electricity',                  right: 'heat',                      gquery: 'sankey_1_to_1_electricity_to_heat',                      color: '#1f77b4'},
          {left: 'hydrogen',                     right: 'heat',                      gquery: 'sankey_1_to_1_hydrogen_to_heat',                         color: '#87cfeb'},
          {left: 'oil_and_oil_products',         right: 'heat',                      gquery: 'sankey_1_to_1_oil_and_oil_products_to_heat',             color: '#8c564b'},
          {left: 'waste_mix',                    right: 'heat',                      gquery: 'sankey_1_to_1_waste_mix_to_heat',                        color: '#CE7013'},
          {left: 'network_gas',                  right: 'heat',                      gquery: 'sankey_1_to_1_network_gas_to_heat',                      color: '#7f7f7f'},
          {left: 'biofuels',                     right: 'heat',                      gquery: 'sankey_1_to_1_biofuels_to_heat',                         color: '#2ca02c'},


          {left: 'electricity',                  right: 'hydrogen',                  gquery: 'sankey_1_to_1_electricity_to_hydrogen',                  color: '#1f77b4'},
          {left: 'heat',                         right: 'hydrogen',                  gquery: 'sankey_1_to_1_heat_to_hydrogen',                         color: '#cc0000'},
          {left: 'oil_and_oil_products',         right: 'hydrogen',                  gquery: 'sankey_1_to_1_oil_and_oil_products_to_hydrogen',         color: '#8c564b'},
          {left: 'waste_mix',                    right: 'hydrogen',                  gquery: 'sankey_1_to_1_waste_mix_to_hydrogen',                    color: '#CE7013'},
          {left: 'methanol',                     right: 'hydrogen',                  gquery: 'sankey_1_to_1_methanol_to_hydrogen',                     color: '#FF8C8C'},
          {left: 'ammonia',                      right: 'hydrogen',                  gquery: 'sankey_1_to_1_ammonia_to_hydrogen',                      color: '#1ce6d6'},
          {left: 'network_gas',                  right: 'hydrogen',                  gquery: 'sankey_1_to_1_network_gas_to_hydrogen',                  color: '#7f7f7f'},
          {left: 'biofuels',                     right: 'hydrogen',                  gquery: 'sankey_1_to_1_biofuels_to_hydrogen',                     color: '#2ca02c'},

          {left: 'electricity',                  right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_electricity_to_oil_and_oil_products',      color: '#1f77b4'},
          {left: 'heat',                         right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_heat_to_oil_and_oil_products',             color: '#cc0000'},
          {left: 'hydrogen',                     right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_hydrogen_to_oil_and_oil_products',         color: '#87cfeb'},
          {left: 'waste_mix',                    right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_waste_mix_to_oil_and_oil_products',        color: '#CE7013'},
          {left: 'ammonia',                      right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_ammonia_to_oil_and_oil_products',          color: '#1ce6d6'},
          {left: 'methanol',                     right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_methanol_to_oil_and_oil_products',         color: '#FF8C8C'},
          {left: 'network_gas',                  right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_network_gas_to_oil_and_oil_products',      color: '#7f7f7f'},
          {left: 'biofuels',                     right: 'oil_and_oil_products',      gquery: 'sankey_1_to_1_biofuels_to_oil_and_oil_products',          color: '#2ca02c'},

          {left: 'electricity',                  right: 'methanol',                  gquery: 'sankey_1_to_1_electricity_to_methanol',                  color: '#1f77b4'},
          {left: 'heat',                         right: 'methanol',                  gquery: 'sankey_1_to_1_heat_to_methanol',                         color: '#cc0000'},
          {left: 'hydrogen',                     right: 'methanol',                  gquery: 'sankey_1_to_1_hydrogen_to_methanol',                     color: '#87cfeb'},
          {left: 'oil_and_oil_products',         right: 'methanol',                  gquery: 'sankey_1_to_1_oil_and_oil_products_to_methanol',         color: '#8c564b'},
          {left: 'waste_mix',                    right: 'methanol',                  gquery: 'sankey_1_to_1_waste_mix_to_methanol',                    color: '#CE7013'},
          {left: 'ammonia',                      right: 'methanol',                  gquery: 'sankey_1_to_1_ammonia_to_methanol',                      color: '#1ce6d6'},
          {left: 'network_gas',                  right: 'methanol',                  gquery: 'sankey_1_to_1_network_gas_to_methanol',                  color: '#7f7f7f'},
          {left: 'biofuels',                     right: 'methanol',                  gquery: 'sankey_1_to_1_biofuels_to_methanol',                     color: '#2ca02c'},

          {left: 'electricity',                  right: 'network_gas',               gquery: 'sankey_1_to_1_electricity_to_network_gas',               color: '#1f77b4'},
          {left: 'heat',                         right: 'network_gas',               gquery: 'sankey_1_to_1_heat_to_network_gas',                      color: '#cc0000'},
          {left: 'hydrogen',                     right: 'network_gas',               gquery: 'sankey_1_to_1_hydrogen_to_network_gas',                  color: '#87cfeb'},
          {left: 'oil_and_oil_products',         right: 'network_gas',               gquery: 'sankey_1_to_1_oil_and_oil_products_to_network_gas',      color: '#8c564b'},
          {left: 'waste_mix',                    right: 'network_gas',               gquery: 'sankey_1_to_1_waste_mix_to_network_gas',                 color: '#CE7013'},
          {left: 'methanol',                     right: 'network_gas',               gquery: 'sankey_1_to_1_methanol_to_network_gas',                  color: '#FF8C8C'},
          {left: 'ammonia',                      right: 'network_gas',               gquery: 'sankey_1_to_1_ammonia_to_network_gas',                   color: '#1ce6d6'},
          {left: 'biofuels',                     right: 'network_gas',               gquery: 'sankey_1_to_1_biofuels_to_network_gas',                 color: '#2ca02c'},

          {left: 'electricity',                   right: 'ammonia',                  gquery: 'sankey_1_to_1_electricity_to_ammonia',                   color: '#1f77b4'},
          {left: 'heat',                          right: 'ammonia',                  gquery: 'sankey_1_to_1_heat_to_ammonia',                          color: '#cc0000'},
          {left: 'hydrogen',                      right: 'ammonia',                  gquery: 'sankey_1_to_1_hydrogen_to_ammonia',                      color: '#87cfeb'},
          {left: 'oil_and_oil_products',          right: 'ammonia',                  gquery: 'sankey_1_to_1_oil_and_oil_products_to_ammonia',          color: '#8c564b'},
          {left: 'waste_mix',                     right: 'ammonia',                  gquery: 'sankey_1_to_1_waste_mix_to_ammonia',                     color: '#CE7013'},
          {left: 'methanol',                      right: 'ammonia',                  gquery: 'sankey_1_to_1_methanol_to_ammonia',                      color: '#FF8C8C'},
          {left: 'biofuels',                     right: 'ammonia',                   gquery: 'sankey_1_to_1_biofuels_to_ammonia',                      color: '#FF8C8C'},

          {left: 'electricity',                  right: 'biofuels',                  gquery: 'sankey_1_to_1_electricity_to_biofuels',                  color: '#1f77b4'},
          {left: 'heat',                         right: 'biofuels',                  gquery: 'sankey_1_to_1_heat_to_biofuels',                         color: '#cc0000'},
          {left: 'hydrogen',                     right: 'biofuels',                  gquery: 'sankey_1_to_1_hydrogen_to_biofuels',                     color: '#87cfeb'},
          {left: 'oil_and_oil_products',         right: 'biofuels',                  gquery: 'sankey_1_to_1_oil_and_oil_products_to_biofuels',         color: '#8c564b'},
          {left: 'waste_mix',                    right: 'biofuels',                  gquery: 'sankey_1_to_1_waste_mix_to_biofuels',                    color: '#CE7013'},
          {left: 'methanol',                     right: 'biofuels',                  gquery: 'sankey_1_to_1_methanol_to_biofuels',                     color: '#FF8C8C'},
          {left: 'ammonia',                      right: 'biofuels',                  gquery: 'sankey_1_to_1_ammonia_to_biofuels',                      color: '#1ce6d6'},
          {left: 'network_gas',                  right: 'biofuels',                  gquery: 'sankey_1_to_1_network_gas_to_biofuels',                  color: '#7f7f7f'},


          {left: 'electricity',                  right: 'natural_gas',               gquery: 'sankey_1_to_0_electricity_to_natural_gas',               color: '#1f77b4'},
          {left: 'heat',                         right: 'natural_gas',               gquery: 'sankey_1_to_0_heat_to_natural_gas',                      color: '#cc0000'},
          {left: 'hydrogen',                     right: 'natural_gas',               gquery: 'sankey_1_to_0_hydrogen_to_natural_gas',                  color: '#87cfeb'},
          {left: 'oil_and_oil_products',         right: 'natural_gas',               gquery: 'sankey_1_to_0_oil_and_oil_products_to_natural_gas',      color: '#8c564b'},
          {left: 'waste_mix',                    right: 'natural_gas',               gquery: 'sankey_1_to_0_waste_mix_to_natural_gas',                 color: '#CE7013'},
          {left: 'methanol',                     right: 'natural_gas',               gquery: 'sankey_1_to_0_methanol_to_natural_gas',                  color: '#FF8C8C'},
          {left: 'ammonia',                      right: 'natural_gas',               gquery: 'sankey_1_to_0_ammonia_to_natural_gas',                   color: '#1ce6d6'},

          {left: 'coal_and_coal_products',       right: 'agriculture',               gquery: 'sankey_0_to_2_coal_and_coal_products_to_agriculture',    color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'households',                gquery: 'sankey_0_to_2_coal_and_coal_products_to_households',     color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'buildings',                 gquery: 'sankey_0_to_2_coal_and_coal_products_to_buildings',      color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'transport',                 gquery: 'sankey_0_to_2_coal_and_coal_products_to_transport',      color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'industry',                  gquery: 'sankey_0_to_2_coal_and_coal_products_to_industry',       color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'energy',                    gquery: 'sankey_0_to_2_coal_and_coal_products_to_energy',         color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'other',                     gquery: 'sankey_0_to_2_coal_and_coal_products_to_other',          color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'bunkers',                   gquery: 'sankey_0_to_2_coal_and_coal_products_to_bunkers',        color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'feedstock',                 gquery: 'sankey_0_to_2_coal_and_coal_products_to_feedstock',      color: '#252525'},
          {left: 'coal_and_coal_products',       right: 'export',                    gquery: 'sankey_0_to_2_coal_and_coal_products_to_export',         color: '#252525'},
          #{left: 'coal_and_coal_products',      right: 'losses',                    gquery: 'sankey_0_to_2_coal_and_coal_products_to_loss',           color: '#DCDCDC'},

          {left: 'geothermal',                   right: 'agriculture',               gquery: 'sankey_0_to_2_geothermal_to_agriculture',                color: '#787821'},
          {left: 'geothermal',                   right: 'households',                gquery: 'sankey_0_to_2_geothermal_to_households',                 color: '#787821'},
          {left: 'geothermal',                   right: 'buildings',                 gquery: 'sankey_0_to_2_geothermal_to_buildings',                  color: '#787821'},
          {left: 'geothermal',                   right: 'transport',                 gquery: 'sankey_0_to_2_geothermal_to_transport',                  color: '#787821'},
          {left: 'geothermal',                   right: 'industry',                  gquery: 'sankey_0_to_2_geothermal_to_industry',                   color: '#787821'},
          {left: 'geothermal',                   right: 'energy',                    gquery: 'sankey_0_to_2_geothermal_to_energy',                     color: '#787821'},
          {left: 'geothermal',                   right: 'other',                     gquery: 'sankey_0_to_2_geothermal_to_other',                      color: '#787821'},
          {left: 'geothermal',                   right: 'bunkers',                   gquery: 'sankey_0_to_2_geothermal_to_bunkers',                    color: '#787821'},
          {left: 'geothermal',                   right: 'feedstock',                 gquery: 'sankey_0_to_2_geothermal_to_feedstock',                  color: '#787821'},
          #{left: 'geothermal',                  right: 'export',                    gquery: 'sankey_0_to_2_geothermal_to_export',                     color: '#787821'},

          {left: 'natural_gas',                  right: 'export',                    gquery: 'sankey_0_to_2_natural_gas_to_export',                     color: '#7f7f7f'},
          {left: 'natural_gas',                 right: 'losses',                    gquery: 'sankey_0_to_2_natural_gas_to_loss',                     color: '#DCDCDC'},

          {left: 'solar_thermal',                right: 'agriculture',               gquery: 'sankey_0_to_2_solar_thermal_to_agriculture',             color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'households',                gquery: 'sankey_0_to_2_solar_thermal_to_households',              color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'buildings',                 gquery: 'sankey_0_to_2_solar_thermal_to_buildings',               color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'transport',                 gquery: 'sankey_0_to_2_solar_thermal_to_transport',               color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'industry',                  gquery: 'sankey_0_to_2_solar_thermal_to_industry',                color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'energy',                    gquery: 'sankey_0_to_2_solar_thermal_to_energy',                  color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'other',                     gquery: 'sankey_0_to_2_solar_thermal_to_other',                   color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'bunkers',                   gquery: 'sankey_0_to_2_solar_thermal_to_bunkers',                 color: '#ffcc00'},
          {left: 'solar_thermal',                right: 'feedstock',                 gquery: 'sankey_0_to_2_solar_thermal_to_feedstock',               color: '#ffcc00'},
          #{left: 'solar_thermal',               right: 'export',                    gquery: 'sankey_0_to_2_solar_thermal_to_export',                  color: '#ffcc00'},

          #{left: 'uranium',                     right: 'losses',                    gquery: 'sankey_0_to_2_uranium_to_loss',                     color: '#DCDCDC'},

          {left: 'imported_liquid_hydrogen',     right: 'export',                    gquery: 'sankey_0_to_2_imported_liquid_hydrogen_to_export',       color: '#87cfeb'},

          {left: 'imported_lohc',                right: 'export',                    gquery: 'sankey_0_to_2_imported_lohc_to_export',                  color: '#87cfeb'},

          {left: 'electricity',                  right: 'agriculture',               gquery: 'sankey_1_to_2_electricity_to_agriculture',               color: '#1f77b4'},
          {left: 'electricity',                  right: 'households',                gquery: 'sankey_1_to_2_electricity_to_households',                color: '#1f77b4'},
          {left: 'electricity',                  right: 'buildings',                 gquery: 'sankey_1_to_2_electricity_to_buildings',                 color: '#1f77b4'},
          {left: 'electricity',                  right: 'transport',                 gquery: 'sankey_1_to_2_electricity_to_transport',                 color: '#1f77b4'},
          {left: 'electricity',                  right: 'industry',                  gquery: 'sankey_1_to_2_electricity_to_industry',                  color: '#1f77b4'},
          {left: 'electricity',                  right: 'energy',                    gquery: 'sankey_1_to_2_electricity_to_energy',                    color: '#1f77b4'},
          {left: 'electricity',                  right: 'other',                     gquery: 'sankey_1_to_2_electricity_to_other',                     color: '#1f77b4'},
          {left: 'electricity',                  right: 'bunkers',                   gquery: 'sankey_1_to_2_electricity_to_bunkers',                   color: '#1f77b4'},
          {left: 'electricity',                  right: 'feedstock',                 gquery: 'sankey_1_to_2_electricity_to_feedstock',                 color: '#1f77b4'},
          {left: 'electricity',                  right: 'export',                    gquery: 'sankey_1_to_2_electricity_to_export',                    color: '#1f77b4'},
          {left: 'electricity',                  right: 'losses',                    gquery: 'sankey_1_to_2_electricity_to_loss',                      color: '#DCDCDC'},

          {left: 'heat',                         right: 'agriculture',               gquery: 'sankey_1_to_2_heat_to_agriculture',                      color: '#cc0000'},
          {left: 'heat',                         right: 'households',                gquery: 'sankey_1_to_2_heat_to_households',                       color: '#cc0000'},
          {left: 'heat',                         right: 'buildings',                 gquery: 'sankey_1_to_2_heat_to_buildings',                        color: '#cc0000'},
          {left: 'heat',                         right: 'transport',                 gquery: 'sankey_1_to_2_heat_to_transport',                        color: '#cc0000'},
          {left: 'heat',                         right: 'industry',                  gquery: 'sankey_1_to_2_heat_to_industry',                         color: '#cc0000'},
          {left: 'heat',                         right: 'energy',                    gquery: 'sankey_1_to_2_heat_to_energy',                           color: '#cc0000'},
          {left: 'heat',                         right: 'other',                     gquery: 'sankey_1_to_2_heat_to_other',                            color: '#cc0000'},
          {left: 'heat',                         right: 'bunkers',                   gquery: 'sankey_1_to_2_heat_to_bunkers',                          color: '#cc0000'},
          {left: 'heat',                         right: 'feedstock',                 gquery: 'sankey_1_to_2_heat_to_feedstock',                        color: '#cc0000'},
          {left: 'heat',                         right: 'losses',                    gquery: 'sankey_1_to_2_heat_to_loss',                             color: '#DCDCDC'},

          {left: 'hydrogen',                     right: 'agriculture',               gquery: 'sankey_1_to_2_hydrogen_to_agriculture',                  color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'households',                gquery: 'sankey_1_to_2_hydrogen_to_households',                   color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'buildings',                 gquery: 'sankey_1_to_2_hydrogen_to_buildings',                    color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'transport',                 gquery: 'sankey_1_to_2_hydrogen_to_transport',                    color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'industry',                  gquery: 'sankey_1_to_2_hydrogen_to_industry',                     color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'energy',                    gquery: 'sankey_1_to_2_hydrogen_to_energy',                       color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'other',                     gquery: 'sankey_1_to_2_hydrogen_to_other',                        color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'bunkers',                   gquery: 'sankey_1_to_2_hydrogen_to_bunkers',                      color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'feedstock',                 gquery: 'sankey_1_to_2_hydrogen_to_feedstock',                    color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'export',                    gquery: 'sankey_1_to_2_hydrogen_to_export',                       color: '#87cfeb'},
          {left: 'hydrogen',                     right: 'losses',                    gquery: 'sankey_1_to_2_hydrogen_to_loss',                         color: '#DCDCDC'},

          {left: 'oil_and_oil_products',         right: 'agriculture',               gquery: 'sankey_1_to_2_oil_and_oil_products_to_agriculture',      color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'households',                gquery: 'sankey_1_to_2_oil_and_oil_products_to_households',       color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'buildings',                 gquery: 'sankey_1_to_2_oil_and_oil_products_to_buildings',        color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'transport',                 gquery: 'sankey_1_to_2_oil_and_oil_products_to_transport',        color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'industry',                  gquery: 'sankey_1_to_2_oil_and_oil_products_to_industry',         color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'energy',                    gquery: 'sankey_1_to_2_oil_and_oil_products_to_energy',           color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'other',                     gquery: 'sankey_1_to_2_oil_and_oil_products_to_other',            color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'bunkers',                   gquery: 'sankey_1_to_2_oil_and_oil_products_to_bunkers',          color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'feedstock',                 gquery: 'sankey_1_to_2_oil_and_oil_products_to_feedstock',        color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'export',                    gquery: 'sankey_1_to_2_oil_and_oil_products_to_export',           color: '#8c564b'},
          {left: 'oil_and_oil_products',         right: 'losses',                    gquery: 'sankey_1_to_2_oil_and_oil_products_to_loss',             color: '#DCDCDC'},

          {left: 'waste_mix',                    right: 'feedstock',                 gquery: 'sankey_1_to_2_waste_mix_to_feedstock',                   color: '#CE7013'},

          {left: 'biofuels',                     right: 'agriculture',               gquery: 'sankey_1_to_2_biofuels_to_agriculture',                  color: '#246D24'},
          {left: 'biofuels',                     right: 'households',                gquery: 'sankey_1_to_2_biofuels_to_households',                   color: '#246D24'},
          {left: 'biofuels',                     right: 'buildings',                 gquery: 'sankey_1_to_2_biofuels_to_buildings',                    color: '#246D24'},
          {left: 'biofuels',                     right: 'transport',                 gquery: 'sankey_1_to_2_biofuels_to_transport',                    color: '#246D24'},
          {left: 'biofuels',                     right: 'industry',                  gquery: 'sankey_1_to_2_biofuels_to_industry',                     color: '#246D24'},
          {left: 'biofuels',                     right: 'energy',                    gquery: 'sankey_1_to_2_biofuels_to_energy',                       color: '#246D24'},
          {left: 'biofuels',                     right: 'other',                     gquery: 'sankey_1_to_2_biofuels_to_other',                        color: '#246D24'},
          {left: 'biofuels',                     right: 'bunkers',                   gquery: 'sankey_1_to_2_biofuels_to_bunkers',                      color: '#246D24'},
          {left: 'biofuels',                     right: 'feedstock',                 gquery: 'sankey_1_to_2_biofuels_to_feedstock',                    color: '#246D24'},
          {left: 'biofuels',                     right: 'export',                    gquery: 'sankey_1_to_2_biofuels_to_export',                       color: '#246D24'},
          {left: 'biofuels',                     right: 'losses',                    gquery: 'sankey_1_to_2_biofuels_to_loss',                         color: '#DCDCDC'},

          {left: 'ammonia',                      right: 'agriculture',               gquery: 'sankey_1_to_2_ammonia_to_agriculture',                   color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'households',                gquery: 'sankey_1_to_2_ammonia_to_households',                    color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'buildings',                 gquery: 'sankey_1_to_2_ammonia_to_buildings',                     color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'transport',                 gquery: 'sankey_1_to_2_ammonia_to_transport',                     color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'industry',                  gquery: 'sankey_1_to_2_ammonia_to_industry',                      color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'energy',                    gquery: 'sankey_1_to_2_ammonia_to_energy',                        color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'other',                     gquery: 'sankey_1_to_2_ammonia_to_other',                         color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'bunkers',                   gquery: 'sankey_1_to_2_ammonia_to_bunkers',                       color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'feedstock',                 gquery: 'sankey_1_to_2_ammonia_to_feedstock',                     color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'export',                    gquery: 'sankey_1_to_2_ammonia_to_export',                        color: '#1ce6d6'},
          {left: 'ammonia',                      right: 'losses',                    gquery: 'sankey_1_to_2_ammonia_to_loss',                          color: '#DCDCDC'},

          {left: 'network_gas',                  right: 'agriculture',               gquery: 'sankey_1_to_2_network_gas_to_agriculture',               color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'households',                gquery: 'sankey_1_to_2_network_gas_to_households',                color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'buildings',                 gquery: 'sankey_1_to_2_network_gas_to_buildings',                 color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'transport',                 gquery: 'sankey_1_to_2_network_gas_to_transport',                 color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'industry',                  gquery: 'sankey_1_to_2_network_gas_to_industry',                  color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'energy',                    gquery: 'sankey_1_to_2_network_gas_to_energy',                    color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'other',                     gquery: 'sankey_1_to_2_network_gas_to_other',                     color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'bunkers',                   gquery: 'sankey_1_to_2_network_gas_to_bunkers',                   color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'feedstock',                 gquery: 'sankey_1_to_2_network_gas_to_feedstock',                 color: '#7f7f7f'},
          #{left: 'network_gas',                 right: 'export',                    gquery: 'sankey_1_to_2_network_gas_to_export',                   color: '#7f7f7f'},
          {left: 'network_gas',                  right: 'losses',                      gquery: 'sankey_1_to_2_network_gas_to_loss',                     color: '#DCDCDC'},

          {left: 'methanol',                     right: 'transport',                 gquery: 'sankey_1_to_2_methanol_to_transport',                    color: '#FF8C8C'},
          {left: 'methanol',                     right: 'feedstock',                 gquery: 'sankey_1_to_2_methanol_to_feedstock',                    color: '#FF8C8C'},
          {left: 'methanol',                     right: 'export',                    gquery: 'sankey_1_to_2_methanol_to_export',                       color: '#FF8C8C'},
          {left: 'methanol',                     right: 'losses',                    gquery: 'sankey_1_to_2_methanol_to_loss',                         color: '#DCDCDC'}

        ]

    sankey_electrical_interconnection:
      data:
        nodes: [
          {id: 'solar',                        column: 0, label: 'solar',                  color: '#ffcc00'},
          {id: 'wind',                         column: 0, label: 'wind',                   color: '#63A1C9'},
          {id: 'biomass_waste_greengas',       column: 0, label: 'biomass_waste_greengas', color: '#2ca02c'},
          {id: 'other_renewables',             column: 0, label: 'other_renewables',       color: '#4465c6'},
          {id: 'hydrogen',                     column: 0, label: 'hydrogen',               color: '#87cfeb'},
          {id: 'fossil',                       column: 0, label: 'fossil',                 color: '#252525'},
          {id: 'nuclear',                      column: 0, label: 'uranium',                color: '#ff7f0e'},
          {id: 'import1',                      column: 0, label: 'import1',                color: '#b71540'},
          {id: 'import2',                      column: 0, label: 'import2',                color: '#b71540'},
          {id: 'import3',                      column: 0, label: 'import3',                color: '#b71540'},
          {id: 'import4',                      column: 0, label: 'import4',                color: '#b71540'},
          {id: 'import5',                      column: 0, label: 'import5',                color: '#b71540'},
          {id: 'import6',                      column: 0, label: 'import6',                color: '#b71540'},
          {id: 'import7',                      column: 0, label: 'import7',                color: '#b71540'},
          {id: 'import8',                      column: 0, label: 'import8',                color: '#b71540'},
          {id: 'import9',                      column: 0, label: 'import9',                color: '#b71540'},
          {id: 'import10',                     column: 0, label: 'import10',              color: '#b71540'},
          {id: 'import11',                     column: 0, label: 'import11',              color: '#b71540'},
          {id: 'import12',                     column: 0, label: 'import12',              color: '#b71540'},
          {id: 'shortage',                     column: 0, label: 'hv_shortage',           color: '#DCDCDC'},
          {id: 'network',                      column: 1, label: 'network',                color: '#006266'},
          {id: 'households',                   column: 2, label: 'households',             color: '#4169E1'},
          {id: 'buildings',                    column: 2, label: 'buildings',              color: '#ADD8E6'},
          {id: 'transport',                    column: 2, label: 'transport',              color: '#8B0000'},
          {id: 'industry',                     column: 2, label: 'industry',               color: '#A9A9A9'},
          {id: 'agriculture',                  column: 2, label: 'agriculture',            color: '#FFD700'},
          {id: 'power-to-gas',                 column: 2, label: 'power-to-gas',           color: '#77bbdd'},
          {id: 'power-to-gas-offshore',        column: 2, label: 'power-to-gas-offshore',  color: '#5e9aa4'},
          {id: 'curtailment',                  column: 2, label: 'curtailment',            color: '#dd9977'},
          {id: 'other',                        column: 2, label: 'other',                  color: '#E07033'},
          {id: 'bunkers',                      column: 2, label: 'bunkers',                color: '#8B4513'},
          {id: 'export1',                      column: 2, label: 'export1',                color: '#43464B'},
          {id: 'export2',                      column: 2, label: 'export2',                color: '#43464B'},
          {id: 'export3',                      column: 2, label: 'export3',                color: '#43464B'},
          {id: 'export4',                      column: 2, label: 'export4',                color: '#43464B'},
          {id: 'export5',                      column: 2, label: 'export5',                color: '#43464B'},
          {id: 'export6',                      column: 2, label: 'export6',                color: '#43464B'},
          {id: 'export7',                      column: 2, label: 'export7',                color: '#43464B'},
          {id: 'export8',                      column: 2, label: 'export8',                color: '#43464B'},
          {id: 'export9',                      column: 2, label: 'export9',                color: '#43464B'},
          {id: 'export10',                     column: 2, label: 'export10',               color: '#43464B'},
          {id: 'export11',                     column: 2, label: 'export11',               color: '#43464B'},
          {id: 'export12',                     column: 2, label: 'export12',               color: '#43464B'},
          {id: 'loss',                         column: 2, label: 'loss',                   color: '#DCDCDC'}
        ]

        links: [
          {left: 'solar',                   right: 'network',    gquery: 'solar_to_network_in_sankey',                   color: '#ffcc00'},
          {left: 'wind',                    right: 'network',    gquery: 'wind_to_network_in_sankey',                    color: '#63A1C9'},
          {left: 'biomass_waste_greengas',  right: 'network',    gquery: 'biomass_waste_greengas_to_network_in_sankey',  color: '#2ca02c'},
          {left: 'other_renewables',        right: 'network',    gquery: 'other_renewables_to_network_in_sankey',        color: '#4465c6'},
          {left: 'hydrogen',                right: 'network',    gquery: 'hydrogen_to_network_in_sankey',                color: '#87cfeb'},
          {left: 'fossil',                  right: 'network',    gquery: 'fossil_to_network_in_sankey',                  color: '#252525'},
          {left: 'nuclear',                 right: 'network',    gquery: 'nuclear_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import1',                 right: 'network',    gquery: 'import1_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import2',                 right: 'network',    gquery: 'import2_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import3',                 right: 'network',    gquery: 'import3_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import4',                 right: 'network',    gquery: 'import4_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import5',                 right: 'network',    gquery: 'import5_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import6',                 right: 'network',    gquery: 'import6_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import7',                 right: 'network',    gquery: 'import7_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import8',                 right: 'network',    gquery: 'import8_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import9',                 right: 'network',    gquery: 'import9_to_network_in_sankey',                 color: '#ff7f0e'},
          {left: 'import10',                right: 'network',    gquery: 'import10_to_network_in_sankey',                color: '#ff7f0e'},
          {left: 'import11',                right: 'network',    gquery: 'import11_to_network_in_sankey',                color: '#ff7f0e'},
          {left: 'import12',                right: 'network',    gquery: 'import12_to_network_in_sankey',                color: '#ff7f0e'},
          {left: 'shortage',                right: 'network',    gquery: 'shortage_to_network_in_sankey',                color: '#DCDCDC'},

          {left: 'network',       right: 'households',             gquery: 'network_to_households_in_sankey',    color: '#1f77b4'},
          {left: 'network',       right: 'buildings',              gquery: 'network_to_buildings_in_sankey',     color: '#1f77b4'},
          {left: 'network',       right: 'transport',              gquery: 'network_to_transport_in_sankey',     color: '#1f77b4'},
          {left: 'network',       right: 'industry',               gquery: 'network_to_industry_in_sankey',      color: '#1f77b4'},
          {left: 'network',       right: 'agriculture',            gquery: 'network_to_agriculture_in_sankey',   color: '#1f77b4'},
          {left: 'network',       right: 'power-to-gas',           gquery: 'network_to_p2g_in_sankey',           color: '#1f77b4'},
          {left: 'network',       right: 'power-to-gas-offshore',  gquery: 'network_to_p2g_offshore_in_sankey',  color: '#1f77b4'},
          {left: 'network',       right: 'curtailment',            gquery: 'network_to_curtailment_in_sankey',   color: '#1f77b4'},
          {left: 'network',       right: 'other',                  gquery: 'network_to_other_in_sankey',         color: '#1f77b4'},
          {left: 'network',       right: 'bunkers',                gquery: 'network_to_bunkers_in_sankey',       color: '#8B4513'},
          {left: 'network',       right: 'export1',                gquery: 'network_to_export1_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export2',                gquery: 'network_to_export2_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export3',                gquery: 'network_to_export3_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export4',                gquery: 'network_to_export4_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export5',                gquery: 'network_to_export5_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export6',                gquery: 'network_to_export6_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export7',                gquery: 'network_to_export7_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export8',                gquery: 'network_to_export8_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export9',                gquery: 'network_to_export9_in_sankey',       color: '#1f77b4'},
          {left: 'network',       right: 'export10',               gquery: 'network_to_export10_in_sankey',      color: '#1f77b4'},
          {left: 'network',       right: 'export11',               gquery: 'network_to_export11_in_sankey',      color: '#1f77b4'},
          {left: 'network',       right: 'export12',               gquery: 'network_to_export12_in_sankey',      color: '#1f77b4'},
          {left: 'network',       right: 'loss',                   gquery: 'network_to_loss_in_sankey',          color: '#DCDCDC'}
        ]
    sankey_heat_networks:
      data:
        nodes: [
          {id: 'coal_and_derivatives',         column: 0, label: 'coal_and_derivatives',              color: '#252525'},
          {id: 'natural_gas_and_derivatives',  column: 0, label: 'natural_gas',                       color: '#7f7f7f'},
          {id: 'crude_oil_and_derivatives',    column: 0, label: 'crude_oil_and_derivatives',         color: '#8c564b'},
          {id: 'electricity',                  column: 0, label: 'electricity',                       color: '#1f77b4'},
          {id: 'hydrogen',                     column: 0, label: 'hydrogen',                          color: '#87cfeb'},
          {id: 'ammonia',                      column: 0, label: 'ammonia',                           color: '#1ce6d6'},
          {id: 'biomass_products',             column: 0, label: 'biomass_products',                  color: '#2ca02c'},
          {id: 'non_biogenic_waste',           column: 0, label: 'non_biogenic_waste',                color: '#BA7D40'},
          {id: 'solar_thermal',                column: 0, label: 'solar_thermal',                     color: '#ffcc00'},
          {id: 'geothermal',                   column: 0, label: 'geothermal',                        color: '#FF8400'},
          {id: 'ambient_heat',                 column: 0, label: 'ambient_heat',                      color: '#ADDE4C'},
          {id: 'imported_heat',                column: 0, label: 'imported_heat',                     color: '#e61919'},
          {id: 'residual_heat',                column: 0, label: 'residual_heat',                     color: '#00008B'},
          {id: 'ht_network',                   column: 1, label: 'ht_network',                        color: '#785EF0'},
          {id: 'mt_network',                   column: 1, label: 'mt_network',                        color: '#DC267F'},
          {id: 'lt_network',                   column: 1, label: 'lt_network',                        color: '#FFB000'},
          {id: 'agriculture',                  column: 2, label: 'agriculture',                       color: '#FFD700'},
          {id: 'buildings',                    column: 2, label: 'buildings',                         color: '#ADD8E6'},
          {id: 'bunkers',                      column: 2, label: 'bunkers',                           color: '#8B4513'},
          {id: 'energy',                       column: 2, label: 'energy',                            color: '#416B86'},
          {id: 'households',                   column: 2, label: 'households',                        color: '#4169E1'},
          {id: 'industry',                     column: 2, label: 'industry',                          color: '#A9A9A9'},
          {id: 'other',                        column: 2, label: 'other',                             color: '#E07033'},
          {id: 'transport',                    column: 2, label: 'transport',                         color: '#8B0000'},
          {id: 'distribution_losses',          column: 2, label: 'distribution_losses',               color: '#DCDCDC'},
          {id: 'storage_losses',               column: 2, label: 'storage_losses',                    color: '#DCDCDC'},
          {id: 'unused_heat',                  column: 2, label: 'unused_heat',                       color: '#c70000'}
        ]
        links: [
          {left: 'coal_and_derivatives',         right: 'ht_network',           gquery: 'coal_and_derivatives_to_ht_network_in_sankey_heat_networks',         color: '#252525'},
          {left: 'natural_gas_and_derivatives',  right: 'ht_network',           gquery: 'natural_gas_and_derivatives_to_ht_network_in_sankey_heat_networks',  color: '#7f7f7f'},
          {left: 'crude_oil_and_derivatives',    right: 'ht_network',           gquery: 'crude_oil_and_derivatives_to_ht_network_in_sankey_heat_networks',    color: '#8c564b'},
          {left: 'electricity',                  right: 'ht_network',           gquery: 'electricity_to_ht_network_in_sankey_heat_networks',                  color: '#1f77b4'},
          {left: 'hydrogen',                     right: 'ht_network',           gquery: 'hydrogen_to_ht_network_in_sankey_heat_networks',                     color: '#87cfeb'},
          {left: 'ammonia',                      right: 'ht_network',           gquery: 'ammonia_to_ht_network_in_sankey_heat_networks',                      color: '#1ce6d6'},
          {left: 'biomass_products',             right: 'ht_network',           gquery: 'biomass_products_to_ht_network_in_sankey_heat_networks',             color: '#2ca02c'},
          {left: 'non_biogenic_waste',           right: 'ht_network',           gquery: 'non_biogenic_waste_to_ht_network_in_sankey_heat_networks',           color: '#BA7D40'},
          {left: 'solar_thermal',                right: 'ht_network',           gquery: 'solar_thermal_to_ht_network_in_sankey_heat_networks',                color: '#ffcc00'},
          {left: 'geothermal',                   right: 'ht_network',           gquery: 'geothermal_to_ht_network_in_sankey_heat_networks',                   color: '#FF8400'},
          {left: 'ambient_heat',                 right: 'ht_network',           gquery: 'ambient_heat_to_ht_network_in_sankey_heat_networks',                 color: '#ADDE4C'},
          {left: 'imported_heat',                right: 'ht_network',           gquery: 'imported_heat_to_ht_network_in_sankey_heat_networks',                color: '#e61919'},
          {left: 'residual_heat',                right: 'ht_network',           gquery: 'residual_heat_to_ht_network_in_sankey_heat_networks',                color: '#00008B'},

          {left: 'coal_and_derivatives',         right: 'mt_network',           gquery: 'coal_and_derivatives_to_mt_network_in_sankey_heat_networks',         color: '#252525'},
          {left: 'natural_gas_and_derivatives',  right: 'mt_network',           gquery: 'natural_gas_and_derivatives_to_mt_network_in_sankey_heat_networks',  color: '#7f7f7f'},
          {left: 'crude_oil_and_derivatives',    right: 'mt_network',           gquery: 'crude_oil_and_derivatives_to_mt_network_in_sankey_heat_networks',    color: '#8c564b'},
          {left: 'electricity',                  right: 'mt_network',           gquery: 'electricity_to_mt_network_in_sankey_heat_networks',                  color: '#1f77b4'},
          {left: 'hydrogen',                     right: 'mt_network',           gquery: 'hydrogen_to_mt_network_in_sankey_heat_networks',                     color: '#87cfeb'},
          {left: 'ammonia',                      right: 'mt_network',           gquery: 'ammonia_to_mt_network_in_sankey_heat_networks',                      color: '#1ce6d6'},
          {left: 'biomass_products',             right: 'mt_network',           gquery: 'biomass_products_to_mt_network_in_sankey_heat_networks',             color: '#2ca02c'},
          {left: 'non_biogenic_waste',           right: 'mt_network',           gquery: 'non_biogenic_waste_to_mt_network_in_sankey_heat_networks',           color: '#BA7D40'},
          {left: 'solar_thermal',                right: 'mt_network',           gquery: 'solar_thermal_to_mt_network_in_sankey_heat_networks',                color: '#ffcc00'},
          {left: 'geothermal',                   right: 'mt_network',           gquery: 'geothermal_to_mt_network_in_sankey_heat_networks',                   color: '#FF8400'},
          {left: 'ambient_heat',                 right: 'mt_network',           gquery: 'ambient_heat_to_mt_network_in_sankey_heat_networks',                 color: '#ADDE4C'},
          {left: 'imported_heat',                right: 'mt_network',           gquery: 'imported_heat_to_mt_network_in_sankey_heat_networks',                color: '#e61919'},
          {left: 'residual_heat',                right: 'mt_network',           gquery: 'residual_heat_to_mt_network_in_sankey_heat_networks',                color: '#00008B'},

          {left: 'coal_and_derivatives',         right: 'lt_network',           gquery: 'coal_and_derivatives_to_lt_network_in_sankey_heat_networks',         color: '#252525'},
          {left: 'natural_gas_and_derivatives',  right: 'lt_network',           gquery: 'natural_gas_and_derivatives_to_lt_network_in_sankey_heat_networks',  color: '#7f7f7f'},
          {left: 'crude_oil_and_derivatives',    right: 'lt_network',           gquery: 'crude_oil_and_derivatives_to_lt_network_in_sankey_heat_networks',    color: '#8c564b'},
          {left: 'electricity',                  right: 'lt_network',           gquery: 'electricity_to_lt_network_in_sankey_heat_networks',                  color: '#1f77b4'},
          {left: 'hydrogen',                     right: 'lt_network',           gquery: 'hydrogen_to_lt_network_in_sankey_heat_networks',                     color: '#87cfeb'},
          {left: 'ammonia',                      right: 'lt_network',           gquery: 'ammonia_to_lt_network_in_sankey_heat_networks',                      color: '#1ce6d6'},
          {left: 'biomass_products',             right: 'lt_network',           gquery: 'biomass_products_to_lt_network_in_sankey_heat_networks',             color: '#2ca02c'},
          {left: 'non_biogenic_waste',           right: 'lt_network',           gquery: 'non_biogenic_waste_to_lt_network_in_sankey_heat_networks',           color: '#BA7D40'},
          {left: 'solar_thermal',                right: 'lt_network',           gquery: 'solar_thermal_to_lt_network_in_sankey_heat_networks',                color: '#ffcc00'},
          {left: 'geothermal',                   right: 'lt_network',           gquery: 'geothermal_to_lt_network_in_sankey_heat_networks',                   color: '#FF8400'},
          {left: 'ambient_heat',                 right: 'lt_network',           gquery: 'ambient_heat_to_lt_network_in_sankey_heat_networks',                 color: '#ADDE4C'},
          {left: 'imported_heat',                right: 'lt_network',           gquery: 'imported_heat_to_lt_network_in_sankey_heat_networks',                color: '#e61919'},
          {left: 'residual_heat',                right: 'lt_network',           gquery: 'residual_heat_to_lt_network_in_sankey_heat_networks',                color: '#00008B'},

          {left: 'ht_network',                   right: 'agriculture',          gquery: 'ht_network_to_final_demand_agriculture_in_sankey_heat_networks',     color: '#785EF0'},
          {left: 'ht_network',                   right: 'buildings',            gquery: 'ht_network_to_final_demand_buildings_in_sankey_heat_networks',       color: '#785EF0'},
          {left: 'ht_network',                   right: 'bunkers',              gquery: 'ht_network_to_final_demand_bunkers_in_sankey_heat_networks',         color: '#785EF0'},
          {left: 'ht_network',                   right: 'energy',               gquery: 'ht_network_to_final_demand_energy_in_sankey_heat_networks',          color: '#785EF0'},
          {left: 'ht_network',                   right: 'households',           gquery: 'ht_network_to_final_demand_households_in_sankey_heat_networks',      color: '#785EF0'},
          {left: 'ht_network',                   right: 'industry',             gquery: 'ht_network_to_final_demand_industry_in_sankey_heat_networks',        color: '#785EF0'},
          {left: 'ht_network',                   right: 'other',                gquery: 'ht_network_to_final_demand_other_in_sankey_heat_networks',           color: '#785EF0'},
          {left: 'ht_network',                   right: 'transport',            gquery: 'ht_network_to_final_demand_transport_in_sankey_heat_networks',       color: '#785EF0'},
          {left: 'ht_network',                   right: 'distribution_losses',  gquery: 'ht_network_to_distribution_losses_in_sankey_heat_networks',          color: '#DCDCDC'},
          {left: 'ht_network',                   right: 'storage_losses',       gquery: 'ht_network_to_storage_losses_in_sankey_heat_networks',               color: '#DCDCDC'},
          {left: 'ht_network',                   right: 'unused_heat',          gquery: 'ht_network_to_unused_heat_in_sankey_heat_networks',                  color: '#c70000'},

          {left: 'mt_network',                   right: 'agriculture',          gquery: 'mt_network_to_final_demand_agriculture_in_sankey_heat_networks',     color: '#DC267F'},
          {left: 'mt_network',                   right: 'buildings',            gquery: 'mt_network_to_final_demand_buildings_in_sankey_heat_networks',       color: '#DC267F'},
          {left: 'mt_network',                   right: 'bunkers',              gquery: 'mt_network_to_final_demand_bunkers_in_sankey_heat_networks',         color: '#DC267F'},
          {left: 'mt_network',                   right: 'energy',               gquery: 'mt_network_to_final_demand_energy_in_sankey_heat_networks',          color: '#DC267F'},
          {left: 'mt_network',                   right: 'households',           gquery: 'mt_network_to_final_demand_households_in_sankey_heat_networks',      color: '#DC267F'},
          {left: 'mt_network',                   right: 'industry',             gquery: 'mt_network_to_final_demand_industry_in_sankey_heat_networks',        color: '#DC267F'},
          {left: 'mt_network',                   right: 'other',                gquery: 'mt_network_to_final_demand_other_in_sankey_heat_networks',           color: '#DC267F'},
          {left: 'mt_network',                   right: 'transport',            gquery: 'mt_network_to_final_demand_transport_in_sankey_heat_networks',       color: '#DC267F'},
          {left: 'mt_network',                   right: 'distribution_losses',  gquery: 'mt_network_to_distribution_losses_in_sankey_heat_networks',          color: '#DCDCDC'},
          {left: 'mt_network',                   right: 'storage_losses',       gquery: 'mt_network_to_storage_losses_in_sankey_heat_networks',               color: '#DCDCDC'},
          {left: 'mt_network',                   right: 'unused_heat',          gquery: 'mt_network_to_unused_heat_in_sankey_heat_networks',                  color: '#c70000'},

          {left: 'lt_network',                   right: 'agriculture',          gquery: 'lt_network_to_final_demand_agriculture_in_sankey_heat_networks',     color: '#FFB000'},
          {left: 'lt_network',                   right: 'buildings',            gquery: 'lt_network_to_final_demand_buildings_in_sankey_heat_networks',       color: '#FFB000'},
          {left: 'lt_network',                   right: 'bunkers',              gquery: 'lt_network_to_final_demand_bunkers_in_sankey_heat_networks',         color: '#FFB000'},
          {left: 'lt_network',                   right: 'energy',               gquery: 'lt_network_to_final_demand_energy_in_sankey_heat_networks',          color: '#FFB000'},
          {left: 'lt_network',                   right: 'households',           gquery: 'lt_network_to_final_demand_households_in_sankey_heat_networks',      color: '#FFB000'},
          {left: 'lt_network',                   right: 'industry',             gquery: 'lt_network_to_final_demand_industry_in_sankey_heat_networks',        color: '#FFB000'},
          {left: 'lt_network',                   right: 'other',                gquery: 'lt_network_to_final_demand_other_in_sankey_heat_networks',           color: '#FFB000'},
          {left: 'lt_network',                   right: 'transport',            gquery: 'lt_network_to_final_demand_transport_in_sankey_heat_networks',       color: '#FFB000'},
          {left: 'lt_network',                   right: 'distribution_losses',  gquery: 'lt_network_to_distribution_losses_in_sankey_heat_networks',          color: '#DCDCDC'},
          {left: 'lt_network',                   right: 'storage_losses',       gquery: 'lt_network_to_storage_losses_in_sankey_heat_networks',               color: '#DCDCDC'},
          {left: 'lt_network',                   right: 'unused_heat',          gquery: 'lt_network_to_unused_heat_in_sankey_heat_networks',                  color: '#c70000'}
        ]
    biomass_sankey:
      data:
        nodes: [
          {id: 'greengas_primary',                column: 0, label: 'greengas',                  color: '#CFEA85'},
          {id: 'biogas',                          column: 0, label: 'biogas',                    color: '#7FA025'},
          {id: 'biogenic_waste',                  column: 0, label: 'biogenic_waste',            color: '#A8C19C'},
          {id: 'wood_pellets',                    column: 0, label: 'wood_pellets',              color: '#228B22'},
          {id: 'torrefied_biomass_pellets',       column: 0, label: 'torrefied_biomass_pellets', color: '#145814'},
          {id: 'bio_kerosene_primary',            column: 0, label: 'bio_kerosene',              color: '#2E8B57'},
          {id: 'biodiesel_primary',               column: 0, label: 'biodiesel',                 color: '#9ACD32'},
          {id: 'bionaphtha_primary',              column: 0, label: 'bionaphtha',                color: '#3CB371'},
          {id: 'bio_ethanol',                     column: 0, label: 'bio_ethanol',               color: '#76B776'},
          {id: 'biomethanol_primary',             column: 0, label: 'biomethanol',               color: '#95B15C'},
          {id: 'bio_pyrolysis_oil_primary',       column: 0, label: 'bio_pyrolysis_oil',         color: '#6B8E23'},
          {id: 'bio_lng',                         column: 0, label: 'bio_lng',                   color: '#BDB828'},
          {id: 'bio_oil',                         column: 0, label: 'bio_oil',                   color: '#9E9911'},
          {id: 'hydrogen',                        column: 0, label: 'hydrogen',                  color: '#87cfeb'},
          {id: 'heat',                            column: 0, label: 'heat',                      color: '#cc0000'},

          {id: 'biomethanol_secondary',           column: 1, label: 'biomethanol',               color: '#95B15C'},
          {id: 'bio_pyrolysis_oil_secondary',     column: 1, label: 'bio_pyrolysis_oil',         color: '#6B8E23'},
          {id: 'industry_transformation',         column: 1, label: 'industry_transformation',   color: '#A9A9A9'},

          {id: 'greengas_secondary',              column: 2, label: 'greengas',                  color: '#CFEA85'},
          {id: 'bio_kerosene_secondary',          column: 2, label: 'bio_kerosene',              color: '#2E8B57'},
          {id: 'biodiesel_secondary',             column: 2, label: 'biodiesel',                 color: '#9ACD32'},
          {id: 'bionaphtha_secondary',            column: 2, label: 'bionaphtha',                color: '#3CB371'},

          {id: 'households',                      column: 3, label: 'households',                color: '#4169E1'},
          {id: 'buildings',                       column: 3, label: 'buildings',                 color: '#ADD8E6'},
          {id: 'transport',                       column: 3, label: 'transport',                 color: '#8B0000'},
          {id: 'bunkers',                         column: 3, label: 'bunkers',                   color: '#8B4513'},
          {id: 'industry',                        column: 3, label: 'industry',                  color: '#A9A9A9'},
          {id: 'agriculture',                     column: 3, label: 'agriculture',               color: '#FFD700'},
          {id: 'energy',                          column: 3, label: 'energy',                    color: '#CC6677'},
          {id: 'other',                           column: 3, label: 'other',                     color: '#E07033'},
          {id: 'export',                          column: 3, label: 'export',                    color: '#43464B'},
          {id: 'electricity_production',          column: 3, label: 'electricity_production',    color: '#1f77b4'},
          {id: 'heat_production',                 column: 3, label: 'heat_production',           color: '#cc0000'},
          {id: 'hydrogen_production',             column: 3, label: 'hydrogen_production',       color: '#87cfeb'},
          {id: 'losses',                          column: 3, label: 'losses',                    color: '#DCDCDC'},
        ]
        links: [
          # Column 0 to column 1
          {left: 'biogenic_waste',                right: 'biomethanol_secondary',                gquery: 'biogenic_waste_to_biomethanol_in_biomass_sankey', color: '#A8C19C'},
          {left: 'biomethanol_primary',           right: 'biomethanol_secondary',                gquery: 'biomethanol_to_biomethanol_in_biomass_sankey', color: '#95B15C'},

          {left: 'biogenic_waste',                right: 'bio_pyrolysis_oil_secondary',          gquery: 'biogenic_waste_to_bio_pyrolysis_oil_in_biomass_sankey', color: '#A8C19C'},
          {left: 'bio_pyrolysis_oil_primary',     right: 'bio_pyrolysis_oil_secondary',          gquery: 'bio_pyrolysis_oil_to_bio_pyrolysis_oil_in_biomass_sankey', color: '#6B8E23'},

          {left: 'greengas_primary',              right: 'industry_transformation',              gquery: 'greengas_to_industry_transformation_in_biomass_sankey', color: '#CFEA85'},
          {left: 'biogenic_waste',                right: 'industry_transformation',              gquery: 'biogenic_waste_to_industry_transformation_in_biomass_sankey', color: '#A8C19C'},
          {left: 'wood_pellets',                  right: 'industry_transformation',              gquery: 'wood_pellets_to_industry_transformation_in_biomass_sankey', color: '#228B22'},
          {left: 'bio_oil',                       right: 'industry_transformation',              gquery: 'bio_oil_to_industry_transformation_in_biomass_sankey', color: '#9E9911'},

          # # Column 1 to column 2
          {left: 'biomethanol_secondary',         right: 'bio_kerosene_secondary',               gquery: 'biomethanol_to_bio_kerosene_in_biomass_sankey', color: '#95B15C'},
          {left: 'biomethanol_secondary',         right: 'bionaphtha_secondary',                 gquery: 'biomethanol_to_bionaphtha_in_biomass_sankey', color: '#95B15C'},

          {left: 'bio_pyrolysis_oil_secondary',   right: 'bio_kerosene_secondary',               gquery: 'bio_pyrolysis_oil_to_bio_kerosene_in_biomass_sankey', color: '#6B8E23'},
          {left: 'bio_pyrolysis_oil_secondary',   right: 'bionaphtha_secondary',                 gquery: 'bio_pyrolysis_oil_to_bionaphtha_in_biomass_sankey', color: '#6B8E23'},

          {left: 'industry_transformation',       right: 'greengas_secondary',                   gquery: 'industry_transformation_to_greengas_in_biomass_sankey', color: '#CFEA85'},
          {left: 'industry_transformation',       right: 'bio_kerosene_secondary',               gquery: 'industry_transformation_to_bio_kerosene_in_biomass_sankey', color: '#2E8B57'},
          {left: 'industry_transformation',       right: 'biodiesel_secondary',                  gquery: 'industry_transformation_to_biodiesel_in_biomass_sankey', color: '#9ACD32'},
          {left: 'industry_transformation',       right: 'bionaphtha_secondary',                 gquery: 'industry_transformation_to_bionaphtha_in_biomass_sankey', color: '#3CB371'},

          # Column 0 to column 2
          {left: 'greengas_primary',              right: 'greengas_secondary',                   gquery: 'greengas_to_greengas_in_biomass_sankey', color: '#CFEA85'},
          {left: 'biogas',                        right: 'greengas_secondary',                   gquery: 'biogas_to_greengas_in_biomass_sankey', color: '#7FA025'},

          {left: 'biogenic_waste',                right: 'bio_kerosene_secondary',               gquery: 'biogenic_waste_to_bio_kerosene_in_biomass_sankey', color: '#A8C19C'},
          {left: 'bio_kerosene_primary',          right: 'bio_kerosene_secondary',               gquery: 'bio_kerosene_to_bio_kerosene_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_ethanol',                   right: 'bio_kerosene_secondary',               gquery: 'bio_ethanol_to_bio_kerosene_in_biomass_sankey', color: '#76B776'},
          {left: 'hydrogen',                      right: 'bio_kerosene_secondary',               gquery: 'hydrogen_to_bio_kerosene_in_biomass_sankey', color: '#87cfeb'},
          {left: 'heat',                          right: 'bio_kerosene_secondary',               gquery: 'steam_hot_water_to_bio_kerosene_in_biomass_sankey', color: '#cc0000'},

          {left: 'biogenic_waste',                right: 'biodiesel_secondary',                  gquery: 'biogenic_waste_to_biodiesel_in_biomass_sankey', color: '#A8C19C'},
          {left: 'biodiesel_primary',             right: 'biodiesel_secondary',                  gquery: 'biodiesel_to_biodiesel_in_biomass_sankey', color: '#9ACD32'},
          {left: 'bio_ethanol',                   right: 'biodiesel_secondary',                  gquery: 'bio_ethanol_to_biodiesel_in_biomass_sankey', color: '#76B776'},
          {left: 'hydrogen',                      right: 'biodiesel_secondary',                  gquery: 'hydrogen_to_biodiesel_in_biomass_sankey', color: '#87cfeb'},

          {left: 'biogenic_waste',                right: 'bionaphtha_secondary',                 gquery: 'biogenic_waste_to_bionaphtha_in_biomass_sankey', color: '#A8C19C'},
          {left: 'bionaphtha_primary',            right: 'bionaphtha_secondary',                 gquery: 'bionaphtha_to_bionaphtha_in_biomass_sankey', color: '#3CB371'},
          {left: 'hydrogen',                      right: 'bionaphtha_secondary',                 gquery: 'hydrogen_to_bionaphtha_in_biomass_sankey', color: '#87cfeb'},
          {left: 'heat',                          right: 'bionaphtha_secondary',                 gquery: 'steam_hot_water_to_bionaphtha_in_biomass_sankey', color: '#cc0000'},

          # Column 2 to column 3
          {left: 'greengas_secondary',            right: 'households',                           gquery: 'greengas_to_final_demand_households_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'buildings',                            gquery: 'greengas_to_final_demand_buildings_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'transport',                            gquery: 'greengas_to_final_demand_transport_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'bunkers',                              gquery: 'greengas_to_final_demand_bunkers_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'industry',                             gquery: 'greengas_to_final_demand_industry_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'agriculture',                          gquery: 'greengas_to_final_demand_agriculture_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'energy',                               gquery: 'greengas_to_final_demand_energy_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'other',                                gquery: 'greengas_to_final_demand_other_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'export',                               gquery: 'greengas_to_export_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'electricity_production',               gquery: 'greengas_to_electricity_production_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'heat_production',                      gquery: 'greengas_to_heat_production_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'hydrogen_production',                  gquery: 'greengas_to_hydrogen_production_in_biomass_sankey', color: '#CFEA85'},
          {left: 'greengas_secondary',            right: 'losses',                               gquery: 'greengas_to_loss_in_biomass_sankey', color: '#DCDCDC'},

          {left: 'bio_kerosene_secondary',        right: 'households',                           gquery: 'bio_kerosene_to_final_demand_households_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'buildings',                            gquery: 'bio_kerosene_to_final_demand_buildings_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'transport',                            gquery: 'bio_kerosene_to_final_demand_transport_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'bunkers',                              gquery: 'bio_kerosene_to_final_demand_bunkers_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'industry',                             gquery: 'bio_kerosene_to_final_demand_industry_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'agriculture',                          gquery: 'bio_kerosene_to_final_demand_agriculture_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'energy',                               gquery: 'bio_kerosene_to_final_demand_energy_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'other',                                gquery: 'bio_kerosene_to_final_demand_other_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'export',                               gquery: 'bio_kerosene_to_export_in_biomass_sankey', color: '#2E8B57'},
          {left: 'bio_kerosene_secondary',        right: 'losses',                               gquery: 'bio_kerosene_to_loss_in_biomass_sankey', color: '#DCDCDC'},

          {left: 'biodiesel_secondary',           right: 'households',                           gquery: 'biodiesel_to_final_demand_households_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'buildings',                            gquery: 'biodiesel_to_final_demand_buildings_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'transport',                            gquery: 'biodiesel_to_final_demand_transport_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'bunkers',                              gquery: 'biodiesel_to_final_demand_bunkers_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'industry',                             gquery: 'biodiesel_to_final_demand_industry_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'agriculture',                          gquery: 'biodiesel_to_final_demand_agriculture_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'energy',                               gquery: 'biodiesel_to_final_demand_energy_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'other',                                gquery: 'biodiesel_to_final_demand_other_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'export',                               gquery: 'biodiesel_to_export_in_biomass_sankey', color: '#9ACD32'},
          {left: 'biodiesel_secondary',           right: 'losses',                               gquery: 'biodiesel_to_loss_in_biomass_sankey', color: '#DCDCDC'},

          {left: 'bionaphtha_secondary',          right: 'industry',                             gquery: 'bionaphtha_to_final_demand_industry_in_biomass_sankey', color: '#3CB371'},
          {left: 'bionaphtha_secondary',          right: 'export',                               gquery: 'bionaphtha_to_export_in_biomass_sankey', color: '#3CB371'},
          {left: 'bionaphtha_secondary',          right: 'losses',                               gquery: 'bionaphtha_to_loss_in_biomass_sankey', color: '#DCDCDC'},

          {left: 'biomethanol_secondary',         right: 'transport',                            gquery: 'biomethanol_to_final_demand_transport_in_biomass_sankey', color: '#95B15C'},
          {left: 'biomethanol_secondary',         right: 'bunkers',                              gquery: 'biomethanol_to_final_demand_bunkers_in_biomass_sankey', color: '#95B15C'},
          {left: 'biomethanol_secondary',         right: 'industry',                             gquery: 'biomethanol_to_final_demand_industry_in_biomass_sankey', color: '#95B15C'},
          {left: 'biomethanol_secondary',         right: 'export',                               gquery: 'biomethanol_to_export_in_biomass_sankey', color: '#95B15C'},
          {left: 'biomethanol_secondary',         right: 'losses',                               gquery: 'biomethanol_to_loss_in_biomass_sankey', color: '#DCDCDC'},

          {left: 'bio_pyrolysis_oil_secondary',   right: 'export',                               gquery: 'bio_pyrolysis_oil_to_export_in_biomass_sankey', color: '#6B8E23'},
          {left: 'bio_pyrolysis_oil_secondary',   right: 'losses',                               gquery: 'bio_pyrolysis_oil_to_loss_in_biomass_sankey', color: '#DCDCDC'},

          # Column 0 to column 3
          {left: 'biogas',                        right: 'electricity_production',               gquery: 'biogas_to_electricity_production_in_biomass_sankey', color: '#7FA025'},
          {left: 'biogas',                        right: 'heat_production',                      gquery: 'biogas_to_heat_production_in_biomass_sankey', color: '#7FA025'},

          {left: 'biogenic_waste',                right: 'industry',                             gquery: 'biogenic_waste_to_final_demand_industry_in_biomass_sankey', color: '#A8C19C'},
          {left: 'biogenic_waste',                right: 'electricity_production',               gquery: 'biogenic_waste_to_electricity_production_in_biomass_sankey', color: '#A8C19C'},
          {left: 'biogenic_waste',                right: 'heat_production',                      gquery: 'biogenic_waste_to_heat_production_in_biomass_sankey', color: '#A8C19C'},

          {left: 'wood_pellets',                  right: 'households',                           gquery: 'wood_pellets_to_final_demand_households_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'buildings',                            gquery: 'wood_pellets_to_final_demand_buildings_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'transport',                            gquery: 'wood_pellets_to_final_demand_transport_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'bunkers',                              gquery: 'wood_pellets_to_final_demand_bunkers_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'industry',                             gquery: 'wood_pellets_to_final_demand_industry_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'agriculture',                          gquery: 'wood_pellets_to_final_demand_agriculture_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'energy',                               gquery: 'wood_pellets_to_final_demand_energy_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'other',                                gquery: 'wood_pellets_to_final_demand_other_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'electricity_production',               gquery: 'wood_pellets_to_electricity_production_in_biomass_sankey', color: '#228B22'},
          {left: 'wood_pellets',                  right: 'heat_production',                      gquery: 'wood_pellets_to_heat_production_in_biomass_sankey', color: '#228B22'},

          {left: 'torrefied_biomass_pellets',     right: 'electricity_production',               gquery: 'torrefied_biomass_pellets_to_electricity_production_in_biomass_sankey', color: '#145814'},
          {left: 'torrefied_biomass_pellets',     right: 'heat_production',                      gquery: 'torrefied_biomass_pellets_to_heat_production_in_biomass_sankey', color: '#145814'},
          {left: 'torrefied_biomass_pellets',     right: 'hydrogen_production',                  gquery: 'torrefied_biomass_pellets_to_hydrogen_production_in_biomass_sankey', color: '#145814'},

          {left: 'bio_ethanol',                   right: 'transport',                            gquery: 'bio_ethanol_to_final_demand_transport_in_biomass_sankey', color: '#76B776'},
          {left: 'bio_ethanol',                   right: 'export',                               gquery: 'bio_ethanol_to_export_in_biomass_sankey', color: '#76B776'},

          {left: 'bio_lng',                       right: 'transport',                            gquery: 'bio_lng_to_final_demand_transport_in_biomass_sankey', color: '#BDB828'},
          {left: 'bio_lng',                       right: 'bunkers',                              gquery: 'bio_lng_to_final_demand_bunkers_in_biomass_sankey', color: '#BDB828'},

          {left: 'bio_oil',                       right: 'households',                           gquery: 'bio_oil_to_final_demand_households_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'buildings',                            gquery: 'bio_oil_to_final_demand_buildings_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'transport',                            gquery: 'bio_oil_to_final_demand_transport_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'bunkers',                              gquery: 'bio_oil_to_final_demand_bunkers_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'industry',                             gquery: 'bio_oil_to_final_demand_industry_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'agriculture',                          gquery: 'bio_oil_to_final_demand_agriculture_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'energy',                               gquery: 'bio_oil_to_final_demand_energy_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'other',                                gquery: 'bio_oil_to_final_demand_other_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'electricity_production',               gquery: 'bio_oil_to_electricity_production_in_biomass_sankey', color: '#9E9911'},
          {left: 'bio_oil',                       right: 'heat_production',                      gquery: 'bio_oil_to_heat_production_in_biomass_sankey', color: '#9E9911'},
        ]
    co2_sankey:
      data:
        nodes: [
          {id: 'coal',                            column: 0, label: 'coal',                    color: '#252525'},
          {id: 'natural_gas',                     column: 0, label: 'natural_gas',             color: '#7f7f7f'},
          {id: 'oil',                             column: 0, label: 'oil',                     color: '#854321'},
          {id: 'non_biogenic_waste',              column: 0, label: 'non_biogenic_waste',      color: '#BA7D40'},
          {id: 'biomass_products',                column: 0, label: 'biomass_waste_greengas',  color: '#2ca02c'},
          {id: 'dac',                             column: 0, label: 'dac',                     color: '#b71540'},
          {id: 'households',                      column: 1, label: 'households'},
          {id: 'buildings',                       column: 1, label: 'buildings'},
          {id: 'transport',                       column: 1, label: 'transport'},
          {id: 'bunkers',                         column: 1, label: 'bunkers'},
          {id: 'industry',                        column: 1, label: 'industry',                color: '#854321'},
          {id: 'agriculture',                     column: 1, label: 'agriculture',             color: '#446600'},
          {id: 'energy',                          column: 1, label: 'energy',                  color: '#73264d'},
          {id: 'other',                           column: 1, label: 'other'},
          {id: 'emitted',                         column: 2, label: 'emitted',                 color: '#d62728'},
          {id: 'captured',                        column: 2, label: 'captured_co2',            color: '#1f77b4'}
        ]
        links: [
          {left: 'coal',                          right: 'households',               gquery: 'households_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'natural_gas',                   right: 'households',               gquery: 'households_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'households',               gquery: 'households_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'households',               gquery: 'households_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'coal',                          right: 'buildings',                gquery: 'buildings_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'natural_gas',                   right: 'buildings',                gquery: 'buildings_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'buildings',                gquery: 'buildings_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'buildings',                gquery: 'buildings_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'coal',                          right: 'transport',                gquery: 'transport_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'natural_gas',                   right: 'transport',                gquery: 'transport_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'transport',                gquery: 'transport_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'transport',                gquery: 'transport_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'natural_gas',                   right: 'bunkers',                  gquery: 'bunkers_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'bunkers',                  gquery: 'bunkers_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'bunkers',                  gquery: 'bunkers_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'coal',                          right: 'industry',                 gquery: 'industry_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'natural_gas',                   right: 'industry',                 gquery: 'industry_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'industry',                 gquery: 'industry_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'industry',                 gquery: 'industry_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'natural_gas',                   right: 'agriculture',              gquery: 'agriculture_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'agriculture',              gquery: 'agriculture_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'agriculture',              gquery: 'agriculture_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'coal',                          right: 'other',                    gquery: 'other_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'natural_gas',                   right: 'other',                    gquery: 'other_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'other',                    gquery: 'other_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'biomass_products',              right: 'other',                    gquery: 'other_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'coal',                          right: 'energy',                   gquery: 'energy_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'natural_gas',                   right: 'energy',                   gquery: 'energy_natural_gas_total_in_co2_sankey', color: '#7f7f7f'},
          {left: 'oil',                           right: 'energy',                   gquery: 'energy_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'non_biogenic_waste',            right: 'energy',                   gquery: 'energy_non_biogenic_waste_total_in_co2_sankey', color: '#BA7D40'},
          {left: 'biomass_products',              right: 'energy',                   gquery: 'energy_biomass_total_in_co2_sankey', color: '#2ca02c'},
          {left: 'dac',                           right: 'energy',                   gquery: 'energy_dac_total_in_co2_sankey', color: '#b71540'},
          {left: 'households',                    right: 'emitted',                  gquery: 'households_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'buildings',                     right: 'emitted',                  gquery: 'buildings_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'transport',                     right: 'emitted',                  gquery: 'transport_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'bunkers',                       right: 'emitted',                  gquery: 'bunkers_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'industry',                      right: 'emitted',                  gquery: 'industry_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'agriculture',                   right: 'emitted',                  gquery: 'agriculture_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'other',                         right: 'emitted',                  gquery: 'other_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'energy',                        right: 'emitted',                  gquery: 'energy_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'industry',                      right: 'captured',                 gquery: 'industry_captured_in_co2_sankey', color: '#1f77b4'},
          {left: 'energy',                        right: 'captured',                 gquery: 'energy_captured_in_co2_sankey', color: '#1f77b4'}
        ]
    ccus_sankey:
      data:
        nodes: [
          {id: 'dac',                            column: 0, label: 'dac',                         color: '#b71540'},
          {id: 'power_production',               column: 0, label: 'power_production',            color: '#786FA6'},
          {id: 'hydrogen_production',            column: 0, label: 'hydrogen_production',         color: '#A4B0BE'},
          {id: 'industry_fertilizers',           column: 0, label: 'industry_fertilizers',        color: '#63A1C9'},
          {id: 'industry_refineries',            column: 0, label: 'industry_refineries',         color: '#854321'},
          {id: 'industry_chemical_other',        column: 0, label: 'industry_chemical_other',     color: '#416B86'},
          {id: 'industry_steel',                 column: 0, label: 'industry_steel',              color: '#485460'},
          {id: 'industry_food',                  column: 0, label: 'industry_food',               color: '#A2D679'},
          {id: 'industry_paper',                 column: 0, label: 'industry_paper',              color: '#394C19'},
          {id: 'fischer_tropsch_capture',        column: 0, label: 'fischer_tropsch_capture',     color: '#2d5016'},
          {id: 'methanol_synthesis_capture',     column: 0, label: 'methanol_synthesis_capture',  color: '#1a2e0b'},
          {id: 'industry_external_coupling',     column: 0, label: 'industry_external_coupling',  color: '#3d1d59'},
          {id: 'import_co2_backup',              column: 0, label: 'import_co2_backup',           color: '#FDE97B'},
          {id: 'import_co2_baseload',            column: 0, label: 'import_co2_baseload',         color: '#fff3b0'},
          {id: 'captured_co2',                   column: 1, label: 'captured_co2',                color: '#1f77b4'},
          {id: 'other_utilisation',              column: 2, label: 'other_utilisation',           color: '#A7A1C5'},
          {id: 'other_delayed',                  column: 3, label: 'other_delayed',               color: '#A7A1C5'},
          {id: 'other_indefinitely',             column: 3, label: 'other_indefinitely',          color: '#533483'},
          {id: 'offshore_sequestration',         column: 3, label: 'offshore_sequestration',      color: '#416B86'},
          {id: 'methanol_synthesis_utilisation', column: 3, label: 'methanol_synthesis_utilisation', color: '#FF8C8C'},
          {id: 'fischer_tropsch_utilisation',    column: 3, label: 'fischer_tropsch_utilisation',  color: '#74B9FF'},
          {id: 'export',                         column: 3, label: 'export',                      color: '#6AB04C'},

        ]
        links: [
          {left: 'dac',                          right: 'captured_co2',                   gquery: 'dac_captured_co2_total_in_ccus_sankey', color: '#b71540'},
          {left: 'power_production',             right: 'captured_co2',                   gquery: 'power_production_captured_co2_total_in_ccus_sankey', color: '#786FA6'},
          {left: 'hydrogen_production',          right: 'captured_co2',                   gquery: 'hydrogen_production_captured_co2_total_in_ccus_sankey', color: '#A4B0BE'},
          {left: 'industry_fertilizers',         right: 'captured_co2',                   gquery: 'industry_fertilizers_captured_co2_total_in_ccus_sankey', color: '#63A1C9'},
          {left: 'industry_refineries',          right: 'captured_co2',                   gquery: 'industry_refineries_captured_co2_total_in_ccus_sankey', color: '#854321'},
          {left: 'industry_chemical_other',      right: 'captured_co2',                   gquery: 'industry_chemical_other_captured_co2_total_in_ccus_sankey', color: '#416B86'},
          {left: 'industry_steel',               right: 'captured_co2',                   gquery: 'industry_steel_captured_co2_total_in_ccus_sankey', color: '#485460'},
          {left: 'industry_food',                right: 'captured_co2',                   gquery: 'industry_food_captured_co2_total_in_ccus_sankey', color: '#A2D679'},
          {left: 'industry_paper',               right: 'captured_co2',                   gquery: 'industry_paper_captured_co2_total_in_ccus_sankey', color: '#394C19'},
          {left: 'fischer_tropsch_capture',      right: 'captured_co2',                   gquery: 'fischer_tropsch_captured_co2_total_in_ccus_sankey', color: '#2d5016'},
          {left: 'methanol_synthesis_capture',   right: 'captured_co2',                   gquery: 'methanol_synthesis_captured_co2_total_in_ccus_sankey', color: '#1a2e0b'},
          {left: 'industry_external_coupling',   right: 'captured_co2',                   gquery: 'captured_co2_industry_external_coupling_in_ccus_sankey', color: '#3d1d59'},
          {left: 'import_co2_backup',            right: 'captured_co2',                   gquery: 'import_captured_co2_backup_in_ccus_sankey', color: '#FDE97B'},
          {left: 'import_co2_baseload',          right: 'captured_co2',                   gquery: 'import_captured_co2_baseload_in_ccus_sankey', color: '#fff3b0'},
          {left: 'captured_co2',                 right: 'other_utilisation',              gquery: 'captured_co2_other_utilisation_total_in_ccus_sankey', color: '#1f77b4'},
          {left: 'other_utilisation',            right: 'other_delayed',                  gquery: 'captured_co2_other_utilisation_emitted_in_ccus_sankey', color: '#A7A1C5'},
          {left: 'other_utilisation',            right: 'other_indefinitely',             gquery: 'captured_co2_other_utilisation_indefinitely_in_ccus_sankey', color: '#533483'},
          {left: 'captured_co2',                 right: 'offshore_sequestration',         gquery: 'captured_co2_offshore_sequestration_total_in_ccus_sankey', color: '#1f77b4'},
          {left: 'captured_co2',                 right: 'methanol_synthesis_utilisation', gquery: 'captured_co2_methanol_synthesis_total_in_ccus_sankey', color: '#1f77b4'},
          {left: 'captured_co2',                 right: 'fischer_tropsch_utilisation',    gquery: 'captured_co2_fischer_tropsch_total_in_ccus_sankey', color: '#1f77b4'},
          {left: 'captured_co2',                 right: 'export',                         gquery: 'captured_co2_export_total_in_ccus_sankey', color: '#1f77b4'}

       ]
    sankey_hybrid_offshore:
      data:
        nodes: [
          {id: 'onshore_hv_network_left',     column: 0, label: 'onshore_hv_network',       color: '#004D40'},
          {id: 'hybrid_offshore_wind',        column: 0, label: 'hybrid_offshore_wind',     color: '#63A1C9'},
          {id: 'to_offshore_network',         column: 1, label: 'offshore_cable',           color: '#A9A9A9'},
          {id: 'offshore_electrolyser',       column: 2, label: 'offshore_electrolyser',    color: '#5e9aa4'},
          {id: 'from_offshore_network',       column: 2, label: 'offshore_cable',           color: '#A9A9A9'},
          {id: 'onshore_hydrogen_network',    column: 3, label: 'onshore_hydrogen_network', color: '#87cfeb'},
          {id: 'conversion_losses',           column: 3, label: 'conversion_losses',        color: '#cc0000'},
          {id: 'onshore_hv_network',          column: 3, label: 'onshore_hv_network',       color: '#004D40'},
          {id: 'curtailment',                 column: 3, label: 'curtailment',              color: '#dd9977'}
        ]
        links: [
          {left: 'onshore_hv_network_left', right: 'to_offshore_network',       gquery: 'onshore_hv_network_to_to_offshore_network_in_sankey',          color: '#A9A9A9'},
          {left: 'to_offshore_network',     right: 'offshore_electrolyser',     gquery: 'to_offshore_network_to_offshore_electrolyser_in_sankey',       color: '#A9A9A9'},
          {left: 'hybrid_offshore_wind',    right: 'offshore_electrolyser',     gquery: 'hybrid_offshore_wind_to_offshore_electrolyser_in_sankey',      color: '#1f77b4'},
          {left: 'hybrid_offshore_wind',    right: 'from_offshore_network',     gquery: 'hybrid_offshore_wind_to_from_offshore_network_in_sankey',      color: '#1f77b4'},
          {left: 'hybrid_offshore_wind',    right: 'curtailment',               gquery: 'hybrid_offshore_wind_to_curtailment_in_sankey',                color: '#1f77b4'},
          {left: 'offshore_electrolyser',   right: 'onshore_hydrogen_network',  gquery: 'offshore_electrolyser_to_hydrogen_network_in_sankey',          color: '#87cfeb'},
          {left: 'offshore_electrolyser',   right: 'conversion_losses',         gquery: 'offshore_electrolyser_to_conversion_losses_in_sankey',         color: '#cc0000'},
          {left: 'from_offshore_network',   right: 'onshore_hv_network',        gquery: 'from_offshore_network_to_onshore_hv_network_in_sankey',        color: '#1f77b4'}
        ]
    sankey:
      data:
        nodes: [
          {id: 'coal_and_derivatives',         column: 0, label: 'coal',                   color: '#252525'},
          {id: 'oil_and_derivatives',          column: 0, label: 'oil',                    color: '#8c564b'},
          {id: 'natural_gas',                  column: 0, label: 'gas',                    color: '#7f7f7f'},
          {id: 'solar',                        column: 0, label: 'solar',                  color: '#ffcc00'},
          {id: 'wind',                         column: 0, label: 'wind',                   color: '#63A1C9'},
          {id: 'biomass_products',             column: 0, label: 'biomass_waste_greengas', color: '#2ca02c'},
          {id: 'geo_ambient',                  column: 0, label: 'geo_ambient',            color: '#787821'},
          {id: 'water',                        column: 0, label: 'water',                  color: '#4465c6'},
          {id: 'nuclear',                      column: 0, label: 'uranium',                color: '#ff7f0e'},
          {id: 'imported_heat',                column: 0, label: 'imported_heat',          color: '#cc0000'},
          {id: 'imported_electricity',         column: 0, label: 'imported_electricity',   color: '#1f77b4'},
          {id: 'imported_hydrogen',            column: 0, label: 'imported_hydrogen',      color: '#87cfeb'},
          {id: 'imported_ammonia',             column: 0, label: 'imported_ammonia',       color: '#00dba1'},
          {id: 'electricity_prod',             column: 1, label: 'electricity_production', color: '#1f77b4'},
          {id: 'hydrogen_prod',                column: 1, label: 'hydrogen_production',    color: '#87cfeb'},
          {id: 'p2p',                          column: 2, label: 'p2p',                    color: '#a29bfe'},
          {id: 'p2h',                          column: 2, label: 'p2h',                    color: '#6c5ce7'},
          {id: 'p2g',                          column: 2, label: 'p2g',                    color: '#6c5ce7'},
          {id: 'central_heat_prod',            column: 1, label: 'central_heat_production',color: '#9467bd'},
          {id: 'households',                   column: 3, label: 'households',             color: '#4169E1'},
          {id: 'buildings',                    column: 3, label: 'buildings',              color: '#ADD8E6'},
          {id: 'transport',                    column: 3, label: 'transport',              color: '#8B0000'},
          {id: 'bunkers',                      column: 3, label: 'bunkers',                color: '#8B4513'},
          {id: 'industry',                     column: 3, label: 'industry',               color: '#A9A9A9'},
          {id: 'feedstock',                    column: 3, label: 'feedstock',              color: '#013220'},
          {id: 'agriculture',                  column: 3, label: 'agriculture',            color: '#FFD700'},
          {id: 'energy',                       column: 3, label: 'energy',                 color: '#416B86'},
          {id: 'other',                        column: 3, label: 'other',                  color: '#E07033'},
          {id: 'export',                       column: 3, label: 'export',                 color: '#43464B'},
          {id: 'conversion_losses',            column: 3, label: 'conversion_losses',      color: '#DCDCDC'},
          {id: 'transport_losses',             column: 3, label: 'transport_losses',       color: '#DCDCDC'}
        ]
        links: [
          {left: 'coal_and_derivatives',          right: 'electricity_prod', gquery: 'coal_and_derivatives_to_electricity_prod_in_sankey', color: '#252525'},
          {left: 'oil_and_derivatives',           right: 'electricity_prod', gquery: 'oil_and_derivatives_to_electricity_prod_in_sankey', color: '#8c564b'},
          {left: 'natural_gas',                   right: 'electricity_prod', gquery: 'natural_gas_to_electricity_prod_in_sankey', color: '#7f7f7f'},
          {left: 'solar',                         right: 'electricity_prod', gquery: 'solar_to_electricity_prod_in_sankey', color: '#ffcc00'},
          {left: 'wind',                          right: 'electricity_prod', gquery: 'wind_to_electricity_prod_in_sankey', color: '#63A1C9'},
          {left: 'biomass_products',              right: 'electricity_prod', gquery: 'biomass_products_to_electricity_prod_in_sankey', color: '#2ca02c'},
          {left: 'geo_ambient',                   right: 'electricity_prod', gquery: 'geo_ambient_to_electricity_prod_in_sankey', color: '#787821'},
          {left: 'nuclear',                       right: 'electricity_prod', gquery: 'nuclear_to_electricity_prod_in_sankey', color: '#ff7f0e'},
          {left: 'imported_electricity',          right: 'electricity_prod', gquery: 'imported_electricity_to_electricity_prod_in_sankey', color: '#1f77b4'},
          {left: 'imported_hydrogen',             right: 'electricity_prod', gquery: 'imported_hydrogen_to_electricity_prod_in_sankey', color: '#87cfeb'},
          {left: 'water',                         right: 'electricity_prod', gquery: 'water_to_electricity_prod_in_sankey', color: '#4465c6'},

          {left: 'coal_and_derivatives',          right: 'hydrogen_prod',    gquery: 'coal_and_derivatives_to_hydrogen_prod_in_sankey', color: '#252525'},
          {left: 'oil_and_derivatives',           right: 'hydrogen_prod',    gquery: 'oil_and_derivatives_to_hydrogen_prod_in_sankey', color: '#8c564b'},
          {left: 'natural_gas',                   right: 'hydrogen_prod',    gquery: 'natural_gas_to_hydrogen_prod_in_sankey', color: '#7f7f7f'},
          {left: 'solar',                         right: 'hydrogen_prod',    gquery: 'solar_to_hydrogen_prod_in_sankey', color: '#ffcc00'},
          {left: 'wind',                          right: 'hydrogen_prod',    gquery: 'wind_to_hydrogen_prod_in_sankey', color: '#63A1C9'},
          {left: 'biomass_products',              right: 'hydrogen_prod',    gquery: 'biomass_products_to_hydrogen_prod_in_sankey', color: '#2ca02c'},
          {left: 'geo_ambient',                   right: 'hydrogen_prod',    gquery: 'geo_ambient_to_hydrogen_prod_in_sankey', color: '#787821'},
          {left: 'nuclear',                       right: 'hydrogen_prod',    gquery: 'nuclear_to_hydrogen_prod_in_sankey', color: '#ff7f0e'},
          {left: 'imported_electricity',          right: 'hydrogen_prod',    gquery: 'imported_electricity_to_hydrogen_prod_in_sankey', color: '#1f77b4'},
          {left: 'imported_hydrogen',             right: 'hydrogen_prod',    gquery: 'hydrogen_import_to_hydrogen_prod_in_sankey', color: '#87cfeb'},
          {left: 'imported_ammonia',              right: 'hydrogen_prod',    gquery: 'imported_ammonia_to_hydrogen_prod_in_sankey', color: '#00dba1'},
          {left: 'water',                         right: 'hydrogen_prod',    gquery: 'water_to_hydrogen_prod_in_sankey', color: '#4465c6'},
          {left: 'industry',                      right: 'hydrogen_prod',    gquery: 'industry_to_hydrogen_prod_in_sankey', color: '#27d3d3'},

          {left: 'coal_and_derivatives',          right: 'central_heat_prod', gquery: 'coal_and_derivatives_to_central_heat_prod_in_sankey', color: '#252525'},
          {left: 'oil_and_derivatives',           right: 'central_heat_prod', gquery: 'oil_and_derivatives_to_central_heat_prod_in_sankey', color: '#8c564b'},
          {left: 'natural_gas',                   right: 'central_heat_prod', gquery: 'natural_gas_to_central_heat_prod_in_sankey', color: '#7f7f7f'},
          {left: 'solar',                         right: 'central_heat_prod', gquery: 'solar_to_central_heat_prod_in_sankey', color: '#ffcc00'},
          {left: 'wind',                          right: 'central_heat_prod', gquery: 'wind_to_central_heat_prod_in_sankey', color: '#63A1C9'},
          {left: 'biomass_products',              right: 'central_heat_prod', gquery: 'biomass_products_to_central_heat_prod_in_sankey', color: '#2ca02c'},
          {left: 'geo_ambient',                   right: 'central_heat_prod', gquery: 'geo_ambient_to_central_heat_prod_in_sankey', color: '#787821'},
          {left: 'imported_heat',                 right: 'central_heat_prod', gquery: 'imported_heat_to_central_heat_prod_in_sankey', color: '#d62728'},
          {left: 'nuclear',                       right: 'central_heat_prod', gquery: 'nuclear_to_central_heat_prod_in_sankey', color: '#ff7f0e'},
          {left: 'water',                         right: 'central_heat_prod', gquery: 'water_to_central_heat_prod_in_sankey', color: '#4465c6'},
          {left: 'industry',                      right: 'central_heat_prod', gquery: 'industry_to_central_heat_prod_in_sankey', color: '#d62728'},

          {left: 'hydrogen_prod',                 right: 'electricity_prod',  gquery: 'hydrogen_prod_to_electricity_prod_in_sankey', color: '#87cfeb'},

          {left: 'electricity_prod',              right: 'central_heat_prod', gquery: 'electricity_prod_to_central_heat_prod_in_sankey', color: '#1f77b4'},
          {left: 'hydrogen_prod',                 right: 'central_heat_prod', gquery: 'hydrogen_prod_to_central_heat_prod_in_sankey', color: '#87cfeb'},

          {left: 'electricity_prod',              right: 'households',        gquery: 'electricity_prod_to_households_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'buildings',         gquery: 'electricity_prod_to_buildings_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'transport',         gquery: 'electricity_prod_to_transport_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'industry',          gquery: 'electricity_prod_to_industry_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'feedstock',         gquery: 'electricity_prod_to_feedstock_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'agriculture',       gquery: 'electricity_prod_to_agriculture_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'energy',            gquery: 'electricity_prod_to_energy_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'other',             gquery: 'electricity_prod_to_other_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'export',            gquery: 'electricity_prod_to_export_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2p',               gquery: 'electricity_prod_to_p2p_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2h',               gquery: 'electricity_prod_to_p2h_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2g',               gquery: 'electricity_prod_to_p2g_in_sankey', color: '#1f77b4'},

          {left: 'electricity_prod',              right: 'households',        gquery: 'chp_heat_prod_to_households_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'buildings',         gquery: 'chp_heat_prod_to_buildings_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'transport',         gquery: 'chp_heat_prod_to_transport_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'industry',          gquery: 'chp_heat_prod_to_industry_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'feedstock',         gquery: 'chp_heat_prod_to_feedstock_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'agriculture',       gquery: 'chp_heat_prod_to_agriculture_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'energy',            gquery: 'chp_heat_prod_to_energy_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'other',             gquery: 'chp_heat_prod_to_other_in_sankey', color: '#d62728'},

          {left: 'electricity_prod',              right: 'conversion_losses', gquery: 'electricity_prod_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'electricity_prod',              right: 'transport_losses',  gquery: 'electricity_prod_to_transport_loss_in_sankey', color: '#DCDCDC'},

          {left: 'hydrogen_prod',                 right: 'households',       gquery: 'hydrogen_prod_to_households_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'buildings',        gquery: 'hydrogen_prod_to_buildings_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'transport',        gquery: 'hydrogen_prod_to_transport_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'industry',         gquery: 'hydrogen_prod_to_industry_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'feedstock',        gquery: 'hydrogen_prod_to_feedstock_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'agriculture',      gquery: 'hydrogen_prod_to_agriculture_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'energy',           gquery: 'hydrogen_prod_to_energy_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'other',            gquery: 'hydrogen_prod_to_other_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'bunkers',          gquery: 'hydrogen_prod_to_bunkers_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'export',           gquery: 'hydrogen_prod_to_export_in_sankey', color: '#87cfeb'},
          {left: 'hydrogen_prod',                 right: 'conversion_losses',gquery: 'hydrogen_prod_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'hydrogen_prod',                 right: 'transport_losses', gquery: 'hydrogen_prod_to_transport_loss_in_sankey', color: '#DCDCDC'},

          {left: 'central_heat_prod',             right: 'households',        gquery: 'central_heat_prod_to_households_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'buildings',         gquery: 'central_heat_prod_to_buildings_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'transport',         gquery: 'central_heat_prod_to_transport_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'industry',          gquery: 'central_heat_prod_to_industry_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'feedstock',         gquery: 'central_heat_prod_to_feedstock_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'agriculture',       gquery: 'central_heat_prod_to_agriculture_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'energy',            gquery: 'central_heat_prod_to_energy_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'other',             gquery: 'central_heat_prod_to_other_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'conversion_losses', gquery: 'central_heat_prod_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'central_heat_prod',             right: 'transport_losses',  gquery: 'central_heat_prod_to_transport_loss_in_sankey', color: '#DCDCDC'},

          {left: 'p2p',                           right: 'electricity_prod',  gquery: 'p2p_to_electricity_prod_in_sankey', color: '#1f77b4'},
          {left: 'p2p',                           right: 'conversion_losses', gquery: 'p2p_to_conversion_loss_in_sankey',  color: '#DCDCDC'},
          {left: 'p2h',                           right: 'households',        gquery: 'p2h_to_households_in_sankey',       color: '#d62728'},
          {left: 'p2h',                           right: 'industry',          gquery: 'p2h_to_industry_in_sankey',         color: '#d62728'},
          {left: 'p2h',                           right: 'agriculture',       gquery: 'p2h_to_agriculture_in_sankey',      color: '#d62728'},
          {left: 'p2h',                           right: 'conversion_losses', gquery: 'p2h_to_conversion_loss_in_sankey',  color: '#DCDCDC'},
          {left: 'p2g',                           right: 'hydrogen_prod',     gquery: 'p2g_to_hydrogen_prod_in_sankey',    color: '#27d3d3'},
          {left: 'p2g',                           right: 'conversion_losses', gquery: 'p2g_to_conversion_loss_in_sankey',  color: '#DCDCDC'},

          {left: 'coal_and_derivatives',          right: 'households',       gquery: 'coal_and_derivatives_to_households_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'buildings',        gquery: 'coal_and_derivatives_to_buildings_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'transport',        gquery: 'coal_and_derivatives_to_transport_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'industry',         gquery: 'coal_and_derivatives_to_industry_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'feedstock',        gquery: 'coal_and_derivatives_to_feedstock_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'agriculture',      gquery: 'coal_and_derivatives_to_agriculture_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'energy',           gquery: 'coal_and_derivatives_to_energy_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'other',            gquery: 'coal_and_derivatives_to_other_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'export',           gquery: 'coal_and_derivatives_to_export_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'transport_losses', gquery: 'coal_and_derivatives_to_transport_losses_in_sankey', color: '#252525'},

          {left: 'oil_and_derivatives',           right: 'households',       gquery: 'oil_and_derivatives_to_households_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'buildings',        gquery: 'oil_and_derivatives_to_buildings_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'transport',        gquery: 'oil_and_derivatives_to_transport_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'bunkers',          gquery: 'oil_and_derivatives_to_bunkers_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'industry',         gquery: 'oil_and_derivatives_to_industry_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'feedstock',        gquery: 'oil_and_derivatives_to_feedstock_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'agriculture',      gquery: 'oil_and_derivatives_to_agriculture_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'energy',           gquery: 'oil_and_derivatives_to_energy_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'other',            gquery: 'oil_and_derivatives_to_other_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'export',           gquery: 'oil_and_derivatives_to_export_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'transport_losses', gquery: 'oil_and_derivatives_to_transport_losses_in_sankey', color: '#8c564b'},

          {left: 'natural_gas',                   right: 'households',       gquery: 'natural_gas_to_households_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'buildings',        gquery: 'natural_gas_to_buildings_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'transport',        gquery: 'natural_gas_to_transport_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'bunkers',          gquery: 'natural_gas_to_bunkers_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'industry',         gquery: 'natural_gas_to_industry_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'feedstock',        gquery: 'natural_gas_to_feedstock_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'agriculture',      gquery: 'natural_gas_to_agriculture_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'energy',           gquery: 'natural_gas_to_energy_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'other',            gquery: 'natural_gas_to_other_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'export',           gquery: 'natural_gas_to_export_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'transport_losses', gquery: 'natural_gas_to_transport_losses_in_sankey', color: '#7f7f7f'},

          {left: 'solar',                         right: 'households',       gquery: 'solar_to_households_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'buildings',        gquery: 'solar_to_buildings_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'transport',        gquery: 'solar_to_transport_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'energy',           gquery: 'solar_to_energy_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'industry',         gquery: 'solar_to_industry_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'agriculture',      gquery: 'solar_to_agriculture_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'other',            gquery: 'solar_to_other_in_sankey', color: '#ffcc00'},

          #{left: 'wind',                          right: 'households',       gquery: 'wind_to_households_in_sankey', color: '#0080ff'},
          #{left: 'wind',                          right: 'buildings',        gquery: 'wind_to_buildings_in_sankey', color: '#0080ff'},
          #{left: 'wind',                          right: 'transport',        gquery: 'wind_to_transport_in_sankey', color: '#0080ff'},
          #{left: 'wind',                          right: 'industry',         gquery: 'wind_to_industry_in_sankey', color: '#0080ff'},
          #{left: 'wind',                          right: 'agriculture',      gquery: 'wind_to_agriculture_in_sankey', color: '#0080ff'},
          #{left: 'wind',                          right: 'other',            gquery: 'wind_to_other_in_sankey', color: '#0080ff'},

          {left: 'biomass_products',              right: 'households',       gquery: 'biomass_products_to_households_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'buildings',        gquery: 'biomass_products_to_buildings_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'transport',        gquery: 'biomass_products_to_transport_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'bunkers',          gquery: 'biomass_products_to_bunkers_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'industry',         gquery: 'biomass_products_to_industry_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'feedstock',        gquery: 'biomass_products_to_feedstock_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'agriculture',      gquery: 'biomass_products_to_agriculture_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'other',            gquery: 'biomass_products_to_other_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'export',           gquery: 'biomass_products_to_export_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'transport_losses', gquery: 'biomass_products_to_transport_losses_in_sankey', color: '#2ca02c'},

          {left: 'imported_ammonia',              right: 'households',       gquery: 'imported_ammonia_to_households_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'buildings',        gquery: 'imported_ammonia_to_buildings_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'transport',        gquery: 'imported_ammonia_to_transport_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'bunkers',          gquery: 'imported_ammonia_to_bunkers_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'industry',         gquery: 'imported_ammonia_to_industry_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'energy',           gquery: 'imported_ammonia_to_energy_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'feedstock',        gquery: 'imported_ammonia_to_feedstock_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'agriculture',      gquery: 'imported_ammonia_to_agriculture_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'other',            gquery: 'imported_ammonia_to_other_in_sankey', color: '#00dba1'},
          {left: 'imported_ammonia',              right: 'export',           gquery: 'imported_ammonia_to_export_in_sankey', color: '#00dba1'},

          #{left: 'geo_ambient',                   right: 'households',       gquery: 'geo_ambient_to_households_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'buildings',        gquery: 'geo_ambient_to_buildings_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'transport',        gquery: 'geo_ambient_to_transport_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'industry',         gquery: 'geo_ambient_to_industry_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'agriculture',      gquery: 'geo_ambient_to_agriculture_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'other',            gquery: 'geo_ambient_to_other_in_sankey', color: '#2ca02c'},

        ]
    liquid_fuels:
      data:
        nodes: [
          # INPUT SOURCES (Column 0)
          {id: 'crude_oil',                       column: 0, label: 'crude_oil',                 color: '#8B4513'},
          {id: 'network_gas',                     column: 0, label: 'network_gas',               color: '#7f7f7f'},
          {id: 'coal',                            column: 0, label: 'coal',                      color: '#252525'},
          {id: 'hydrogen',                        column: 0, label: 'hydrogen',                  color: '#87CEEB'},
          {id: 'electricity',                     column: 0, label: 'electricity',               color: '#1f77b4'},
          {id: 'steam_hot_water_input',           column: 0, label: 'steam_hot_water_input',     color: '#cc0000'},
          {id: 'wood_pellets',                    column: 0, label: 'wood_pellets',              color: '#228B22'},
          {id: 'fuel_import',                     column: 0, label: 'fuel_import',               color: '#A0522D'},
          {id: 'non_biogenic_waste',              column: 0, label: 'non_biogenic_waste',        color: '#A0522D'},
          {id: 'biogenic_waste',                  column: 0, label: 'biogenic_waste',            color: '#32CD32'},
          {id: 'dry_biomass',                     column: 0, label: 'dry_biomass',               color: '#228B22'},
          {id: 'oily_biomass',                    column: 0, label: 'oily_biomass',              color: '#3CB371'},
          {id: 'wet_biomass',                     column: 0, label: 'wet_biomass',               color: '#2E8B57'},
          {id: 'non_oil_input',                   column: 0, label: 'non_oil_input',             color: '#D3D3D3'},
          {id: 'biofuel_import',                  column: 0, label: 'biofuel_import',            color: '#90EE90'},

          # PROCESSING PATHWAYS (Column 1)
          {id: 'fossil_refinery',                 column: 1, label: 'fossil_refinery',           color: '#8B4513'},
          {id: 'chemical_fertilizer',             column: 1, label: 'chemical_fertilizer',       color: '#A0522D'},
          {id: 'fischer_tropsch',                 column: 1, label: 'fischer_tropsch',           color: '#696969'},
          {id: 'methanol_synthesis',              column: 1, label: 'methanol_synthesis',        color: '#708090'},
          {id: 'pyrolysis',                       column: 1, label: 'pyrolysis',                 color: '#556B2F'},
          {id: 'pyrolysis_fractionation',         column: 1, label: 'pyrolysis_fractionation',   color: '#556B2F'},
          {id: 'methanol_to_jet',                 column: 1, label: 'methanol_to_jet',           color: '#696969'},
          {id: 'hvo_bio_kerosene',                column: 1, label: 'hvo_bio_kerosene',          color: '#2E8B57'},
          {id: 'hvo_biodiesel',                   column: 1, label: 'hvo_biodiesel',             color: '#2E8B57'},
          {id: 'bio_ethanol_production',          column: 1, label: 'bio_ethanol_production',    color: '#228B22'},
          {id: 'bio_ethanol_to_jet',              column: 1, label: 'bio_ethanol_to_jet',        color: '#228B22'},
          {id: 'biomethanol_to_jet',              column: 1, label: 'biomethanol_to_jet',        color: '#228B22'},

          # FUEL PRODUCTS (Column 2)
          {id: 'diesel',                          column: 2, label: 'diesel',                    color: '#8B4513'},
          {id: 'gasoline',                        column: 2, label: 'gasoline',                  color: '#A0522D'},
          {id: 'oil_products',                    column: 2, label: 'oil_products',              color: '#8B4513'},
          {id: 'lpg',                             column: 2, label: 'lpg',                       color: '#CD853F'},
          {id: 'kerosene',                        column: 2, label: 'kerosene',                  color: '#D2691E'},
          {id: 'hfo',                             column: 2, label: 'hfo',                       color: '#8B7355'},
          {id: 'naphtha',                         column: 2, label: 'naphtha',                   color: '#B8860B'},
          {id: 'refinery_gas',                    column: 2, label: 'refinery_gas',              color: '#BC8F8F'},
          {id: 'pyrolysis_oil',                   column: 2, label: 'pyrolysis_oil',             color: '#8B7D6B'},
          {id: 'methanol',                        column: 2, label: 'methanol',                  color: '#BF8877'},
          {id: 'biomethanol',                     column: 2, label: 'biomethanol',               color: '#95B15C'},
          {id: 'bio_kerosene',                    column: 2, label: 'bio_kerosene',              color: '#32CD32'},
          {id: 'biodiesel',                       column: 2, label: 'biodiesel',                 color: '#9ACD32'},
          {id: 'bionaphtha',                      column: 2, label: 'bionaphtha',                color: '#3CB371'},
          {id: 'bio_ethanol',                     column: 2, label: 'bio_ethanol',               color: '#90EE90'},
          {id: 'bio_pyrolysis_oil',               column: 2, label: 'bio_pyrolysis_oil',         color: '#6B8E23'},
          {id: 'non_oil_output',                  column: 2, label: 'non_oil_output',            color: '#708090'},

          # END USES (Column 3)
          {id: 'households',                      column: 3, label: 'households',                color: '#117733'},
          {id: 'buildings',                       column: 3, label: 'buildings',                 color: '#44AA99'},
          {id: 'agriculture',                     column: 3, label: 'agriculture',               color: '#332288'},
          {id: 'transport',                       column: 3, label: 'transport',                 color: '#88CCEE'},
          {id: 'bunkers',                         column: 3, label: 'bunkers',                   color: '#882255'},
          {id: 'industry',                        column: 3, label: 'industry',                  color: '#DDCC77'},
          {id: 'energy',                          column: 3, label: 'energy',                    color: '#CC6677'},
          {id: 'export',                          column: 3, label: 'export',                    color: '#43464B'},
          {id: 'losses',                          column: 3, label: 'losses',                    color: '#DCDCDC'},
        ]
        links: [
          # CARRIERS TO PROCESS
          {left: 'crude_oil',                             right: 'fossil_refinery',                   gquery: 'crude_oil_to_fossil_refinery_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'network_gas',                           right: 'fossil_refinery',                   gquery: 'network_gas_to_fossil_refinery_in_liquid_fuels_sankey', color: '#7f7f7f'},
          {left: 'coal',                                  right: 'fossil_refinery',                   gquery: 'coal_to_fossil_refinery_in_liquid_fuels_sankey', color: '#252525'},
          {left: 'hydrogen',                              right: 'fossil_refinery',                   gquery: 'hydrogen_to_fossil_refinery_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'electricity',                           right: 'fossil_refinery',                   gquery: 'electricity_to_fossil_refinery_in_liquid_fuels_sankey', color: '#1f77b4'},
          {left: 'steam_hot_water_input',                 right: 'fossil_refinery',                   gquery: 'steam_hot_water_input_to_fossil_refinery_in_liquid_fuels_sankey', color: '#cc0000'},
          {left: 'wood_pellets',                          right: 'fossil_refinery',                   gquery: 'wood_pellets_to_fossil_refinery_in_liquid_fuels_sankey', color: '#228B22'},
          {left: 'non_oil_input',                         right: 'fossil_refinery',                   gquery: 'non_oil_input_to_industry_transformation_chemical_refineries_in_liquid_fuels_sankey', color: '#D3D3D3'},

          {left: 'hydrogen',                              right: 'fischer_tropsch',                   gquery: 'hydrogen_to_fischer_tropsch_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'electricity',                           right: 'fischer_tropsch',                   gquery: 'electricity_to_fischer_tropsch_in_liquid_fuels_sankey', color: '#1f77b4'},
          {left: 'non_biogenic_waste',                    right: 'fischer_tropsch',                   gquery: 'non_biogenic_waste_to_fischer_tropsch_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'biogenic_waste',                        right: 'fischer_tropsch',                   gquery: 'biogenic_waste_to_fischer_tropsch_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'dry_biomass',                           right: 'fischer_tropsch',                   gquery: 'dry_biomass_to_fischer_tropsch_in_liquid_fuels_sankey', color: '#228B22'},

          {left: 'hydrogen',                              right: 'methanol_synthesis',                gquery: 'hydrogen_to_methanol_synthesis_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'electricity',                           right: 'methanol_synthesis',                gquery: 'electricity_to_methanol_synthesis_in_liquid_fuels_sankey', color: '#1f77b4'},
          {left: 'non_biogenic_waste',                    right: 'methanol_synthesis',                gquery: 'non_biogenic_waste_to_methanol_synthesis_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'biogenic_waste',                        right: 'methanol_synthesis',                gquery: 'biogenic_waste_to_methanol_synthesis_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'dry_biomass',                           right: 'methanol_synthesis',                gquery: 'dry_biomass_to_methanol_synthesis_in_liquid_fuels_sankey', color: '#228B22'},

          {left: 'non_biogenic_waste',                    right: 'pyrolysis_fractionation',           gquery: 'non_biogenic_waste_to_pyrolysis_fractionation_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'biogenic_waste',                        right: 'pyrolysis_fractionation',           gquery: 'biogenic_waste_to_pyrolysis_fractionation_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'dry_biomass',                           right: 'pyrolysis_fractionation',           gquery: 'dry_biomass_to_pyrolysis_fractionation_in_liquid_fuels_sankey', color: '#228B22'},
          {left: 'fuel_import',                           right: 'pyrolysis_fractionation',           gquery: 'fuel_import_to_pyrolysis_fractionation_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'biofuel_import',                        right: 'pyrolysis_fractionation',           gquery: 'biofuel_import_to_pyrolysis_fractionation_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'hydrogen',                              right: 'pyrolysis_fractionation',            gquery: 'hydrogen_to_pyrolysis_fractionation_in_liquid_fuels_sankey', color: '#87CEEB'},

          {left: 'network_gas',                           right: 'hvo_bio_kerosene',                   gquery: 'network_gas_to_hvo_bio_kerosene_in_liquid_fuels_sankey', color: '#7f7f7f'},
          {left: 'hydrogen',                              right: 'hvo_bio_kerosene',                   gquery: 'hydrogen_to_hvo_bio_kerosene_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'oily_biomass',                          right: 'hvo_bio_kerosene',                   gquery: 'oily_biomass_to_hvo_bio_kerosene_in_liquid_fuels_sankey', color: '#3CB371'},

          {left: 'hydrogen',                              right: 'hvo_biodiesel',                       gquery: 'hydrogen_to_hvo_biodiesel_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'oily_biomass',                          right: 'hvo_biodiesel',                       gquery: 'oily_biomass_to_hvo_biodiesel_in_liquid_fuels_sankey', color: '#3CB371'},

          {left: 'network_gas',                           right: 'bio_ethanol_production',             gquery: 'network_gas_to_bio_ethanol_production_in_liquid_fuels_sankey', color: '#7f7f7f'},
          {left: 'wet_biomass',                           right: 'bio_ethanol_production',             gquery: 'wet_biomass_to_bio_ethanol_production_in_liquid_fuels_sankey', color: '#2E8B57'},

          {left: 'hydrogen',                              right: 'bio_ethanol_to_jet',                 gquery: 'hydrogen_to_bio_ethanol_to_jet_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'bio_ethanol',                           right: 'bio_ethanol_to_jet',                 gquery: 'bio_ethanol_to_bio_ethanol_to_jet_in_liquid_fuels_sankey', color: '#90EE90'},

          {left: 'hydrogen',                              right: 'methanol_to_jet',                    gquery: 'hydrogen_to_methanol_to_jet_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'methanol',                              right: 'methanol_to_jet',                    gquery: 'methanol_to_methanol_to_jet_in_liquid_fuels_sankey', color: '#BF8877'},

          {left: 'hydrogen',                              right: 'biomethanol_to_jet',                 gquery: 'hydrogen_to_biomethanol_to_jet_in_liquid_fuels_sankey', color: '#87CEEB'},
          {left: 'biomethanol',                           right: 'biomethanol_to_jet',                 gquery: 'biomethanol_to_biomethanol_to_jet_in_liquid_fuels_sankey', color: '#95B15C'},

          # PROCESS OUTPUT TO FUELS
          {left: 'fossil_refinery',                       right: 'diesel',                            gquery: 'fossil_refinery_to_diesel_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'fossil_refinery',                       right: 'gasoline',                          gquery: 'fossil_refinery_to_gasoline_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fossil_refinery',                       right: 'oil_products',                      gquery: 'fossil_refinery_to_oil_products_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'fossil_refinery',                       right: 'lpg',                               gquery: 'fossil_refinery_to_lpg_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'fossil_refinery',                       right: 'kerosene',                          gquery: 'fossil_refinery_to_kerosene_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'fossil_refinery',                       right: 'hfo',                               gquery: 'fossil_refinery_to_hfo_in_liquid_fuels_sankey', color: '#8B7355'},
          {left: 'fossil_refinery',                       right: 'naphtha',                           gquery: 'fossil_refinery_to_naphtha_in_liquid_fuels_sankey', color: '#B8860B'},
          {left: 'fossil_refinery',                       right: 'refinery_gas',                      gquery: 'fossil_refinery_to_refinery_gas_in_liquid_fuels_sankey', color: '#BC8F8F'},
          {left: 'fossil_refinery',                       right: 'methanol',                          gquery: 'fossil_refinery_to_methanol_in_liquid_fuels_sankey', color: '#BF8877'},
          {left: 'fossil_refinery',                       right: 'bio_kerosene',                      gquery: 'fossil_refinery_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'fossil_refinery',                       right: 'biodiesel',                         gquery: 'fossil_refinery_to_biodiesel_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'fossil_refinery',                       right: 'bionaphtha',                        gquery: 'fossil_refinery_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'fossil_refinery',                       right: 'non_oil_output',                    gquery: 'fossil_refinery_to_non_oil_output_in_liquid_fuels_sankey', color: '#708090'},
          {left: 'fossil_refinery',                       right: 'losses',                            gquery: 'fossil_refinery_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'chemical_fertilizer',                  right: 'diesel',                            gquery: 'fertilizers_chemical_to_diesel_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'chemical_fertilizer',                  right: 'gasoline',                          gquery: 'fertilizers_chemical_to_gasoline_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'chemical_fertilizer',                  right: 'oil_products',                      gquery: 'fertilizers_chemical_to_oil_products_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'chemical_fertilizer',                  right: 'lpg',                               gquery: 'fertilizers_chemical_to_lpg_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'chemical_fertilizer',                  right: 'kerosene',                          gquery: 'fertilizers_chemical_to_kerosene_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'chemical_fertilizer',                  right: 'hfo',                               gquery: 'fertilizers_chemical_to_hfo_in_liquid_fuels_sankey', color: '#8B7355'},
          {left: 'chemical_fertilizer',                  right: 'naphtha',                           gquery: 'fertilizers_chemical_to_naphtha_in_liquid_fuels_sankey', color: '#B8860B'},
          {left: 'chemical_fertilizer',                  right: 'methanol',                          gquery: 'fertilizers_chemical_to_methanol_in_liquid_fuels_sankey', color: '#BF8877'},
          {left: 'chemical_fertilizer',                  right: 'bio_kerosene',                      gquery: 'fertilizers_chemical_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'chemical_fertilizer',                  right: 'biodiesel',                         gquery: 'fertilizers_chemical_to_biodiesel_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'chemical_fertilizer',                  right: 'bionaphtha',                        gquery: 'fertilizers_chemical_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'chemical_fertilizer',                  right: 'losses',                            gquery: 'fertilizers_chemical_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'fischer_tropsch',                       right: 'diesel',                            gquery: 'fischer_tropsch_to_diesel_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'fischer_tropsch',                       right: 'gasoline',                          gquery: 'fischer_tropsch_to_gasoline_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fischer_tropsch',                       right: 'kerosene',                          gquery: 'fischer_tropsch_to_kerosene_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'fischer_tropsch',                       right: 'naphtha',                           gquery: 'fischer_tropsch_to_naphtha_in_liquid_fuels_sankey', color: '#B8860B'},

          {left: 'fischer_tropsch',                       right: 'bio_kerosene',                      gquery: 'fischer_tropsch_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'fischer_tropsch',                       right: 'biodiesel',                         gquery: 'fischer_tropsch_to_biodiesel_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'fischer_tropsch',                       right: 'bionaphtha',                        gquery: 'fischer_tropsch_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'fischer_tropsch',                       right: 'losses',                            gquery: 'fischer_tropsch_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'methanol_synthesis',                    right: 'methanol',                          gquery: 'methanol_synthesis_to_methanol_in_liquid_fuels_sankey', color: '#BF8877'},
          {left: 'methanol_synthesis',                    right: 'biomethanol',                       gquery: 'methanol_synthesis_to_biomethanol_in_liquid_fuels_sankey', color: '#95B15C'},
          {left: 'methanol_synthesis',                    right: 'losses',                            gquery: 'methanol_synthesis_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'pyrolysis_fractionation',               right: 'kerosene',                          gquery: 'pyrolysis_fractionation_to_kerosene_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'pyrolysis_fractionation',               right: 'naphtha',                           gquery: 'pyrolysis_fractionation_to_naphtha_in_liquid_fuels_sankey', color: '#B8860B'},
          {left: 'pyrolysis_fractionation',               right: 'bio_kerosene',                      gquery: 'pyrolysis_fractionation_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'pyrolysis_fractionation',               right: 'bionaphtha',                        gquery: 'pyrolysis_fractionation_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'pyrolysis_fractionation',               right: 'pyrolysis_oil',                     gquery: 'pyrolysis_fractionation_to_pyrolysis_oil_in_liquid_fuels_sankey', color: '#8B7D6B'},
          {left: 'pyrolysis_fractionation',               right: 'bio_pyrolysis_oil',                 gquery: 'pyrolysis_fractionation_to_bio_pyrolysis_oil_in_liquid_fuels_sankey', color: '#6B8E23'},
          {left: 'pyrolysis_fractionation',               right: 'losses',                            gquery: 'pyrolysis_fractionation_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'hvo_bio_kerosene',                      right: 'bio_kerosene',                      gquery: 'hvo_bio_kerosene_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'hvo_bio_kerosene',                      right: 'bionaphtha',                        gquery: 'hvo_bio_kerosene_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'hvo_bio_kerosene',                      right: 'losses',                            gquery: 'hvo_bio_kerosene_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'hvo_biodiesel',                         right: 'biodiesel',                         gquery: 'hvo_biodiesel_to_biodiesel_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'hvo_biodiesel',                         right: 'bionaphtha',                        gquery: 'hvo_biodiesel_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'hvo_biodiesel',                         right: 'losses',                            gquery: 'hvo_biodiesel_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'bio_ethanol_production',                right: 'bio_ethanol',                       gquery: 'bio_ethanol_production_to_bio_ethanol_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'bio_ethanol_production',                right: 'losses',                            gquery: 'bio_ethanol_production_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'bio_ethanol_to_jet',                    right: 'bio_kerosene',                      gquery: 'bio_ethanol_to_jet_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_ethanol_to_jet',                    right: 'biodiesel',                         gquery: 'bio_ethanol_to_jet_to_biodiesel_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'bio_ethanol_to_jet',                    right: 'losses',                            gquery: 'bio_ethanol_to_jet_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'methanol_to_jet',                       right: 'kerosene',                          gquery: 'methanol_to_jet_to_kerosene_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'methanol_to_jet',                       right: 'naphtha',                           gquery: 'methanol_to_jet_to_naphtha_in_liquid_fuels_sankey', color: '#B8860B'},
          {left: 'methanol_to_jet',                       right: 'losses',                            gquery: 'methanol_to_jet_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'biomethanol_to_jet',                    right: 'bio_kerosene',                      gquery: 'biomethanol_to_jet_to_bio_kerosene_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'biomethanol_to_jet',                    right: 'bionaphtha',                        gquery: 'biomethanol_to_jet_to_bionaphtha_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'biomethanol_to_jet',                    right: 'losses',                            gquery: 'biomethanol_to_jet_to_loss_in_liquid_fuels_sankey', color: '#DCDCDC'},

          # IMPORT TO FUELS
          {left: 'fuel_import',                           right: 'diesel',                            gquery: 'fuel_import_to_diesel_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'gasoline',                          gquery: 'fuel_import_to_gasoline_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'lpg',                               gquery: 'fuel_import_to_lpg_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'kerosene',                          gquery: 'fuel_import_to_kerosene_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'hfo',                               gquery: 'fuel_import_to_hfo_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'naphtha',                           gquery: 'fuel_import_to_naphtha_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'methanol',                          gquery: 'fuel_import_to_methanol_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'fuel_import',                           right: 'pyrolysis_oil',                     gquery: 'fuel_import_to_pyrolysis_oil_in_liquid_fuels_sankey', color: '#A0522D'},

          {left: 'biofuel_import',                        right: 'biomethanol',                       gquery: 'biofuel_import_to_biomethanol_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'biofuel_import',                        right: 'bio_kerosene',                      gquery: 'biofuel_import_to_bio_kerosene_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'biofuel_import',                        right: 'biodiesel',                         gquery: 'biofuel_import_to_biodiesel_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'biofuel_import',                        right: 'bionaphtha',                        gquery: 'biofuel_import_to_bionaphtha_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'biofuel_import',                        right: 'bio_ethanol',                       gquery: 'biofuel_import_to_bio_ethanol_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'biofuel_import',                        right: 'bio_pyrolysis_oil',                 gquery: 'biofuel_import_to_bio_pyrolysis_oil_in_liquid_fuels_sankey', color: '#90EE90'},

          # FUEL PRODUCTS TO END USES
          {left: 'crude_oil',                             right: 'export',                            gquery: 'crude_oil_to_export_in_liquid_fuels_sankey', color: '#8B4513'},

          {left: 'diesel',                                right: 'households',                        gquery: 'diesel_to_households_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'diesel',                                right: 'buildings',                         gquery: 'diesel_to_buildings_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'diesel',                                right: 'agriculture',                       gquery: 'diesel_to_agriculture_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'diesel',                                right: 'transport',                         gquery: 'diesel_to_transport_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'diesel',                                right: 'industry',                          gquery: 'diesel_to_industry_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'diesel',                                right: 'energy',                            gquery: 'diesel_to_energy_in_liquid_fuels_sankey', color: '#8B4513'},
          {left: 'diesel',                                right: 'export',                            gquery: 'diesel_to_export_in_liquid_fuels_sankey', color: '#8B4513'},

          {left: 'gasoline',                              right: 'transport',                         gquery: 'gasoline_to_transport_in_liquid_fuels_sankey', color: '#A0522D'},
          {left: 'gasoline',                              right: 'export',                            gquery: 'gasoline_to_export_in_liquid_fuels_sankey', color: '#A0522D'},

          {left: 'lpg',                                   right: 'households',                        gquery: 'lpg_to_households_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'lpg',                                   right: 'buildings',                         gquery: 'lpg_to_buildings_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'lpg',                                   right: 'agriculture',                       gquery: 'lpg_to_agriculture_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'lpg',                                   right: 'transport',                         gquery: 'lpg_to_transport_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'lpg',                                   right: 'industry',                          gquery: 'lpg_to_industry_in_liquid_fuels_sankey', color: '#CD853F'},
          {left: 'lpg',                                   right: 'export',                            gquery: 'lpg_to_export_in_liquid_fuels_sankey', color: '#CD853F'},

          {left: 'kerosene',                              right: 'households',                        gquery: 'kerosene_to_households_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'kerosene',                              right: 'buildings',                         gquery: 'kerosene_to_buildings_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'kerosene',                              right: 'agriculture',                       gquery: 'kerosene_to_agriculture_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'kerosene',                              right: 'transport',                         gquery: 'kerosene_to_transport_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'kerosene',                              right: 'bunkers',                           gquery: 'kerosene_to_bunkers_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'kerosene',                              right: 'industry',                          gquery: 'kerosene_to_industry_in_liquid_fuels_sankey', color: '#D2691E'},
          {left: 'kerosene',                              right: 'export',                            gquery: 'kerosene_to_export_in_liquid_fuels_sankey', color: '#D2691E'},

          {left: 'pyrolysis_oil',                         right: 'export',                            gquery: 'pyrolysis_oil_to_export_in_liquid_fuels_sankey', color: '#8B7D6B'},

          {left: 'bio_pyrolysis_oil',                     right: 'export',                            gquery: 'bio_pyrolysis_oil_to_export_in_liquid_fuels_sankey', color: '#6B8E23'},

          {left: 'bio_kerosene',                          right: 'households',                        gquery: 'bio_kerosene_to_households_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_kerosene',                          right: 'buildings',                         gquery: 'bio_kerosene_to_buildings_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_kerosene',                          right: 'agriculture',                       gquery: 'bio_kerosene_to_agriculture_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_kerosene',                          right: 'transport',                         gquery: 'bio_kerosene_to_transport_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_kerosene',                          right: 'bunkers',                           gquery: 'bio_kerosene_to_bunkers_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_kerosene',                          right: 'industry',                          gquery: 'bio_kerosene_to_industry_in_liquid_fuels_sankey', color: '#32CD32'},
          {left: 'bio_kerosene',                          right: 'export',                            gquery: 'bio_kerosene_to_export_in_liquid_fuels_sankey', color: '#32CD32'},

          {left: 'hfo',                                   right: 'transport',                         gquery: 'hfo_to_transport_in_liquid_fuels_sankey', color: '#8B7355'},
          {left: 'hfo',                                   right: 'bunkers',                           gquery: 'hfo_to_bunkers_in_liquid_fuels_sankey', color: '#8B7355'},
          {left: 'hfo',                                   right: 'export',                            gquery: 'hfo_to_export_in_liquid_fuels_sankey', color: '#8B7355'},

          {left: 'naphtha',                               right: 'industry',                          gquery: 'naphtha_to_industry_in_liquid_fuels_sankey', color: '#B8860B'},
          {left: 'naphtha',                               right: 'export',                            gquery: 'naphtha_to_export_in_liquid_fuels_sankey', color: '#B8860B'},

          {left: 'bionaphtha',                            right: 'industry',                          gquery: 'bionaphtha_to_industry_in_liquid_fuels_sankey', color: '#3CB371'},
          {left: 'bionaphtha',                            right: 'export',                            gquery: 'bionaphtha_to_export_in_liquid_fuels_sankey', color: '#3CB371'},

          {left: 'biodiesel',                             right: 'buildings',                         gquery: 'biodiesel_to_buildings_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'biodiesel',                             right: 'households',                        gquery: 'biodiesel_to_households_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'biodiesel',                             right: 'agriculture',                       gquery: 'biodiesel_to_agriculture_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'biodiesel',                             right: 'transport',                         gquery: 'biodiesel_to_transport_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'biodiesel',                             right: 'industry',                          gquery: 'biodiesel_to_industry_in_liquid_fuels_sankey', color: '#9ACD32'},
          {left: 'biodiesel',                             right: 'export',                            gquery: 'biodiesel_to_export_in_liquid_fuels_sankey', color: '#9ACD32'},

          {left: 'methanol',                              right: 'transport',                         gquery: 'methanol_to_transport_in_liquid_fuels_sankey', color: '#BF8877'},
          {left: 'methanol',                              right: 'industry',                          gquery: 'methanol_to_industry_in_liquid_fuels_sankey', color: '#BF8877'},
          {left: 'methanol',                              right: 'bunkers',                           gquery: 'methanol_to_bunkers_in_liquid_fuels_sankey', color: '#BF8877'},
          {left: 'methanol',                              right: 'export',                            gquery: 'methanol_to_export_in_liquid_fuels_sankey', color: '#BF8877'},

          {left: 'biomethanol',                           right: 'transport',                         gquery: 'biomethanol_to_transport_in_liquid_fuels_sankey', color: '#95B15C'},
          {left: 'biomethanol',                           right: 'bunkers',                           gquery: 'biomethanol_to_bunkers_in_liquid_fuels_sankey', color: '#95B15C'},
          {left: 'biomethanol',                           right: 'industry',                          gquery: 'biomethanol_to_industry_in_liquid_fuels_sankey', color: '#95B15C'},
          {left: 'biomethanol',                           right: 'export',                            gquery: 'biomethanol_to_export_in_liquid_fuels_sankey', color: '#95B15C'},

          {left: 'oil_products',                          right: 'export',                            gquery: 'oil_products_to_export_in_liquid_fuels_sankey', color: '#8B4513'},

          {left: 'refinery_gas',                          right: 'losses',                            gquery: 'refinery_gas_to_losses_in_liquid_fuels_sankey', color: '#DCDCDC'},

          {left: 'bio_ethanol',                           right: 'transport',                         gquery: 'bio_ethanol_to_transport_in_liquid_fuels_sankey', color: '#90EE90'},
          {left: 'bio_ethanol',                           right: 'export',                            gquery: 'bio_ethanol_to_export_in_liquid_fuels_sankey', color: '#90EE90'},

        ]
    agriculture_sankey:
      data:
        nodes: [
          {id: 'network_gas',                     column: 0, label: 'network_gas',                    color: '#7f7f7f'},
          {id: 'biogas',                          column: 0, label: 'biogas',                         color: '#CE8814'},
          {id: 'biomass',                         column: 0, label: 'biomass',                        color: '#2ca02c'},
          {id: 'electricity_grid_left',           column: 0, label: 'electricity_grid',               color: '#1f77b4'},
          {id: 'chps',                            column: 1, label: 'chps',                           color: '#9467bd'},
          {id: 'backup_heater',                   column: 1, label: 'backup_heater',                  color: '#9467bd'},
          {id: 'agriculture',         column: 2, label: 'agriculture',                    color: '#FFD700'},
          {id: 'agriculture',  column: 2, label: 'agriculture',                    color: '#FFD700'},
          {id: 'electricity_grid_right',          column: 2, label: 'electricity_grid',               color: '#1f77b4'},
          {id: 'wasted_heat',                     column: 2, label: 'wasted_heat',                    color: '#d62728'},
          {id: 'conversion_losses',               column: 2, label: 'losses',              color: '#DCDCDC'}
        ]
        links: [
          {left: 'network_gas',                   right: 'chps',                      gquery: 'network_gas_to_chps_in_sankey_agriculture', color: '#7f7f7f'},
          {left: 'network_gas',                   right: 'backup_heater',             gquery: 'network_gas_to_backup_heater_in_sankey_agriculture', color: '#7f7f7f'},
          {left: 'biogas',                        right: 'chps',                      gquery: 'biogas_to_chps_in_sankey_agriculture', color: '#CE8814'},
          {left: 'biomass',                       right: 'chps',                      gquery: 'wood_pellets_to_chps_in_sankey_agriculture_chps', color: '#2ca02c'},

          {left: 'chps',                          right: 'agriculture',   gquery: 'chps_to_local_steam_hot_water_in_sankey_agriculture_chps', color: '#d62728'},
          {left: 'chps',                          right: 'wasted_heat',               gquery: 'chps_to_unused_steam_hot_water_in_sankey_agriculture_chps', color: '#d62728'},
          {left: 'chps',                          right: 'agriculture', gquery: 'chps_to_local_electricity_in_sankey_agriculture', color: '#1f77b4'},
          {left: 'chps',                          right: 'electricity_grid_right',    gquery: 'chps_to_mv_grid_in_sankey_agriculture', color: '#1f77b4'},
          {left: 'chps',                          right: 'conversion_losses',         gquery: 'chps_to_conversion_losses_in_sankey_agriculture', color: '#DCDCDC'},

          {left: 'backup_heater',                 right: 'agriculture',   gquery: 'backup_heater_to_local_steam_hot_water_in_sankey_agriculture', color: '#d62728'},
          {left: 'backup_heater',                 right: 'conversion_losses',         gquery: 'backup_heater_to_conversion_losses_in_sankey_agriculture', color: '#DCDCDC'},

          {left: 'electricity_grid_left',         right: 'agriculture',               gquery: 'mv_grid_to_local_electricity_in_sankey_agriculture', color: '#1f77b4'},
        ]

  # In this chart most positioning is calculated by us. The D3 sankey plugin is
  # cool but not flexible enough
  Node: class extends Backbone.Model
    width: 5
    vertical_margin: 10

    initialize: =>
      @right_links = []
      @left_links = []
      @view = @get 'view'

    # Returns an appropriate spacing given the number of columns. Some values
    # are manually set to squeeze every single pixel
    #
    horizontal_spacing: =>
      return @__horizontal_spacing if @__horizontal_spacing?
      cols = @view.number_of_columns()
      # this should leave enough room for the node labels
      @__horizontal_spacing = (@view.width - (7 * cols)) / (cols - 1)
      @__horizontal_spacing

    # vertical position of the top left corner of the node. Adds some margin
    # between nodes
    y_offset: =>
      offset = 0
      # since the value's going to be scaled, let's invert it to have always the
      # same margin in absolute (=pixel) values
      margin = @view.y.invert(@vertical_margin)
      for n in @siblings()
        break if n == this
        offset += n.value() + (if n.should_show() then margin else 0)
      offset

    x_offset: =>
      return @get('column') * (@width + @horizontal_spacing()) if !@is_last_column()

      # If it's the last column we right align
      @view.width

    x_offset_label: =>
      return @x_offset() if !@is_last_column()

      # If it's the last column we right align
      @view.width - 10 - @width

    # center point of the node. We use it as link anchor point
    x_center: => @x_offset() + @width / 2

    is_last_column: =>
      return @__is_last_column if @__is_last_column?
      @__is_last_column = (@get('column') + 1) == @view.number_of_columns()
      @__is_last_column

    label_classes: =>
      return "label" if !@is_last_column()

      # If it's the last column we right align
      "label last-label"

    # The height of the node is the sum of the height of its link. Since links
    # are both inbound and outbound, let's use the max size. Ideally the values
    # should match
    value: =>
      Math.max(
        d3.sum(@left_links,  (d) -> d.value()),
        d3.sum(@right_links, (d) -> d.value())
      )

    should_show: =>
      _.any(@left_links, (link) -> link.should_show()) ||
        _.any(@right_links, (link) -> link.should_show())

    # returns an array of the other nodes that belong to the same column. This
    # is used by the +y_offset+ method to calculate the right node position
    siblings: =>
      items = _.groupBy(@view.nodes_excluding_loss, (node) -> node.get('column'))
      items[@get 'column']

    label: => @get('label') || @get('id')

  Link: class extends Backbone.Model
    initialize: =>
      @view = @get 'view'
      @series = @view.series
      @left  = @view.node_map[@get('left')]
      @right = @view.node_map[@get('right')]
      if @get('gquery')
        @gquery = new ChartSerie
          gquery_key: @get('gquery')
        @series.push(@gquery)
      # let the nodes know about me
      @left.right_links.push this
      @right.left_links.push this

    # returns the absolute y coordinate of the left anchor point. SVG wants the
    # anchor point of the line middle, so we must take into account the stroke
    # width. This method is ugly and should definitely be simplified
    left_y:  =>
      offset = null
      for link in @left.right_links
        # push down the first link
        if offset == null
          offset = link.value() / 2
          break if link == this
          offset = link.value()
        else
          if link == this
            offset += link.value() / 2
            break
          else
            offset += link.value()
      @left.y_offset() + offset

    right_y:  =>
      offset = null
      for link in @right.left_links
        if offset == null
          offset = link.value() / 2
          break if link == this
          offset = link.value()
        else
          if link == this
            offset += link.value() / 2
            break
          else
            offset += link.value()
      @right.y_offset() + offset

    left_x:  => @left.x_center()  + @left.width / 2
    right_x: => @right.x_center() - @right.width / 2

    # Use 4 points and let D3 interpolate a smooth curve
    path_points: =>
      [
        {x: @left_x(),       y: @left_y()},
        {x: @left_x()  + 50, y: @left_y()},
        {x: @right_x() - 50, y: @right_y()},
        {x: @right_x(),      y: @right_y()}
      ]

    value: =>
      if @gquery
        x = if @view.use_present
          @gquery.present_value()
        else
          @gquery.future_value()
      if (_.isNumber(x))
        # Assume 0 for very small values below 10e-12
        if (Math.abs(x) < 1e-12)
          return 0.0
        else
          return x
      else
        return 0.0

    should_show: =>
      !!@value()

    color: => @get('color') || "steelblue"

    connects: (id) => @get('left') == id || @get('right') == id

  # This is the main chart class
  #
  View: class extends D3ChartView
    initialize: ->
      @series = @model.series
      @key = @model.get('key')
      # ugly but simple and effective. If the chart key name ends with _2010
      # then the chart will be identical to the corresponding 2050 chart but
      # will be using the present values. Otherwise we can add an extra db
      # column.
      if @key.match(/_2010/)
        k = @key.replace /_2010/, ''
        @use_present = true
      else
        k = @key
      @node_map = {}
      @node_list = _.map D3.sankey.charts[k].data.nodes, (n) =>
        node = new D3.sankey.Node(_.extend n, view: this)
        @node_map[n.id] = node
        node

      @nodes_excluding_loss = _.reject @node_list, (n) -> n.id == 'loss'

      @link_list = _.map D3.sankey.charts[k].data.links, (l) =>
        new D3.sankey.Link(_.extend l, view: this)

      # Preprocess: For liquid_fuels, reorder each node's left_links so
      # that incoming links are stacked according to the order of nodes
      # in the previous column. This minimizes crossings for all columns.
      if k == 'liquid_fuels'
        # Build per-column order maps, preserving @node_list order
        column_nodes = {}
        for node in @node_list
          col = node.get('column')
          column_nodes[col] ?= []
          column_nodes[col].push node.id

        column_order = {}
        for own col, ids of column_nodes
          order = {}
          for id, idx in ids
            order[id] = idx
          column_order[col] = order

        # For each node, sort its incoming links (left_links) by the
        # position of the left node within the previous column.
        for node in @node_list
          left_col = node.get('column') - 1
          order_map = column_order[left_col]
          continue unless order_map?
          node.left_links = _.sortBy node.left_links, (l) ->
            ord = order_map[l.get('left')]
            if _.isNumber(ord) then ord else Number.MAX_SAFE_INTEGER
      @value_formatter = (x) -> @main_formatter(maxFrom: 'maxValue')(x)

      @initialize_defaults()

    margins:
      top: 5
      left: 5
      bottom: 5
      right: 10

    # this method is called when we first render the chart. It is called if we
    # want a full chart refresh when the user resizes the browser window, too
    draw: =>
      [@width, @height] = @available_size()

      # scaling method that will be changed dynamically
      @y = d3.scale.linear().domain([0, 5000]).range([0, @height])

      # This is the function that will take care of drawing the links once we've
      # set the base points
      @link_line = d3.svg.line()
        .interpolate("basis")
        .x((d) -> d.x)
        .y((d) -> @y(d.y))

      @svg = @create_svg_container @width, @height * 1.09, @margins

      @links = @draw_links()
      @nodes = @draw_nodes()

      # Let's create a gradient
      defs = @svg.append('svg:defs')
      defs.append('svg:linearGradient')
        .attr('x1', "0%").attr('y1', "0%").attr('x2', "100%").attr('y2', "0%")
        .attr('id', 'loss_gradient').call(
          (g) ->
            g.append('svg:stop').attr('offset', '0%').attr('style', 'stop-color:rgb(250,0,0);stop-opacity:1')
            g.append('svg:stop').attr('offset', '100%').attr('style', 'stop-color:rgb(250,0,0);stop-opacity:0.0')
      )

    max_series_value: ->
      _.max(_.map(@link_list, (link) -> link.value()))

    draw_links: =>
      # links are treated as a group
      links = @svg.selectAll('g.link')
        .data(@link_list, (d) -> d.cid)
        .enter()
        .append("svg:g")
        .attr("class", (l) -> "link #{l.left.get('id')} #{l.right.get('id')}")
      # link path
      links.append("svg:path")
        .style("stroke-width", (link) -> link.value())
        .style("stroke", (link) ->
          if link.connects('loss') then "url('#loss_gradient')" else link.color()
        )
        .style("fill", "none")
        .style("opacity", selectedLinkOpacity)
        .attr("d", (link) => @link_line link.path_points())
      links.on('mouseover', @link_mouseover)
        .on('mouseout', @node_mouseout)
      links

    draw_nodes: =>
      colors = d3.scale.category20()
      nodes = @svg.selectAll("g.node")
        .data(@nodes_excluding_loss, (d) -> d.get('id'))
        .enter()
        .append("g")
        .attr("class", "node")
        .on("mouseover", @node_mouseover)
        .on("mouseout", @node_mouseout)

      nodes.append("svg:rect")
        .attr("x", (d) => d.x_offset())
        .attr("y", (d) => @y(d.y_offset()))
        .attr("fill", (d, i) -> d.get('color') || colors(i))
        .style("stroke", (d, i) -> d3.rgb(d.get('color') || colors(i)).darker(2))
        .style('stroke-width', 1)
        .attr("width", (d) -> d.width)
        .attr("height", (d) => @y d.value())

      nodes.append("svg:text")
        .attr("class", (d) => d.label_classes())
        .attr("x", (d) => d.x_offset_label())
        .attr("dx", 10)
        .attr("dy", 3)
        .attr("y", (d) => @y(d.y_offset() + d.value() / 2) )
        .text((d) -> "#{I18n.t("output_elements.sankey_labels.#{d.label()}")}")
      @setup_tooltips()
      nodes

    is_empty: =>
      _.all(@node_list, (n) -> !n.should_show())

    setup_tooltips: ->
        $("#{@container_selector()} g.node rect").qtip
          content:
            title: -> $(this).parent('g').attr('data-tooltip-title')
            text: -> $(this).parent('g').attr('data-tooltip')
          position:
            my: 'bottom center'
            at: 'top center'
            viewport: $("#{@container_selector()}")
            adjust:
              method: 'flipinvert'

        $("#{@container_selector()} g.link path").qtip
          content: -> $(this).attr('data-tooltip')
          position:
            target: 'mouse'
            my: 'right center'
            at: 'left center'
          style:
            classes: "qtip-tipsy"

    # callbacks
    #
    unselectedLinkOpacity = 0.1
    selectedLinkOpacity = 0.4
    hoverLinkOpacity = 0.7

    node_mouseover: (e) =>
      @svg.selectAll(".link")
        .filter((d) -> !d.connects(e.get 'id'))
        .transition()
        .duration(200)
        .select('path')
        .style("opacity", unselectedLinkOpacity)

    link_mouseover: ->
      d3.select(this)
        .transition()
        .duration(200)
        .select('path')
        .style("opacity", hoverLinkOpacity)

    # this is used as link_mouseout, too
    node_mouseout: ->
      d3.selectAll(".link")
        .transition()
        .duration(200)
        .select('path')
        .style("opacity", selectedLinkOpacity)

    # this method is called every time we're updating the chart
    refresh: =>
      { sum: max_value, nodeCompensation } = @max_column_data(@y)

      # Update the scaling function.
      @y.domain([0, max_value])
        # Remove from the available height space which will be taken up by
        # margins between nodes.
        .range([0, @height - nodeCompensation])

      # update the node label
      @nodes.data(@nodes_excluding_loss, (d) -> d.get('id'))
        .style('opacity', (d) -> if d.should_show() then 1 else 0)
        .attr("data-tooltip", (d) =>
          h = ""
          for l in d.left_links
            if l.value() > 0.0 then h += "<span class='fa fa-arrow-left'></span> #{I18n.t("output_elements.sankey_labels.#{l.left.label()}")}: #{@value_formatter l.value()}<br/>"
          for l in d.right_links
            if l.value() > 0.0 then h += "<span class='fa fa-arrow-right'></span> #{I18n.t("output_elements.sankey_labels.#{l.right.label()}")}: #{@value_formatter l.value()}<br/>"
          h
          )
        .attr("data-tooltip-title", (d) =>
          "#{I18n.t("output_elements.sankey_labels.#{d.label()}")}: #{@value_formatter d.value()}")

      # move the rectangles
      @nodes.selectAll("rect")
        .attr("height", (d) => @y(d.value()))
        .attr("y", (d) => @y(d.y_offset()))

      # then move the node label
      @nodes.selectAll("text.label")
        .attr("y", (d) => @y(d.y_offset() + d.value() / 2) )

      # then transform the links
      @links.data(@link_list, (d) -> d.cid)
        .selectAll("path")
        .attr("d", (link) => @link_line link.path_points())
        .style("stroke-width", (link) => @y(link.value()))
        .attr("display", (link) ->
          if link.should_show() then 'inline' else 'none'
        )
        .attr("data-tooltip", (d) => @value_formatter d.value())

    # returns the height of the tallest column
    max_column_value: =>
      sums = {}
      for n in @node_list
        column = n.get 'column'
        sums[column] = sums[column] || 0
        sums[column] += n.value()
      _.max _.values(sums)

    # Returns an object describing the `sum` of the largest column in the chart,
    # and the number of `nodes` contributing, and a `nodeCompensation` total
    # number of pixels which will be used to separate nodes from one another.
    max_column_data: (axis) =>
      data = []

      for node in @node_list
        if node.should_show()
          column = node.get('column')

          if !data[column]
            data[column] = { sum: 0.0, nodes: 0, nodeCompensation: 0 }

          colData = data[column]

          if colData?
            nodeValue = node.value() || 0
            colData.sum += nodeValue
            colData.nodes += 1

            if colData.nodes > 1
              colData.nodeCompensation += D3.sankey.Node.prototype.vertical_margin
          else
            console.error("Undefined colData for column: ", column)

      validData = _.filter(data, (colData) -> colData?)

      if validData.length == 0
        return { sum: 0, nodeCompensation: 0}

      _.max(validData, (col) -> axis(col.sum) + col.nodeCompensation)

    number_of_columns: =>
      @__column_number ?= d3.max(@nodes_excluding_loss, (n) -> n.get 'column') + 1
