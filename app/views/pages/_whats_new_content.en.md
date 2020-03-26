# What's new in the Energy Transition Model?

---

# Maart 2020

## Curtailment of solar panels

Installing a large capacity of solar PV panels may cause high peak demands on the electricity network. It is therefore desirable to be able to curtail these peaks. In some cases it might be smart to connect solar parks to a certain percentage of its peak power. It is now possible to set the curtailment as a percentage of the peak power in the ETM.

![](/assets/pages/whats_new/curtailment_solar_pv_en.png)

## Convert excess electricity into heat for district heating

It is now possible to convert electricity excesses from solar and wind production into heat for district heating. This can be done by means of a power-to-heat (P2H) electric boiler and a P2H heat pump that only produce heat when there is an excess of electricity. The produced heat can be used immediately or can be stored for later use. For example, it is now possible to use solar and wind electricity excesses to heat households during winter.

![](/assets/pages/whats_new/p2h_seasonal_storage_en.png)

## Get insight in behaviour of hybrid heat pumps

The efficiency of hybrid heat pumps (HHP) is dependent on the ambient temperature and is depicted by the coefficient of performance (COP). The COP becomes lower as the outside temperature decreases. In the ETM you can set the COP threshold above which the HHP switches from gas to electricity. You can choose a setting that is most financially attractive for the consumer, but you can also choose a setting that produces less impact on the electricity network. Two charts have been added to assist the user in making this choice: a chart showing the cost-optimal threshold COP based on the consumer gas/electricity price and a chart showing gas and electricity demand per hour.

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

[district heating slide]: /scenario/supply/heat/heat-sources

[data export slide]: /scenario/data/data_export/merit-order-price

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[heat-infra costs documentation]: https://github.com/quintel/documentation/blob/master/general/heat_infrastructure_costs.md

[heat network documentation]: https://github.com/quintel/documentation/blob/master/general/heat_networks.md

[residual heat documentation]: https://github.com/quintel/documentation/blob/master/general/residual_heat_industry.md

[wind curves documentation]: https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind
