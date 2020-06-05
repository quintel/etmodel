D3.sankey =
  charts:
    sankey_electrical_interconnection:
      data:
        nodes: [
          {id: 'solar',                        column: 0, label: 'solar',                  color: '#ffcc00'},
          {id: 'wind',                         column: 0, label: 'wind',                   color: '#63A1C9'},
          {id: 'biomass_waste',                column: 0, label: 'biomass_waste',          color: '#2ca02c'},
          {id: 'other_renewables',             column: 0, label: 'other_renewables',       color: '#4465c6'},
          {id: 'hydrogen',                     column: 0, label: 'hydrogen',               color: '#27d3d3'},
          {id: 'fossil',                       column: 0, label: 'fossil',                 color: '#252525'},
          {id: 'nuclear',                      column: 0, label: 'uranium',                color: '#ff7f0e'},
          {id: 'import1',                      column: 0, label: 'import1',                color: '#b71540'},
          {id: 'import2',                      column: 0, label: 'import2',                color: '#b71540'},
          {id: 'import3',                      column: 0, label: 'import3',                color: '#b71540'},
          {id: 'import4',                      column: 0, label: 'import4',                color: '#b71540'},
          {id: 'import5',                      column: 0, label: 'import5',                color: '#b71540'},
          {id: 'import6',                      column: 0, label: 'import6',                color: '#b71540'},
          {id: 'network',                      column: 1, label: 'network',                color: '#006266'},
          {id: 'households',                   column: 2, label: 'households',             color: '#4169E1'},
          {id: 'buildings',                    column: 2, label: 'buildings',              color: '#ADD8E6'},
          {id: 'transport',                    column: 2, label: 'transport',              color: '#8B0000'},
          {id: 'industry',                     column: 2, label: 'industry',               color: '#A9A9A9'},
          {id: 'agriculture',                  column: 2, label: 'agriculture',            color: '#FFD700'},
          {id: 'flexibility',                  column: 2, label: 'flexibility',            color: '#013220'},
          {id: 'other',                        column: 2, label: 'other',                  color: '#E07033'},
          {id: 'transport_losses',             column: 2, label: 'transport_losses',       color: '#DCDCDC'},
          {id: 'export1',                      column: 2, label: 'export1',                color: '#43464B'},
          {id: 'export2',                      column: 2, label: 'export2',                color: '#43464B'},
          {id: 'export3',                      column: 2, label: 'export3',                color: '#43464B'},
          {id: 'export4',                      column: 2, label: 'export4',                color: '#43464B'},
          {id: 'export5',                      column: 2, label: 'export5',                color: '#43464B'},
          {id: 'export5',                      column: 2, label: 'export6',                color: '#43464B'}
        ]
        links: [
          {left: 'solar',                      right: 'network',          gquery: 'solar_to_network_in_sankey', color: '#ffcc00'},
          {left: 'wind',                       right: 'network',          gquery: 'wind_to_network_in_sankey', color: '#63A1C9'},
          {left: 'biomass_waste',              right: 'network',          gquery: 'biomass_waste_to_network_in_sankey', color: '#2ca02c'},
          {left: 'other_renewables',           right: 'network',          gquery: 'other_renewables_to_network_in_sankey', color: '#4465c6'},
          {left: 'hydrogen',                   right: 'network',          gquery: 'hydrogen_to_network_in_sankey', color: '#27d3d3'},
          {left: 'fossil',                     right: 'network',          gquery: 'fossil_to_network_in_sankey', color: '#252525'},
          {left: 'nuclear',                    right: 'network',          gquery: 'nuclear_to_network_in_sankey', color: '#ff7f0e'},
          {left: 'import1',                    right: 'network',          gquery: 'import1_to_network_in_sankey', color: '#ff7f0e'},
          {left: 'import2',                    right: 'network',          gquery: 'import2_to_network_in_sankey', color: '#ff7f0e'},
          {left: 'import3',                    right: 'network',          gquery: 'import3_to_network_in_sankey', color: '#ff7f0e'},
          {left: 'import4',                    right: 'network',          gquery: 'import4_to_network_in_sankey', color: '#ff7f0e'},
          {left: 'import5',                    right: 'network',          gquery: 'import5_to_network_in_sankey', color: '#ff7f0e'},
          {left: 'import6',                    right: 'network',          gquery: 'import6_to_network_in_sankey', color: '#ff7f0e'},

          {left: 'network',                    right: 'households',       gquery: 'network_to_households_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'buildings',        gquery: 'network_to_buildings_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'transport',        gquery: 'network_to_transport_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'industry',         gquery: 'network_to_industry_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'agriculture',      gquery: 'network_to_agriculture_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'other',            gquery: 'network_to_other_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'transport_losses', gquery: 'network_to_transport_losses_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'flexibility',      gquery: 'network_to_flexibility_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'export1',          gquery: 'network_to_export1_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'export2',          gquery: 'network_to_export2_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'export3',          gquery: 'network_to_export3_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'export4',          gquery: 'network_to_export4_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'export5',          gquery: 'network_to_export5_in_sankey', color: '#1f77b4'},
          {left: 'network',                    right: 'export6',          gquery: 'network_to_export6_in_sankey', color: '#1f77b4'},
        ]
    biomass_sankey:
      data:
        nodes: [
          {id: 'local',                           column: 0, label: 'local',                     color: '#416B86'},
          {id: 'import',                          column: 0, label: 'import',                    color: '#b71540'},
          {id: 'biogenic_waste',                  column: 1, label: 'biogenic_waste',            color: '#006266'},
          {id: 'wet',                             column: 1, label: 'wet',                       color: '#38ada9'},
          {id: 'oily',                            column: 1, label: 'oily',                      color: '#f9ca24'},
          {id: 'dry',                             column: 1, label: 'dry',                       color: '#009432'},
          {id: 'biogas',                          column: 2, label: 'biogas',                    color: '#ffff99'},
          {id: 'greengas',                        column: 2, label: 'greengas',                  color: '#A3CB38'},
          {id: 'biofuels',                        column: 2, label: 'biofuels',                  color: '#00b894'},
          {id: 'electricity_prod',                column: 3, label: 'electricity_production',    color: '#1f77b4'},
          {id: 'central_heat_prod',               column: 3, label: 'central_heat_production',   color: '#d62728'},
          {id: 'hydrogen_prod',                   column: 3, label: 'hydrogen_production',       color: '#74b9ff'},
          {id: 'electricity_dem',                 column: 4, label: 'electricity_demand',        color: '#0984e3'},
          {id: 'heat_dem',                        column: 4, label: 'heat_demand',               color: '#d63031'},
          {id: 'hydrogen_dem',                    column: 4, label: 'hydrogen_demand',           color: '#82ccdd'},
          {id: 'households',                      column: 4, label: 'households',                color: '#4169E1'},
          {id: 'buildings',                       column: 4, label: 'buildings',                 color: '#ADD8E6'},
          {id: 'transport',                       column: 4, label: 'transport',                 color: '#8B0000'},
          {id: 'industry',                        column: 4, label: 'industry',                  color: '#A9A9A9'},
          {id: 'bunkers',                         column: 4, label: 'bunkers',                   color: '#8B4513'},
          {id: 'agriculture',                     column: 4, label: 'agriculture',               color: '#FFD700'},
          {id: 'other',                           column: 4, label: 'other',                     color: '#E07033'},
          {id: 'export',                          column: 4, label: 'export',                    color: '#43464B'},
          {id: 'losses',                          column: 4, label: 'losses',                    color: '#DCDCDC'}
        ]
        links: [
          {left: 'local',                           right: 'biogenic_waste',              gquery: 'local_biogenic_waste_in_biomass_sankey', color: '#416B86'},
          {left: 'local',                           right: 'wet',                         gquery: 'local_wet_biomass_in_biomass_sankey', color: '#416B86'},
          {left: 'local',                           right: 'oily',                        gquery: 'local_oily_biomass_in_biomass_sankey', color: '#416B86'},
          {left: 'local',                           right: 'dry',                         gquery: 'local_dry_biomass_in_biomass_sankey', color: '#416B86'},
          {left: 'import',                          right: 'biogenic_waste',              gquery: 'import_biogenic_waste_in_biomass_sankey', color: '#b71540'},
          {left: 'import',                          right: 'wet',                         gquery: 'import_wet_biomass_in_biomass_sankey', color: '#b71540'},
          {left: 'import',                          right: 'oily',                        gquery: 'import_oily_biomass_in_biomass_sankey', color: '#b71540'},
          {left: 'import',                          right: 'dry',                         gquery: 'import_dry_biomass_in_biomass_sankey', color: '#b71540'},
          {left: 'wet',                             right: 'biogas',                      gquery: 'wet_biomass_to_biogas_in_biomass_sankey', color: '#38ada9'},
          {left: 'wet',                             right: 'greengas',                    gquery: 'wet_biomass_to_greengas_in_biomass_sankey', color: '#38ada9'},
          {left: 'wet',                             right: 'biofuels',                    gquery: 'wet_biomass_to_biofuels_in_biomass_sankey', color: '#38ada9'},
          {left: 'wet',                             right: 'export',                      gquery: 'wet_biomass_to_export_in_biomass_sankey', color: '#38ada9'},
          {left: 'oily',                            right: 'biofuels',                    gquery: 'oily_biomass_to_biofuels_in_biomass_sankey', color: '#f9ca24'},
          {left: 'oily',                            right: 'export',                      gquery: 'oily_biomass_to_export_in_biomass_sankey', color: '#f9ca24'},
          {left: 'biogenic_waste',                  right: 'electricity_prod',            gquery: 'biogenic_waste_to_electricity_prod_in_biomass_sankey', color: '#006266'},
          {left: 'biogenic_waste',                  right: 'central_heat_prod',           gquery: 'biogenic_waste_to_central_heat_prod_in_biomass_sankey', color: '#006266'},
          {left: 'biogenic_waste',                  right: 'export',                      gquery: 'biogenic_waste_to_export_in_biomass_sankey', color: '#006266'},
          {left: 'electricity_prod',                right: 'electricity_dem',             gquery: 'electricity_prod_to_electricity_dem_in_biomass_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',                right: 'heat_dem',                    gquery: 'electricity_prod_to_heat_dem_in_biomass_sankey', color: '#d62728'},
          {left: 'electricity_prod',                right: 'losses',                      gquery: 'electricity_prod_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'biogas',                          right: 'electricity_prod',            gquery: 'biogas_to_electricity_prod_in_biomass_sankey', color: '#ffff99'},
          {left: 'biogas',                          right: 'losses',                      gquery: 'biogas_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'greengas',                        right: 'electricity_prod',            gquery: 'greengas_to_electricity_prod_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'central_heat_prod',           gquery: 'greengas_to_central_heat_prod_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'hydrogen_prod',               gquery: 'greengas_to_hydrogen_prod_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'households',                  gquery: 'greengas_to_households_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'buildings',                   gquery: 'greengas_to_buildings_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'transport',                   gquery: 'greengas_to_transport_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'industry',                    gquery: 'greengas_to_industry_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'agriculture',                 gquery: 'greengas_to_agriculture_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'other',                       gquery: 'greengas_to_other_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'bunkers',                     gquery: 'greengas_to_bunkers_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'export',                      gquery: 'greengas_to_export_in_biomass_sankey', color: '#A3CB38'},
          {left: 'greengas',                        right: 'losses',                      gquery: 'greengas_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'biofuels',                        right: 'transport',                   gquery: 'biofuels_to_transport_in_biomass_sankey', color: '#00b894'},
          {left: 'biofuels',                        right: 'bunkers',                     gquery: 'biofuels_to_bunkers_in_biomass_sankey', color: '#00b894'},
          {left: 'biofuels',                        right: 'electricity_prod',            gquery: 'biofuels_to_electricity_prod_in_biomass_sankey', color: '#00b894'},
          {left: 'biofuels',                        right: 'losses',                      gquery: 'biofuels_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'central_heat_prod',               right: 'heat_dem',                    gquery: 'central_heat_prod_to_heat_dem_in_biomass_sankey', color: '#d62728'},
          {left: 'central_heat_prod',               right: 'losses',                      gquery: 'central_heat_prod_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'hydrogen_prod',                   right: 'hydrogen_dem',                gquery: 'hydrogen_prod_to_hydrogen_dem_in_biomass_sankey', color: '#74b9ff'},
          {left: 'hydrogen_prod',                   right: 'losses',                      gquery: 'hydrogen_prod_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'dry',                             right: 'greengas',                    gquery: 'dry_biomass_to_greengas_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'electricity_prod',            gquery: 'dry_biomass_to_electricity_prod_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'central_heat_prod',           gquery: 'dry_biomass_to_central_heat_prod_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'hydrogen_prod',               gquery: 'dry_biomass_to_hydrogen_prod_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'households',                  gquery: 'dry_biomass_to_households_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'buildings',                   gquery: 'dry_biomass_to_buildings_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'transport',                   gquery: 'dry_biomass_to_transport_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'industry',                    gquery: 'dry_biomass_to_industry_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'agriculture',                 gquery: 'dry_biomass_to_agriculture_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'other',                       gquery: 'dry_biomass_to_other_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'bunkers',                     gquery: 'dry_biomass_to_bunkers_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'export',                      gquery: 'dry_biomass_to_export_in_biomass_sankey', color: '#009432'},
          {left: 'dry',                             right: 'losses',                      gquery: 'dry_biomass_to_losses_in_biomass_sankey', color: '#DCDCDC'},
          {left: 'dry',                             right: 'biofuels',                    gquery: 'dry_biomass_to_biofuels_in_biomass_sankey', color: '#009432'}
        ]

    co2_sankey:
      data:
        nodes: [
          {id: 'coal',                            column: 0, label: 'coal',                    color: '#252525'},
          {id: 'gas',                             column: 0, label: 'gas',                     color: '#416B86'},
          {id: 'oil',                             column: 0, label: 'oil',                     color: '#854321'},
          {id: 'households',                      column: 1, label: 'households'},
          {id: 'buildings',                       column: 1, label: 'buildings'},
          {id: 'transport',                       column: 1, label: 'transport'},
          {id: 'bunkers',                         column: 1, label: 'bunkers'},
          {id: 'industry',                        column: 1, label: 'industry',                color: '#854321'},
          {id: 'agriculture',                     column: 1, label: 'agriculture',             color: '#446600'},
          {id: 'energy',                          column: 1, label: 'energy',                  color: '#73264d'},
          {id: 'other',                           column: 1, label: 'other'},
          {id: 'emitted',                         column: 2, label: 'emitted',                 color: '#d62728'},
          {id: 'captured',                        column: 2, label: 'captured',                color: '#2ca02c'}
        ]
        links: [
          {left: 'coal',                          right: 'households',               gquery: 'households_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'gas',                           right: 'households',               gquery: 'households_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'households',               gquery: 'households_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'coal',                          right: 'buildings',                gquery: 'buildings_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'gas',                           right: 'buildings',                gquery: 'buildings_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'buildings',                gquery: 'buildings_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'coal',                          right: 'transport',                gquery: 'transport_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'gas',                           right: 'transport',                gquery: 'transport_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'transport',                gquery: 'transport_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'gas',                           right: 'bunkers',                  gquery: 'bunkers_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'bunkers',                  gquery: 'bunkers_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'coal',                          right: 'industry',                 gquery: 'industry_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'gas',                           right: 'industry',                 gquery: 'industry_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'industry',                 gquery: 'industry_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'gas',                           right: 'agriculture',              gquery: 'agriculture_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'agriculture',              gquery: 'agriculture_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'coal',                          right: 'other',                    gquery: 'other_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'gas',                           right: 'other',                    gquery: 'other_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'other',                    gquery: 'other_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'coal',                          right: 'energy',                   gquery: 'energy_coal_total_in_co2_sankey', color: '#252525'},
          {left: 'gas',                           right: 'energy',                   gquery: 'energy_gas_total_in_co2_sankey', color: '#416B86'},
          {left: 'oil',                           right: 'energy',                   gquery: 'energy_oil_total_in_co2_sankey', color: '#854321'},
          {left: 'coal',                          right: 'energy',                   gquery: 'energy_coal_captured_in_co2_sankey', color: '#2ca02c'},
          {left: 'gas',                           right: 'energy',                   gquery: 'energy_gas_captured_in_co2_sankey', color: '#2ca02c'},
          {left: 'oil',                           right: 'energy',                   gquery: 'energy_oil_captured_in_co2_sankey', color: '#2ca02c'},
          {left: 'households',                    right: 'emitted',                  gquery: 'households_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'buildings',                     right: 'emitted',                  gquery: 'buildings_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'transport',                     right: 'emitted',                  gquery: 'transport_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'bunkers',                       right: 'emitted',                  gquery: 'bunkers_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'industry',                      right: 'emitted',                  gquery: 'industry_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'agriculture',                   right: 'emitted',                  gquery: 'agriculture_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'other',                         right: 'emitted',                  gquery: 'other_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'energy',                        right: 'emitted',                  gquery: 'energy_emitted_in_co2_sankey', color: '#8B0000'},
          {left: 'energy',                        right: 'captured',                 gquery: 'energy_captured_in_co2_sankey', color: '#2ca02c'}
        ]
    sankey:
      data:
        nodes: [
          {id: 'coal_and_derivatives',         column: 0, label: 'coal',                   color: '#252525'},
          {id: 'oil_and_derivatives',          column: 0, label: 'oil',                    color: '#8c564b'},
          {id: 'natural_gas',                  column: 0, label: 'gas',                    color: '#7f7f7f'},
          {id: 'solar',                        column: 0, label: 'solar',                  color: '#ffcc00'},
          {id: 'wind',                         column: 0, label: 'wind',                   color: '#63A1C9'},
          {id: 'biomass_products',             column: 0, label: 'biomass_waste',          color: '#2ca02c'},
          {id: 'geo_ambient',                  column: 0, label: 'geo_ambient',            color: '#787821'},
          {id: 'water',                        column: 0, label: 'water',                  color: '#4465c6'},
          {id: 'nuclear',                      column: 0, label: 'uranium',                color: '#ff7f0e'},
          {id: 'imported_heat',                column: 0, label: 'imported_heat',          color: '#cc0000'},
          {id: 'imported_electricity',         column: 0, label: 'imported_electricity',   color: '#1f77b4'},
          {id: 'imported_hydrogen',            column: 0, label: 'imported_hydrogen',      color: '#27d3d3'},
          {id: 'electricity_prod',             column: 1, label: 'electricity_production', color: '#1f77b4'},
          {id: 'hydrogen_prod',                column: 1, label: 'hydrogen_production',    color: '#27d3d3'},
          {id: 'p2p',                          column: 2, label: 'p2p',                    color: '#a29bfe'},
          {id: 'p2h',                          column: 2, label: 'p2h',                    color: '#6c5ce7'},
          {id: 'p2g',                          column: 2, label: 'p2g',                    color: '#6c5ce7'},
          {id: 'p2l',                          column: 2, label: 'p2l',                    color: '#e84393'},
          {id: 'central_heat_prod',            column: 1, label: 'central_heat_production', color: '#9467bd'},
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
          {left: 'imported_hydrogen',             right: 'electricity_prod', gquery: 'imported_hydrogen_to_electricity_prod_in_sankey', color: '#27d3d3'},
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
          {left: 'imported_hydrogen',             right: 'hydrogen_prod',    gquery: 'hydrogen_import_to_hydrogen_prod_in_sankey', color: '#27d3d3'},
          {left: 'water',                         right: 'hydrogen_prod',    gquery: 'water_to_hydrogen_prod_in_sankey', color: '#4465c6'},

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
          {left: 'solar',                         right: 'central_heat_prod', gquery: 'solar_to_central_heat_prod_in_sankey', color: '#ffcc00'},

          {left: 'hydrogen_prod',                 right: 'electricity_prod', gquery: 'hydrogen_prod_to_electricity_prod_in_sankey', color: '#27d3d3'},

          {left: 'electricity_prod',              right: 'central_heat_prod', gquery: 'electricity_prod_to_central_heat_prod_in_sankey', color: '#1f77b4'},
          {left: 'hydrogen_prod',                 right: 'central_heat_prod', gquery: 'hydrogen_prod_to_central_heat_prod_in_sankey', color: '#27d3d3'},

          {left: 'electricity_prod',              right: 'households',       gquery: 'electricity_prod_to_households_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'buildings',        gquery: 'electricity_prod_to_buildings_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'transport',        gquery: 'electricity_prod_to_transport_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'industry',         gquery: 'electricity_prod_to_industry_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'feedstock',         gquery: 'electricity_prod_to_feedstock_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'agriculture',      gquery: 'electricity_prod_to_agriculture_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'energy',           gquery: 'electricity_prod_to_energy_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'other',            gquery: 'electricity_prod_to_other_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'export',           gquery: 'electricity_prod_to_export_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2p',              gquery: 'electricity_prod_to_p2p_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2h',              gquery: 'electricity_prod_to_p2h_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2g',              gquery: 'electricity_prod_to_p2g_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'p2l',              gquery: 'electricity_prod_to_p2l_in_sankey', color: '#1f77b4'},

          {left: 'electricity_prod',              right: 'households',       gquery: 'chp_heat_prod_to_households_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'buildings',        gquery: 'chp_heat_prod_to_buildings_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'transport',        gquery: 'chp_heat_prod_to_transport_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'industry',         gquery: 'chp_heat_prod_to_industry_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'feedstock',        gquery: 'chp_heat_prod_to_feedstock_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'agriculture',      gquery: 'chp_heat_prod_to_agriculture_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'energy',           gquery: 'chp_heat_prod_to_energy_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'other',            gquery: 'chp_heat_prod_to_other_in_sankey', color: '#d62728'},

          {left: 'electricity_prod',              right: 'conversion_losses', gquery: 'electricity_prod_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'electricity_prod',              right: 'transport_losses', gquery: 'electricity_prod_to_transport_loss_in_sankey', color: '#DCDCDC'},

          {left: 'hydrogen_prod',                 right: 'households',       gquery: 'hydrogen_prod_to_households_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'buildings',        gquery: 'hydrogen_prod_to_buildings_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'transport',        gquery: 'hydrogen_prod_to_transport_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'industry',         gquery: 'hydrogen_prod_to_industry_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'feedstock',        gquery: 'hydrogen_prod_to_feedstock_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'agriculture',      gquery: 'hydrogen_prod_to_agriculture_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'energy',           gquery: 'hydrogen_prod_to_energy_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'other',            gquery: 'hydrogen_prod_to_other_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'export',           gquery: 'hydrogen_prod_to_export_in_sankey', color: '#27d3d3'},
          {left: 'hydrogen_prod',                 right: 'conversion_losses', gquery: 'hydrogen_prod_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'hydrogen_prod',                 right: 'transport_losses', gquery: 'hydrogen_prod_to_transport_loss_in_sankey', color: '#DCDCDC'},

          {left: 'central_heat_prod',             right: 'households',       gquery: 'central_heat_prod_to_households_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'buildings',        gquery: 'central_heat_prod_to_buildings_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'transport',        gquery: 'central_heat_prod_to_transport_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'industry',         gquery: 'central_heat_prod_to_industry_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'feedstock',        gquery: 'central_heat_prod_to_feedstock_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'agriculture',      gquery: 'central_heat_prod_to_agriculture_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'energy',           gquery: 'central_heat_prod_to_energy_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'other',            gquery: 'central_heat_prod_to_other_in_sankey', color: '#d62728'},
          {left: 'central_heat_prod',             right: 'conversion_losses', gquery: 'central_heat_prod_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'central_heat_prod',             right: 'transport_losses',  gquery: 'central_heat_prod_to_transport_loss_in_sankey', color: '#DCDCDC'},

          {left: 'p2p',                           right: 'electricity_prod', gquery: 'p2p_to_electricity_prod_in_sankey', color: '#1f77b4'},
          {left: 'p2p',                           right: 'conversion_losses', gquery: 'p2p_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'p2h',                           right: 'households',       gquery: 'p2h_to_households_in_sankey',       color: '#d62728'},
          {left: 'p2h',                           right: 'industry',         gquery: 'p2h_to_industry_in_sankey',         color: '#d62728'},
          {left: 'p2h',                           right: 'conversion_losses', gquery: 'p2h_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'p2g',                           right: 'hydrogen_prod',     gquery: 'p2g_to_hydrogen_prod_in_sankey',   color: '#27d3d3'},
          {left: 'p2g',                           right: 'p2l',               gquery: 'p2g_to_p2l_in_sankey',             color: '#27d3d3'},
          {left: 'p2g',                           right: 'conversion_losses', gquery: 'p2g_to_conversion_loss_in_sankey', color: '#DCDCDC'},
          {left: 'p2l',                           right: 'bunkers',          gquery: 'p2l_to_bunkers_in_sankey',          color: '#8c564b'},
          {left: 'p2l',                           right: 'export',           gquery: 'p2l_to_export_in_sankey',           color: '#8c564b'},
          {left: 'p2l',                           right: 'conversion_losses', gquery: 'p2l_to_conversion_loss_in_sankey', color: '#DCDCDC'},

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
          {left: 'natural_gas',                   right: 'industry',         gquery: 'natural_gas_to_industry_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'feedstock',        gquery: 'natural_gas_to_feedstock_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'agriculture',      gquery: 'natural_gas_to_agriculture_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'energy',           gquery: 'natural_gas_to_energy_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'other',            gquery: 'natural_gas_to_other_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'export',           gquery: 'natural_gas_to_export_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'p2l',              gquery: 'natural_gas_to_p2l_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'transport_losses', gquery: 'natural_gas_to_transport_losses_in_sankey', color: '#7f7f7f'},

          {left: 'solar',                         right: 'households',       gquery: 'solar_to_households_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'buildings',        gquery: 'solar_to_buildings_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'transport',        gquery: 'solar_to_transport_in_sankey', color: '#ffcc00'},
          {left: 'solar',                         right: 'energy',          gquery: 'solar_to_energy_in_sankey', color: '#ffcc00'},
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

          #{left: 'geo_ambient',                   right: 'households',       gquery: 'geo_ambient_to_households_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'buildings',        gquery: 'geo_ambient_to_buildings_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'transport',        gquery: 'geo_ambient_to_transport_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'industry',         gquery: 'geo_ambient_to_industry_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'agriculture',      gquery: 'geo_ambient_to_agriculture_in_sankey', color: '#2ca02c'},
          #{left: 'geo_ambient',                   right: 'other',            gquery: 'geo_ambient_to_other_in_sankey', color: '#2ca02c'},

        ]
    refinery:
      data:
        nodes: [
          {id: 'oil_import',                      column: 0, label: 'oil_import',             color: '#854321'},
          {id: 'extraction',                      column: 0, label: 'extraction',             color: '#854321'},
          {id: 'heat_input',                      column: 0, label: 'heat_input',             color: '#d62728'},
          {id: 'fuel_import',                     column: 0, label: 'fuel_import',            color: '#854321'},
          {id: 'refinery',                        column: 1, label: 'refinery',               color: '#854321'},
          {id: 'distribution_diesel',             column: 2, label: 'distribution_diesel',    color: '#854321'},
          {id: 'distribution_gasoline',           column: 2, label: 'distribution_gasoline',  color: '#8B0000'},
          {id: 'distribution_lpg',                column: 2, label: 'distribution_lpg',       color: '#CCCCCC'},
          {id: 'distribution_hfo',                column: 2, label: 'distribution_hfo',       color: '#BA7D40'},
          {id: 'distribution_kerosene',           column: 2, label: 'distribution_kerosene',  color: '#BFEFFF'},
          {id: 'distribution_oil_products',       column: 2, label: 'distribution_oil_products', color: '#854321'},
          {id: 'distribution_refinery_gas',       column: 2, label: 'distribution_refinery_gas', color: '#7f7f7f'},
          {id: 'loss',                            column: 2},
          {id: 'transport',                       column: 3, label: 'transport'},
          {id: 'bunkers',                         column: 3, label: 'bunkers'},
          {id: 'energy',                          column: 3, label: 'energy'},
          {id: 'industry',                        column: 3, label: 'industry'},
          {id: 'export',                          column: 3, label: 'export'}
        ]
        links: [
          {left: 'oil_import',                    right: 'refinery',                 gquery: 'crude_oil_import_to_refinery_in_sankey', color: '#854321'},
          {left: 'extraction',                    right: 'refinery',                 gquery: 'crude_oil_extraction_to_refinery_in_sankey', color: '#854321'},
          {left: 'heat_input',                    right: 'refinery',                 gquery: 'refinery_heat_input_in_sankey', color: '#d62728'},
          {left: 'refinery',                      right: 'distribution_diesel',      gquery: 'diesel_refinery_to_distribution_in_sankey', color: '#854321'},
          {left: 'refinery',                      right: 'distribution_gasoline',    gquery: 'gasoline_refinery_to_distribution_in_sankey', color: '#8B0000'},
          {left: 'refinery',                      right: 'distribution_lpg',         gquery: 'lpg_refinery_to_distribution_in_sankey', color: '#CCCCCC'},
          {left: 'refinery',                      right: 'distribution_hfo',         gquery: 'hfo_refinery_to_distribution_in_sankey', color: '#BA7D40'},
          {left: 'refinery',                      right: 'distribution_kerosene',    gquery: 'kerosene_refinery_to_distribution_in_sankey', color: '#BFEFFF'},
          {left: 'refinery',                      right: 'distribution_oil_products',gquery: 'oil_products_refinery_to_distribution_in_sankey', color: '#854321'},
          {left: 'refinery',                      right: 'distribution_refinery_gas',gquery: 'refinery_gas_refinery_to_distribution_in_sankey', color: '#7f7f7f'},
          {left: 'refinery',                      right: 'loss',                     gquery: 'refinery_loss_in_sankey', color: '#416B86'},
          {left: 'fuel_import',                   right: 'distribution_diesel',      gquery: 'diesel_import_to_distribution_in_sankey', color: '#854321'},
          {left: 'fuel_import',                   right: 'distribution_gasoline',    gquery: 'gasoline_import_to_distribution_in_sankey', color: '#8B0000'},
          {left: 'fuel_import',                   right: 'distribution_lpg',         gquery: 'lpg_import_to_distribution_in_sankey', color: '#CCCCCC'},
          {left: 'fuel_import',                   right: 'distribution_hfo',         gquery: 'hfo_import_to_distribution_in_sankey', color: '#BA7D40'},
          {left: 'fuel_import',                   right: 'distribution_kerosene',    gquery: 'kerosene_import_to_distribution_in_sankey', color: '#7f7f7f'},
          {left: 'fuel_import',                   right: 'distribution_oil_products',gquery: 'oil_products_import_to_distribution_in_sankey', color: '#854321'},
          {left: 'distribution_diesel',           right: 'transport',                gquery: 'diesel_distribution_to_transport_in_sankey', color: '#854321'},
          {left: 'distribution_diesel',           right: 'energy',                   gquery: 'diesel_distribution_to_energy_in_sankey', color: '#854321'},
          {left: 'distribution_diesel',           right: 'export',                   gquery: 'diesel_distribution_to_export_in_sankey', color: '#854321'},
          {left: 'distribution_gasoline',         right: 'transport',                gquery: 'gasoline_distribution_to_transport_in_sankey', color: '#8B0000'},
          {left: 'distribution_gasoline',         right: 'export',                   gquery: 'gasoline_distribution_to_export_in_sankey', color: '#8B0000'},
          {left: 'distribution_lpg',              right: 'transport',                gquery: 'lpg_distribution_to_transport_in_sankey', color: '#CCCCCC'},
          {left: 'distribution_lpg',              right: 'export',                   gquery: 'lpg_distribution_to_export_in_sankey', color: '#CCCCCC'},
          {left: 'distribution_hfo',              right: 'transport',                gquery: 'hfo_distribution_to_transport_in_sankey', color: '#BA7D40'},
          {left: 'distribution_hfo',              right: 'bunkers',                  gquery: 'hfo_distribution_to_bunkers_in_sankey', color: '#BA7D40'},
          {left: 'distribution_hfo',              right: 'export',                   gquery: 'hfo_distribution_to_export_in_sankey', color: '#BA7D40'},
          {left: 'distribution_kerosene',         right: 'transport',                gquery: 'kerosene_distribution_to_transport_in_sankey', color: '#BFEFFF'},
          {left: 'distribution_kerosene',         right: 'bunkers',                  gquery: 'kerosene_distribution_to_bunkers_in_sankey', color: '#BFEFFF'},
          {left: 'distribution_kerosene',         right: 'export',                   gquery: 'kerosene_distribution_to_export_in_sankey', color: '#BFEFFF'},
          {left: 'distribution_oil_products',     right: 'industry',                 gquery: 'oil_products_distribution_to_industry_in_sankey', color: '#854321'},
          {left: 'distribution_oil_products',     right: 'export',                   gquery: 'oil_products_distribution_to_export_in_sankey', color: '#854321'},
          {left: 'distribution_refinery_gas',     right: 'industry',                 gquery: 'refinery_gas_distribution_to_industry_in_sankey', color: '#7f7f7f'}
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
      @__horizontal_spacing = (@view.width - (25 * cols)) / (cols - 1)
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
        offset += n.value() + margin
      offset

    x_offset: => @get('column') * (@width + @horizontal_spacing())

    # center point of the node. We use it as link anchor point
    x_center: => @x_offset() + @width / 2

    # The height of the node is the sum of the height of its link. Since links
    # are both inbound and outbound, let's use the max size. Ideally the values
    # should match
    value: =>
      Math.max(
        d3.sum(@left_links,  (d) -> d.value()),
        d3.sum(@right_links, (d) -> d.value())
      )

    # returns an array of the other nodes that belong to the same column. This
    # is used by the +y_offset+ method to calculate the right node position
    siblings: =>
      items = _.groupBy(@view.node_list, (node) -> node.get('column'))
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
      if _.isNumber(x) then x else 0.0

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

      # scaling method taht will be changed dynamically
      @y = d3.scale.linear().domain([0, 5000]).range([0, @height])

      # This is the function that will take care of drawing the links once we've
      # set the base points
      @link_line = d3.svg.line()
        .interpolate("basis")
        .x((d) -> d.x)
        .y((d) -> @y(d.y))

      @svg = @create_svg_container @width, @height, @margins

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
        .attr("class", "label")
        .attr("x", (d) => d.x_offset())
        .attr("dx", 10)
        .attr("dy", 3)
        .attr("y", (d) => @y(d.y_offset() + d.value() / 2) )
        .text((d) -> "#{I18n.t("output_elements.sankey_labels.#{d.label()}")}")
      @setup_tooltips()
      nodes

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
          if link.value() == 0.0 then 'none' else 'inline'
        )
        .attr("data-tooltip", (d) => @value_formatter d.value())

    # returns the height of the tallest column
    max_column_value: =>
      sums = {}
      for n in @nodes_excluding_loss
        column = n.get 'column'
        sums[column] = sums[column] || 0
        sums[column] += n.value()
      _.max _.values(sums)

    # Returns an object describing the `sum` of the largest column in the chart,
    # and the number of `nodes` contributing, and a `nodeCompensation` total
    # number of pixels which will be used to separate nodes from one another.
    max_column_data: (axis) =>
      data = []

      for node in @nodes_excluding_loss
        column = node.get('column')

        data[column] ||= { sum: 0.0, nodes: 0, nodeCompensation: 0 }

        colData = data[column]
        colData.sum += node.value()
        colData.nodes += 1

        if colData.nodes > 1
          colData.nodeCompensation += D3.sankey.Node.prototype.vertical_margin

      _.max(data, (col) -> axis(col.sum) + col.nodeCompensation)

    number_of_columns: =>
      @__column_number ?= d3.max(@nodes_excluding_loss, (n) -> n.get 'column') + 1
