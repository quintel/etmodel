# What's new in the Energy Transition Model?

---

# April 2021

## New chart showing the provision of flexibility

In our February 2021 update we have added a number of charts that give insight into the need for flexibility. The next step is to provide that flexibility. We have therefore added a new chart that shows the installed capacity of flexible supply and demand technologies. Comparing those capacities to the maximum shortage and excess peak can help you determine whether you have installed enough flexible capacity to balance your energy system.

-> ![](/assets/pages/whats_new/installed_flexible_capacities_en.png) <-

The chart can be found in the section **[Flexibility → Overview][flexibility]**, where we have also updated the explanations accompanying the charts. We now discuss the inflexible demand and supply and the residual load curves in more detail, so be sure to check it out!

## New chart showing the stored volume of electricity

A relevant performance metric for electricity storage technologies is the extent to which they are utilised. We have therefore visualised the (dis)charging behaviour of these technologies in a new chart that shows the hourly stored volume of electricity.

You can find the chart in the section **[Flexibility → Excess electricity → Storage][electricity storage]**. You can choose to view all of the following electricity storage technologies stacked on each other, or just one:

* Batteries in households
* Batteries in electric vehicles
* Large-scale batteries
* Underground pumped hydro storage
* Reservoirs (depending on the selected dataset)

-> ![](/assets/pages/whats_new/hourly_stored_volume_of_electricity_en.png) <-

# February 2021

## New charts showing the need for flexibility

Natural patterns like seasons (yearly), the variations in weather (weekly), day and night and our rhythm of waking up, going to work, coming home, etc. cause both the need for energy and the availability of energy to fluctuate. Flexibility is about balancing energy supply and demand on all these timescales.

We have added the section **[Flexibility → Overview][flexibility]** to the ETM with four interactive charts in which you can see how supply and demand compare on various timescales. These charts show:

* Monthly supply and demand volumes
* Imbalance of monthly supply and demand volumes
* The need for flexibility: volume
* The need for flexibility: capacity

-> ![](/assets/pages/whats_new/monthly_supply_and_demand_volumes_en.png) <-

*A detailed explanation can be found in the [documentation](https://docs.energytransitionmodel.com/main/flexibility).*

## Modify profiles

The ETM calculates the hourly production and demand of gas, electricity, heat, and hydrogen. It is now also possible to upload and work with your own curves in the **[Flexibility → Modify Profiles][modify curves slide]** section. There are three types of profiles you can modify:

1. Demand profiles (e.g. electric buses, industrial heating)
2. Production profiles (e.g. solar PV, wind offshore)
3. Price curves (e.g. for power interconnectors)

The chart on the right shows all profiles which you may customise. If you upload a custom profile this is directly reflected in the chart.

![](/assets/pages/whats_new/modify_profiles_en.png)

Check out [the Curves documentation](https://docs.energytransitionmodel.com/main/curves) for more information.

## Download charts as images

Need to use a chart in a report, or want to share it with colleagues? All charts in the model can now be downloaded as a high-resolution image by clicking the button just above the chart.

-> ![](/assets/pages/whats_new/chart_as_image_en.png) <-

---

# November 2020

## Carbon capture, utilisation and storage (CCUS)

Carbon capture, utilisation and storage (CCUS) is a group of emissions reduction technologies that can be applied across the energy system. The ETM now takes into account CCUS applications in much more detail than before.

The ETM models four types of carbon capture:

 * Capture in industry. A distinction is now made between various sub sectors and production technologies and their respective capture potentials, costs and energy requirements.
 * Capture in the power sector
 * Capture for hydrogen production
 * Direct Air Capture, a process of capturing CO2 directly from the ambient air using electricity.

![](/assets/pages/whats_new/ccus_supply_demand_mekko.png)

The ETM models four types of carbon usage:

 * Offshore storage
 * Utilisation of CO<sub>2</sub> as feedstock for synthetic kerosene production
 * Utilisation of CO<sub>2</sub> as feedstock for synthetic methanol production
 * Other utilisation, such as propellant gas for beer and soda or for the cultivation of crops in greenhouses.

![](/assets/pages/whats_new/co2-sankey-en.png)

The ETM models two types of carbon transportation:

  * Via pipelines
  * Liquefied transport in ships


Discover these new features in the **[Supply → CCUS][ccus slide]** section! A detailed explanation can be found in our [documentation](https://docs.energytransitionmodel.com/main/co2-ccus).

## Negative emissions
The ETM can now deal with so-called 'negative' CO<sub>2</sub> emissions. Such emissions may arise when applying carbon capture to processes using biomass or when CO<sub>2</sub> is captured directly from the ambient air using Direct Air Capture technology. See our [documentation](https://docs.energytransitionmodel.com/main/co2-negative-emissions) for more.

![](/assets/pages/whats_new/co2-negative-emissions.png)

## Scenario Navigation bar

A new scenario navigation bar has been added which shows the region and end year for your scenario; when you open one of your saved scenarios, the scenario name is also shown making it easier to have multiple scenarios open in different browser tabs. Quickly save your scenario with the "Save scenario" button on the right. It's now easier to access all of your saved scenarios by visiting "My scenarios".

![](/assets/pages/whats_new/scenario_navigation_bar_eng.png)


## Interaction possible with other models from the Mondaine Suite

Multiple energy models are used to explore different parts of the complex challenge of the energy transition. A collaboration between these models makes it possible to exploit the strengths of each individual model. In the context of the [Mondaine](https://www.mondaine-suite.nl) project, the Energy System Description Language ([ESDL](https://energytransition.github.io/)) has been developed to support the communication between the different models - it allows the models to ‘speak’ the same language. ESDL can be used to describe information about spatial, technical, economical, social and temporal aspects of the energy transition, all in relation to each other. This makes it possible for a model to build further upon information from another model. The energy system defined in an ESDL file will be converted into slider settings - this makes it possible to explore the future energy system in the ETM and allows you to continue working on the scenario.

Check out the ESDL import functionality [here][esdl]!

![](/assets/pages/whats_new/mondaine.jpg)

---

# June 2020

## Multiple electrical interconnectors

Many countries import and export electricity with their neighbors through different interconnectors, and the ETM used to model this with a single electricity interconnector. However, in the real-world countries often have multiple interconnectors with different neighbours, each with their own capacity, price, and availability.

The ETM now models up to six independent interconnectors, each of which have configurable capacity, CO<sub>2</sub> emissions, and price. You may choose whether to export only excess electricity, or if dispatchable plants may also produce electricity destined for export. You can realistically model all electricity flows across the borders of your country, and see an overview of all these electricity flows in a new chart.

Discover this new functionality in the **[Flexibility → Import/Export][import export]** section!

![](/assets/pages/whats_new/electricity_sankey_en.png)

## Heat demand curves for buildings and agriculture

The hourly heat demand curves in the buildings and agriculture sector are now temperature dependent. This means that the shape of the demand curves will change depending on the selected weather year. Previously, the ETM used static demand profiles for the buildings sector and a flat profile for agriculture. Both sectors now use the same profile, based on data from large gas consumers, which is generated dynamically using weather data. As a result, this profile is now also available for the weather years 1987, 1997, and 2004. Heat demand in buildings and agriculture responds to outdoor temperature fluctuations, just like households heating demand.

Get insight in the impact of the weather year selection on demand curves in the **[Flexibility → Weather conditions][weather years slide]** section!

![](/assets/pages/whats_new/weather_years_buildings_heating_en.png)

## Impact of outdoor temperature on yearly energy demand

The impact of a higher or lower average outdoor temperature has been revised. In addition to heating and cooling demand in households and buildings, changing outdoor temperature now also affects heating demand in the agriculture sector. Heating demand in all three sectors now is more sensitive to temperature changes; the impact of temperature on heat demand is based on research by the Dutch gas TSO. See our [documentation page](https://docs.energytransitionmodel.com/main/outdoor-temperature) for more info. This improvement is relevant for both the temperature slider and the weather year selection.

Check out this improvement in the **[Flexibility → Weather conditions][weather years slide]** section!

![](/assets/pages/whats_new/outdoor_temperature_en.png)

---

# March 2020

## Curtailment of solar panels

Installing a large capacity of solar PV panels may cause high peak demands on the electricity network. It is therefore desirable to be able to curtail these peaks. In some cases it might be smart to connect solar parks to a certain percentage of its peak power. It is now possible to set the curtailment as a percentage of the peak power in the ETM.

Discover the curtailment of solar panels in the **[Flexibility → Net load][solar pv curtailment slide]** section!

![](/assets/pages/whats_new/curtailment_solar_pv_en.png)

## Convert excess electricity into heat for district heating

It is now possible to convert electricity excesses from solar and wind production into heat for district heating. This can be done by means of a power-to-heat (P2H) electric boiler and a P2H heat pump that only produce heat when there is an excess of electricity. The produced heat can be used immediately or can be stored for later use. For example, it is now possible to use solar and wind electricity excesses to heat households during winter.

Check out the P2H sliders for district heating in the **[Flexibility → Excess electricity → Conversion][p2h district heating slide]** section!

![](/assets/pages/whats_new/p2h_seasonal_storage_en.png)

## Get insight in behaviour of hybrid heat pumps

The efficiency of hybrid heat pumps (HHP) is dependent on the ambient temperature and is depicted by the coefficient of performance (COP). The COP becomes lower as the outside temperature decreases. In the ETM you can set the COP threshold above which the HHP switches from gas to electricity. You can choose a setting that is most financially attractive for the consumer, but you can also choose a setting that produces less impact on the electricity network. Two charts have been added to assist the user in making this choice: a chart showing the cost-optimal threshold COP based on the consumer gas/electricity price and a chart showing gas and electricity demand per hour.

Get insight in hybrid heat pump behavior in the **[Flexibility → Net load][behavior hhp slide]** section!

![](/assets/pages/whats_new/HHP_behaviour_en.png)

## Improved heating demand curves for households

The improved hourly heating demand curves used in the ETM better account for the concurrency of heating demand. The new curves are based on the average demand of 300 houses. Previously, demand curves were based on individual households which led to an overestimation of demand peaks.

Note: Because the heat demand peaks for households are lower, the results of your scenario might change. For example, when many houses are connected to district heating fewer back-up boilers may be required. If many houses have a heat pump installed, the peak load on the electricity grid will be reduced. If you are having trouble understanding the differences, don't hesitate to <a href="mailto:info@energytransitionmodel.com">email us</a>.

## Data export adjusted

In the data export, the hourly electricity curves for space heating in households have been broken down into series for individual heating technologies. This makes it possible to view the electricity hourly demand curve for air source heat pumps and other electric heating technologies.

---

# January | February 2020

## District heating improved and expanded

The modeling of district heating has been improved and expanded!

- Heating networks in households, buildings, and agriculture have been merged into one network ("**residential district heating**"). It is no longer possible to exchange excess heat between industrial (steam) networks and residential networks.

- The demand and production of heat for residential district heating is now calculated on a **hourly basis** instead of on an annual basis.

  -> ![](/assets/pages/whats_new/hourly_heat_en.png) <-

- A distinction is made between "**must-run**" sources and "**dispatchable**" sources. Dispatchables only run if the must-runs do not produce enough to meet the demand. Their operating hours and profiles are therefore variable. Users can set which heaters start first

  -> ![](/assets/pages/whats_new/heat_merit_order_en.png) <-

- It is now possible to use **large-scale solar thermal plants** for residential district heating

- Users can choose to turn **seasonal heat storage** 'on'. In that case, overproduction of must-run sources is stored for later use instead of being dumped

  -> ![](/assets/pages/whats_new/seasonal_storage_heat_en.png) <-

- **Residual heat** from the fertilizer, chemical, refining, and IT sectors can be used and fed into residential district heating networks. View [our documentation on GitHub][residual heat documentation] for the method and sources used

- The **cost calculation** for heat infrastructure has been improved. Instead of calculating a fixed amount per connection, the costs are now subdivided into indoor costs, distribution costs (pipelines, substations) and primary network costs. The cost calculation has been aligned with the Vesta MAIS model, making comparisons and exchange of outcomes between the ETM and Vesta MAIS easier. View [our documentation on GitHub][heat-infra costs documentation] for more information.

Discover the improved modelling of district heating in the **[District heating → Heat sources][district heating slide]** section and check out our [Github documentation][heat network documentation] for a more detailed explanation.

## CHPs modeled differently

All CHPs (with the exception of biogas-CHP) now also work as dispatchable in the electricity merit order, including the industrial CHPs. CHPs are therefore now running primarily for the electricity market. Their heat production is therefore a "given" (must-run) for heat networks. Previously, CHPs were uncontrollable and ran with a fixed, flat production profile. This change may have an impact on your scenario outcomes!

## Wind load curves improved

The wind load curves for the default dataset of the Netherlands are now created using the same (KNMI-based) method as used for the [extreme weather years (1987, 1997, 2004)][weather years slide]. This ensures more consistency between the different datasets for the Netherlands. Check out our [Github documentation][wind curves documentation] for a more detailed explanation of this method.

-> ![](/assets/pages/whats_new/wind_curves_en.png) <-

## Documentation more accessible

For certain sliders it was already possible to view the technical specifications so that you could see our assumptions. Now we go one step further and for many sliders we also make our entire background analysis available (which is already on GitHub) at the touch of a button. From the technical specifications table you can download this analysis directly as an Excel file.

-> ![](/assets/pages/whats_new/documentation_download_en.png) <-

## Download slider settings

For saved scenarios it is possible to download the values ​​of your sliders as a CSV file. This can be useful if you want to list all your scenario changes. View your saved scenarios via "User> My scenarios" (top right in the ETM) and click on the title of the desired scenario. Now enter '.csv' after the url (so you get pro.energytransitionmodel.com/saved_scenarios/0000.csv) and the download starts immediately.

## Data export adjusted

The format of the load and price curves of electricity has recently changed. For each column in the data export the extension "input" or "output" is used to indicate whether the data represents demand or supply of electricity. Flexibility solutions have two columns now, both for the electricity input and output. With these changes, the format of the data exports of electricity, network gas and hydrogen are more consistent.

You can find the adjusted data export here in the **[Data export → Merit order price][data export slide]** section.

[electricity storage]: /scenario/flexibility/flexibility_storage/electricity-storage

[flexibility]: /scenario/flexibility/flexibility_overview/what-is-flexibility

[modify curves slide]: /scenario/flexibility/curve_upload/upload-curves

[ccus slide]: /scenario/supply/ccus/capture-of-co2

[esdl]: /import_esdl

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[import export]: /scenario/flexibility/electricity_import_export/electricity-interconnector-1

[solar pv curtailment slide]: /scenario/flexibility/flexibility_net_load/curtailment-solar-pv

[p2h district heating slide]: /scenario/flexibility/flexibility_conversion/conversion-to-heat-for-district-heating

[behavior hhp slide]: /scenario/flexibility/flexibility_net_load/demand-response-behavior-of-hybrid-heat-pumps

[district heating slide]: /scenario/supply/heat/heat-sources

[data export slide]: /scenario/data/data_export/merit-order-price

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[heat-infra costs documentation]: https://docs.energytransitionmodel.com/main/heat-infrastructure-costs

[heat network documentation]: https://docs.energytransitionmodel.com/main/heat-networks

[residual heat documentation]: https://docs.energytransitionmodel.com/main/residual-heat-industry

[wind curves documentation]: https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind
