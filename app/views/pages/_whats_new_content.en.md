# What's new in the Energy Transition Model?

### 1. (Natural) gas demand calculated per hour
Demand and production of (natural) gas is now calculated for each hour per year rather than on a yearly basis. This allows users to see how gas use fluctuates over time, for example due to the heating of homes or electricity production. Users can also explore how (peak) demand for gas will change in the future and how this is affected by weather conditions.

-> ![](/assets/pages/whats_new/gas_demand_chart_en.png) <-

-> ![](/assets/pages/whats_new/gas_storage_chart_en.png) <-

The results of this time-resolved calculation are depicted in three new charts about gas demand, production and storage. You can find them by clicking the 'see more charts' button in the top right corner of the ETM.

-> ![](/assets/pages/whats_new/gas_charts_en.png) <-

### 2. Explore the impact of extreme weather conditions

Extreme weather conditions, such as extreme cold/warm periods and lacks/excesses of sun and wind, may affect your scenario. Low temperatures may affect the heat demand whereas a lack of wind and sun may negatively affect the electricity production from wind and solar power. To explore these effects a year with extreme weather conditions can be selected:

- 1987: "Dunkelflaute" during extreme cold winter period
- 1997: Lack of sustainable energy (incl. "Dunkelflaute") and extreme cold days
- 2004: Excessive and scarce sustainable energy

This feature is only available for (regions in) the Netherlands.

[Explore the effect of extreme weather conditions here!][weather slide]

### 3. CO2 factsheet available for your scenario

A visual representation of the CO2 footprint for your scenario is now available under the results section in the ETM. You can look at the footprint for both your scenario’s start and end year, making it easy to see the impact of your choices on the CO2 emissions in your region. This sheet is ready to print.

[Check out the factsheet for your scenario!][factsheet slide]

-> ![](/assets/pages/whats_new/co2_factsheet_en.png) <-

### 4. Hybrid heat in industry

It is now possible to convert excess electricity into heat for industry resulting in a decrease in demand for gas and hydrogen. These electric boilers can be used next to baseload boilers that were already modelled. With these newly implemented boilers you can prevent that the electric boilers run on electriciy produced by gas plants since the boilers only use excess electricity. The calculation is done on an hourly basis; the resulting gas and hydrogen demand profiles are therefore dependent on available surpluses. Hybrid heat is available in the following sectors: chemical industry, refineries, food industry and paper industry.

[Discover the impact of hybrid heat in industry here!][hybrid heat slide]

-> ![](/assets/pages/whats_new/hybrid_heat_industry_en.png) <-

### 5. Hydrogen in industry

It is now also possible to use hydrogen in the other industry sector, next to the energy carriers already present.

[Check out this improvement here!][hydrogen other industry slide]

-> ![](/assets/pages/whats_new/hydrogen_other_industry_en.png) <-


### 6. Improvements in biomass modelling

The modelling of biomass in the ETM has been improved in collaboration with TKI Nieuw Gas, Gasunie, GasTerra and TNO. Using biomass in a scenario is now simpler and more transparent. The improvements allow the user to see at a glance which biomass flows exist for the region, both for the present and the future. In addition, **potentials for various biomass flows** have been investigated by TNO. The ETM now shows these potentials for each region. Another important point of improvement is the addition of **supercritical water gasification (SCW)** and **gasification of dry biomass** for green gas. All required data on biomass and conversion techniques have been adjusted and documented on our [GitHub][biomass documentation] based on research by TNO.

[Discover all improvements to the use of biomass in the ETM!][biomass slide]

-> ![](/assets/pages/whats_new/biomass_sankey_en.png) <-

-> ![](/assets/pages/whats_new/biomass_potential_en.png) <-

### 7. New large-scale electricity storage technologies

Two large-scale electricity storage technologies have been added: **underground pumped hydro storage** and **large-scale batteries**. Excess electricity from renewable sources can now be stored in these technologies and supplied to the grid at a later moment. The user can adjust the costs of these technologies.

[Check out the impact of these new storage technologies on the electricity network here!][flex slide]

-> ![](/assets/pages/whats_new/new_flex_options_en.png) <-

[biomass documentation]: https://github.com/quintel/documentation/blob/master/general/biomass.md

[biomass slide]: /scenario/supply/biomass/overview

[flex slide]: /scenario/flexibility/excess_electricity/order-of-flexibility-options

[factsheet slide]: /scenario/data/data_visuals/co-sub-2-sub-footprint

[hybrid heat slide]: /scenario/flexibility/flexibility_conversion/conversion-to-heat-for-industry

[hydrogen other industry slide]: /scenario/demand/industry/other

[weather slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions
