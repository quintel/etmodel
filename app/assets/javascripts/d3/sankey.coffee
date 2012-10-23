D3.sankey =
  charts:
    primary_final_useful_demand:
      data :
        nodes: [
          {id: 'coal_and_derivatives',          column: 0, label: "coal", color: '#252525'},
          {id: 'oil_and_derivatives',           column: 0, label: "oil",  color: "#7F2704"},
          {id: 'natural_gas',                   column: 0, label: "gas", color: '#F0F0F0'},
          {id: 'nuclear',                       column: 0, label: "nuclear", color: '#FD8D3C'},
          {id: 'biomass_products',              column: 0, label: "biomass", color: '#2ca02c'},
          {id: 'electricity',                   column: 0, label: "renewable electricity", color: '#1f77b4'},
          {id: 'imported_electricity',          column: 0, label: "imported electricity", color: '#1f77b4'},
          {id: 'households',                    column: 1},
          {id: 'buildings',                     column: 1},
          {id: 'agriculture',                   column: 1},
          {id: 'transport',                     column: 1},
          {id: 'industry',                      column: 1},
          {id: 'other',                         column: 1},
          {id: 'exported_electricity',          column: 1},
          {id: 'useful_demand_electric',        column: 2, label: "electricity"},
          {id: 'useful_demand_heat_cold',       column: 2, label: "heat/cold"},
          {id: 'useful_demand_transport',       column: 2, label: "transport"},
          {id: 'useful_demand_non_energetic',   column: 2, label: "non-energetic"}
        ]
        links: [
          {left: 'coal_and_derivatives',      right: 'households',                  gquery: 'coal_and_derivatives_to_households_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'households',                  gquery: 'oil_and_derivatives_to_households_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'households',                  gquery: 'natural_gas_to_households_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'households',                  gquery: 'nuclear_to_households_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'biomass_products',          right: 'households',                  gquery: 'biomass_products_to_households_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'households',                  gquery: 'imported_electricity_to_households_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'households',                  gquery: 'electricity_to_households_in_sankey_ufp', color: '#1f77b4'},
          {left: 'coal_and_derivatives',      right: 'buildings',                   gquery: 'coal_and_derivatives_to_buildings_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'buildings',                   gquery: 'oil_and_derivatives_to_buildings_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'buildings',                   gquery: 'natural_gas_to_buildings_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'buildings',                   gquery: 'nuclear_to_buildings_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'biomass_products',          right: 'buildings',                   gquery: 'biomass_products_to_buildings_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'buildings',                   gquery: 'imported_electricity_to_buildings_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'buildings',                   gquery: 'electricity_to_buildings_in_sankey_ufp', color: '#1f77b4'},
          {left: 'coal_and_derivatives',      right: 'agriculture',                 gquery: 'coal_and_derivatives_to_agriculture_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'agriculture',                 gquery: 'oil_and_derivatives_to_agriculture_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'agriculture',                 gquery: 'natural_gas_to_agriculture_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'agriculture',                 gquery: 'nuclear_to_agriculture_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'biomass_products',          right: 'agriculture',                 gquery: 'biomass_products_to_agriculture_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'agriculture',                 gquery: 'imported_electricity_to_agriculture_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'agriculture',                 gquery: 'electricity_to_agriculture_in_sankey_ufp', color: '#1f77b4'},
          {left: 'coal_and_derivatives',      right: 'transport',                   gquery: 'coal_and_derivatives_to_transport_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'transport',                   gquery: 'oil_and_derivatives_to_transport_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'transport',                   gquery: 'natural_gas_to_transport_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'transport',                   gquery: 'nuclear_to_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'biomass_products',          right: 'transport',                   gquery: 'biomass_products_to_transport_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'transport',                   gquery: 'imported_electricity_to_transport_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'transport',                   gquery: 'electricity_to_transport_in_sankey_ufp', color: '#1f77b4'},
          {left: 'coal_and_derivatives',      right: 'industry',                    gquery: 'coal_and_derivatives_to_industry_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'industry',                    gquery: 'oil_and_derivatives_to_industry_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'industry',                    gquery: 'natural_gas_to_industry_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'industry',                    gquery: 'nuclear_to_industry_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'biomass_products',          right: 'industry',                    gquery: 'biomass_products_to_industry_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'industry',                    gquery: 'imported_electricity_to_industry_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'industry',                    gquery: 'electricity_to_industry_in_sankey_ufp', color: '#1f77b4'},
          {left: 'coal_and_derivatives',      right: 'other',                       gquery: 'coal_and_derivatives_to_other_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'other',                       gquery: 'oil_and_derivatives_to_other_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'other',                       gquery: 'natural_gas_to_other_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'other',                       gquery: 'nuclear_to_other_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'biomass_products',          right: 'other',                       gquery: 'biomass_products_to_other_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'other',                       gquery: 'imported_electricity_to_other_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'other',                       gquery: 'electricity_to_other_in_sankey_ufp', color: '#1f77b4'},
          {left: 'households',                right: 'useful_demand_electric',      gquery: 'households_to_useful_demand_electric_in_sankey_ufp', color: '#1f77b4'},
          {left: 'households',                right: 'useful_demand_heat_cold',     gquery: 'households_to_useful_demand_heat_cold_in_sankey_ufp', color: '#d62728'},
          {left: 'households',                right: 'useful_demand_transport',     gquery: 'households_to_useful_demand_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'households',                right: 'useful_demand_non_energetic', gquery: 'households_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
          {left: 'buildings',                 right: 'useful_demand_electric',      gquery: 'buildings_to_useful_demand_electric_in_sankey_ufp', color: '#1f77b4'},
          {left: 'buildings',                 right: 'useful_demand_heat_cold',     gquery: 'buildings_to_useful_demand_heat_cold_in_sankey_ufp', color: '#d62728'},
          {left: 'buildings',                 right: 'useful_demand_transport',     gquery: 'buildings_to_useful_demand_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'buildings',                 right: 'useful_demand_non_energetic', gquery: 'buildings_to_useful_demand_non_energetic_in_sankey_ufp', color: '#1f77b4'},
          {left: 'agriculture',               right: 'useful_demand_electric',      gquery: 'agriculture_to_useful_demand_electric_in_sankey_ufp', color: '#1f77b4'},
          {left: 'agriculture',               right: 'useful_demand_heat_cold',     gquery: 'agriculture_to_useful_demand_heat_cold_in_sankey_ufp', color: '#d62728'},
          {left: 'agriculture',               right: 'useful_demand_transport',     gquery: 'agriculture_to_useful_demand_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'agriculture',               right: 'useful_demand_non_energetic', gquery: 'agriculture_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
          {left: 'transport',                 right: 'useful_demand_electric',      gquery: 'transport_to_useful_demand_electric_in_sankey_ufp', color: '#1f77b4'},
          {left: 'transport',                 right: 'useful_demand_heat_cold',     gquery: 'transport_to_useful_demand_heat_cold_in_sankey_ufp', color: '#d62728'},
          {left: 'transport',                 right: 'useful_demand_transport',     gquery: 'transport_to_useful_demand_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'transport',                 right: 'useful_demand_non_energetic', gquery: 'transport_to_useful_demand_non_energetic_in_sankey_ufp', color: '#1f77b4'},
          {left: 'industry',                  right: 'useful_demand_electric',      gquery: 'industry_to_useful_demand_electric_in_sankey_ufp', color: '#1f77b4'},
          {left: 'industry',                  right: 'useful_demand_heat_cold',     gquery: 'industry_to_useful_demand_heat_cold_in_sankey_ufp', color: '#d62728'},
          {left: 'industry',                  right: 'useful_demand_transport',     gquery: 'industry_to_useful_demand_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'industry',                  right: 'useful_demand_non_energetic', gquery: 'industry_to_useful_demand_non_energetic_in_sankey_ufp', color: 'black'},
          {left: 'other',                     right: 'useful_demand_electric',      gquery: 'other_to_useful_demand_electric_in_sankey_ufp', color: '#1f77b4'},
          {left: 'other',                     right: 'useful_demand_heat_cold',     gquery: 'other_to_useful_demand_heat_cold_in_sankey_ufp', color: '#d62728'},
          {left: 'other',                     right: 'useful_demand_transport',     gquery: 'other_to_useful_demand_transport_in_sankey_ufp', color: '#ff7f0e'},
          {left: 'other',                     right: 'useful_demand_non_energetic', gquery: 'other_to_useful_demand_non_energetic_in_sankey_ufp', color: '#1f77b4'},
          {left: 'coal_and_derivatives',      right: 'exported_electricity',        gquery: 'coal_and_derivatives_to_exported_electricity_in_sankey_ufp', color: '#252525'},
          {left: 'oil_and_derivatives',       right: 'exported_electricity',        gquery: 'oil_and_derivatives_to_exported_electricity_in_sankey_ufp', color: '#8c564b'},
          {left: 'natural_gas',               right: 'exported_electricity',        gquery: 'natural_gas_to_exported_electricity_in_sankey_ufp', color: '#7f7f7f'},
          {left: 'nuclear',                   right: 'exported_electricity',        gquery: 'nuclear_to_exported_electricity_in_sankey_ufp', color: '#1f77b4'},
          {left: 'biomass_products',          right: 'exported_electricity',        gquery: 'biomass_products_to_exported_electricity_in_sankey_ufp', color: '#2ca02c'},
          {left: 'imported_electricity',      right: 'exported_electricity',        gquery: 'imported_electricity_to_exported_electricity_in_sankey_ufp', color: '#1f77b4'},
          {left: 'electricity',               right: 'exported_electricity',        gquery: 'electricity_to_exported_electricity_in_sankey_ufp', color: '#1f77b4'}
        ]
    sankey:
      data:
        nodes: [
          {id: 'coal_and_derivatives',         column: 0, label: 'coal',                   color: '#252525'},
          {id: 'oil_and_derivatives',          column: 0, label: 'oil',                    color: '#8c564b'},
          {id: 'geo_solar_wind_water_ambient', column: 0, label: "renewable",              color: '#2ca02c'},
          {id: 'natural_gas',                  column: 0, label: "gas",                    color: '#7f7f7f'},
          {id: 'nuclear',                      column: 0, label: "uranium",                color: '#ff7f0e'},
          {id: 'biomass_products',             column: 0, label: "biomass & waste",        color: '#2ca02c'},
          {id: 'import',                       column: 0, label: "electricity import",     color: '#1f77b4'},
          {id: 'electricity_prod',             column: 1, label: "electricity production", color: '#1f77b4'},
          {id: 'chps',                         column: 1, label: "CHPs",                   color: '#9467bd'},
          {id: 'households',                   column: 2},
          {id: 'buildings',                    column: 2},
          {id: 'transport',                    column: 2},
          {id: 'industry',                     column: 2},
          {id: 'agriculture',                  column: 2},
          {id: 'other',                        column: 2},
          {id: 'exported_electricity',         column: 2, label: 'export', color: '#1f77b4'},
          {id: 'loss',                         column: 2}
        ]
        links: [
          {left: 'coal_and_derivatives',          right: 'electricity_prod', gquery: 'coal_and_derivatives_to_electricity_prod_in_sankey', color: '#252525'},
          {left: 'oil_and_derivatives',           right: 'electricity_prod', gquery: 'oil_and_derivatives_to_electricity_prod_in_sankey', color: '#8c564b'},
          {left: 'geo_solar_wind_water_ambient',  right: 'electricity_prod', gquery: 'geo_solar_wind_water_ambient_to_electricity_prod_in_sankey', color: '#2ca02c'},
          {left: 'natural_gas',                   right: 'electricity_prod', gquery: 'natural_gas_to_electricity_prod_in_sankey', color: '#7f7f7f'},
          {left: 'nuclear',                       right: 'electricity_prod', gquery: 'nuclear_to_electricity_prod_in_sankey', color: '#ff7f0e'},
          {left: 'biomass_products',              right: 'electricity_prod', gquery: 'biomass_products_to_electricity_prod_in_sankey', color: '#2ca02c'},
          {left: 'coal_and_derivatives',          right: 'chps',             gquery: 'coal_and_derivatives_to_chps_prod_in_sankey', color: '#252525'},
          {left: 'oil_and_derivatives',           right: 'chps',             gquery: 'oil_and_derivatives_to_chps_prod_in_sankey', color: '#8c564b'},
          {left: 'geo_solar_wind_water_ambient',  right: 'chps',             gquery: 'geo_solar_wind_water_ambient_to_chps_prod_in_sankey', color: '#2ca02c'},
          {left: 'natural_gas',                   right: 'chps',             gquery: 'natural_gas_to_chps_prod_in_sankey', color: '#7f7f7f'},
          {left: 'nuclear',                       right: 'chps',             gquery: 'nuclear_to_chps_prod_in_sankey', color: '#ff7f0e'},
          {left: 'biomass_products',              right: 'chps',             gquery: 'biomass_products_to_chps_prod_in_sankey', color: '#2ca02c'},
          {left: 'coal_and_derivatives',          right: 'households',       gquery: 'coal_and_derivatives_to_households_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'buildings',        gquery: 'coal_and_derivatives_to_buildings_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'transport',        gquery: 'coal_and_derivatives_to_transport_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'industry',         gquery: 'coal_and_derivatives_to_industry_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'agriculture',      gquery: 'coal_and_derivatives_to_agriculture_in_sankey', color: '#252525'},
          {left: 'coal_and_derivatives',          right: 'other',            gquery: 'coal_and_derivatives_to_other_in_sankey', color: '#252525'},
          {left: 'oil_and_derivatives',           right: 'households',       gquery: 'oil_and_derivatives_to_households_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'buildings',        gquery: 'oil_and_derivatives_to_buildings_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'transport',        gquery: 'oil_and_derivatives_to_transport_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'industry',         gquery: 'oil_and_derivatives_to_industry_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'agriculture',      gquery: 'oil_and_derivatives_to_agriculture_in_sankey', color: '#8c564b'},
          {left: 'oil_and_derivatives',           right: 'other',            gquery: 'oil_and_derivatives_to_other_in_sankey', color: '#8c564b'},
          {left: 'geo_solar_wind_water_ambient',  right: 'households',       gquery: 'geo_solar_wind_water_ambient_to_households_in_sankey', color: '#2ca02c'},
          {left: 'geo_solar_wind_water_ambient',  right: 'buildings',        gquery: 'geo_solar_wind_water_ambient_to_buildings_in_sankey', color: '#2ca02c'},
          {left: 'geo_solar_wind_water_ambient',  right: 'transport',        gquery: 'geo_solar_wind_water_ambient_to_transport_in_sankey', color: '#2ca02c'},
          {left: 'geo_solar_wind_water_ambient',  right: 'industry',         gquery: 'geo_solar_wind_water_ambient_to_industry_in_sankey', color: '#2ca02c'},
          {left: 'geo_solar_wind_water_ambient',  right: 'agriculture',      gquery: 'geo_solar_wind_water_ambient_to_agriculture_in_sankey', color: '#2ca02c'},
          {left: 'geo_solar_wind_water_ambient',  right: 'other',            gquery: 'geo_solar_wind_water_ambient_to_other_in_sankey', color: '#2ca02c'},
          {left: 'natural_gas',                   right: 'households',       gquery: 'natural_gas_to_households_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'buildings',        gquery: 'natural_gas_to_buildings_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'transport',        gquery: 'natural_gas_to_transport_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'industry',         gquery: 'natural_gas_to_industry_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'agriculture',      gquery: 'natural_gas_to_agriculture_in_sankey', color: '#7f7f7f'},
          {left: 'natural_gas',                   right: 'other',            gquery: 'natural_gas_to_other_in_sankey', color: '#7f7f7f'},
          {left: 'nuclear',                       right: 'households',       gquery: 'nuclear_to_households_in_sankey', color: '#ff7f0e'},
          {left: 'nuclear',                       right: 'buildings',        gquery: 'nuclear_to_buildings_in_sankey', color: '#ff7f0e'},
          {left: 'nuclear',                       right: 'transport',        gquery: 'nuclear_to_transport_in_sankey', color: '#ff7f0e'},
          {left: 'nuclear',                       right: 'industry',         gquery: 'nuclear_to_industry_in_sankey', color: '#ff7f0e'},
          {left: 'nuclear',                       right: 'agriculture',      gquery: 'nuclear_to_agriculture_in_sankey', color: '#ff7f0e'},
          {left: 'nuclear',                       right: 'other',            gquery: 'nuclear_to_other_in_sankey', color: '#ff7f0e'},
          {left: 'biomass_products',              right: 'households',       gquery: 'biomass_products_to_households_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'buildings',        gquery: 'biomass_products_to_buildings_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'transport',        gquery: 'biomass_products_to_transport_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'industry',         gquery: 'biomass_products_to_industry_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'agriculture',      gquery: 'biomass_products_to_agriculture_in_sankey', color: '#2ca02c'},
          {left: 'biomass_products',              right: 'other',            gquery: 'biomass_products_to_other_in_sankey', color: '#2ca02c'},
          {left: 'import',                        right: 'electricity_prod', gquery: 'import_to_electricity_prod_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'households',       gquery: 'chps_to_households_in_sankey', color: '#d62728'},
          {left: 'chps',                          right: 'buildings',        gquery: 'chps_to_buildings_in_sankey', color: '#d62728'},
          {left: 'chps',                          right: 'transport',        gquery: 'chps_to_transport_in_sankey', color: '#d62728'},
          {left: 'chps',                          right: 'industry',         gquery: 'chps_to_industry_in_sankey', color: '#d62728'},
          {left: 'chps',                          right: 'agriculture',      gquery: 'chps_to_agriculture_in_sankey', color: '#d62728'},
          {left: 'chps',                          right: 'other',            gquery: 'chps_to_other_in_sankey', color: '#d62728'},
          {left: 'electricity_prod',              right: 'households',       gquery: 'electricity_prod_to_households_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'buildings',        gquery: 'electricity_prod_to_buildings_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'transport',        gquery: 'electricity_prod_to_transport_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'industry',         gquery: 'electricity_prod_to_industry_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'agriculture',      gquery: 'electricity_prod_to_agriculture_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'other',            gquery: 'electricity_prod_to_other_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'households',       gquery: 'chps_e_to_households_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'buildings',        gquery: 'chps_e_to_buildings_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'transport',        gquery: 'chps_e_to_transport_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'industry',         gquery: 'chps_e_to_industry_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'agriculture',      gquery: 'chps_e_to_agriculture_in_sankey', color: '#1f77b4'},
          {left: 'chps',                          right: 'other',            gquery: 'chps_e_to_other_in_sankey', color: '#1f77b4'},
          {left: 'electricity_prod',              right: 'loss',             gquery: 'electricity_prod_to_loss_in_sankey', color: '#7f7f7f'},
          {left: 'chps',                          right: 'loss',             gquery: 'chps_to_loss_in_sankey', color: '#7f7f7f'},
          {left: 'electricity_prod',              right: 'exported_electricity', gquery: 'electricity_production_to_export_in_sankey', color: '#1f77b4'}
        ]

  # In this chart most positioning is calculated by us. The D3 sankey plugin is
  # cool but not flexible enough
  Node: class extends Backbone.Model
    width: 20
    horizontal_spacing: 170
    vertical_margin: 10

    initialize: =>
      @right_links = []
      @left_links = []
      @view = @get 'view'

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

    x_offset: => @get('column') * (@width + @horizontal_spacing)

    # center point of the node. We use it as link anchor point
    x_center: => @x_offset() + @width / 2

    # The height of the node is the sum of the height of its link. Since links
    # are both inbound and outbound, let's use the max size. Ideally the values
    # should match
    value: =>
      _.max [
        _.inject(@left_links, ((memo, i) -> memo + i.value()), 0),
        _.inject(@right_links,((memo, i) -> memo + i.value()), 0)
      ]

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
      @link_list = _.map D3.sankey.charts[k].data.links, (l) =>
        new D3.sankey.Link(_.extend l, view: this)
      @initialize_defaults()

    # this method is called when we first render the chart. It is called if we
    # want a full chart refresh when the user resizes the browser window, too
    draw: =>
      @margin =
        top: 5
        left: 5
        bottom: 5
        right: 10
      @width = 494 - (@margin.left + @margin.right)
      @height = 300 - (@margin.top + @margin.bottom)

      # scaling method taht will be changed dynamically
      @y = d3.scale.linear().domain([0, 5000]).range([0, @height])

      # This is the function that will take care of drawing the links once we've
      # set the base points
      @link_line = d3.svg.line()
        .interpolate("basis")
        .x((d) -> d.x)
        .y((d) -> @y(d.y))

      @svg = d3.select("#d3_container_#{@key}")
        .append("svg:svg")
        .attr("height", @height + @margin.top + @margin.bottom)
        .attr("width", @width + @margin.left + @margin.right)
        .append("svg:g")
        .attr("transform", "translate(#{@margin.left}, #{@margin.top})")
      @links = @draw_links()
      @nodes = @draw_nodes()

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
        .style("stroke", (link, i) -> link.color())
        .style("fill", "none")
        .style("opacity", selectedLinkOpacity)
        .attr("d", (link) => @link_line link.path_points())
      links.on('mouseover', @link_mouseover)
        .on('mouseout', @node_mouseout)
      return links

    draw_nodes: =>
      colors = d3.scale.category20()
      nodes = @svg.selectAll("g.node")
        .data(@node_list, (d) -> d.get('id'))
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
        .attr("dx", 25)
        .attr("dy", 3)
        .attr("y", (d) => @y(d.y_offset() + d.value() / 2) )
        .text((d) -> d.label())
      @setup_tooltips()
      return nodes

    setup_tooltips: ->
        $("g.node").qtip
          content:
            text: -> $(this).attr('data-tooltip')
          position:
            target: 'mouse'
            my: 'bottom right'
            at: 'top center'

    # callbacks
    #
    unselectedLinkOpacity = 0.1
    selectedLinkOpacity = 0.5
    hoverLinkOpacity = 0.9

    node_mouseover: (e) =>
      @svg.selectAll(".link")
        .filter((d) -> !d.connects(e.get 'id'))
        .transition()
        .duration(200)
        .style("opacity", unselectedLinkOpacity)

    link_mouseover: ->
      d3.select(this)
        .transition()
        .duration(200)
        .style("opacity", hoverLinkOpacity)

    # this is used as link_mouseout, too
    node_mouseout: ->
      d3.selectAll(".link")
        .transition()
        .duration(200)
        .style("opacity", selectedLinkOpacity)

    # this method is called every time we're updating the chart
    refresh: =>
      max_height = @max_column_value()

      # update the scaling function
      @y.domain([0, max_height * 1.25])
        .range([0, @height * .90])

      # update the node label
      @nodes.data(@node_list, (d) -> d.get('id'))
        .attr("data-tooltip", (d) =>
          h = "<strong>
            #{d.label()}: #{Metric.autoscale_value d.value(), 'PJ', 2}
          </strong><br/>"
          for l in d.right_links
            h += "-&gt; #{l.right.label()}: #{Metric.autoscale_value l.value(), 'PJ', 2}<br/>"
          for l in d.left_links
            h += "#{l.left.label()} &lt;-: #{Metric.autoscale_value l.value(), 'PJ', 2}<br/>"
          h
          )

      # move the rectangles
      @nodes.selectAll("rect")
        .transition().duration(500)
        .attr("height", (d) => @y d.value())
        .attr("y", (d) => @y(d.y_offset()))

      # then move the node label
      @nodes.selectAll("text.label")
        .transition().duration(500)
        .attr("y", (d) => @y(d.y_offset() + d.value() / 2) )

      # then transform the links
      @links.data(@link_list, (d) -> d.cid)
        .transition().duration(500)
        .selectAll("path")
        .attr("d", (link) => @link_line link.path_points())
        .style("stroke-width", (link) => @y(link.value()))
        .attr("display", (link) ->
          if link.value() == 0.0 then 'none' else 'inline'
        )

    # returns the height of the tallest column
    max_column_value: =>
      sums = {}
      for n in @node_list
        column = n.get 'column'
        sums[column] = sums[column] || 0
        sums[column] += n.value()
      _.max _.values(sums)
