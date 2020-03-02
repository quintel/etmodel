# What's new in the Energy Transition Model?

## 1. District heating improved and expanded

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

## 2. CHPs modeled differently

All CHPs (with the exception of biogas-CHP) now also work as dispatchable in the electricity merit order, including the industrial CHPs. CHPs are therefore now running primarily for the electricity market. Their heat production is therefore a "given" (must-run) for heat networks. Previously, CHPs were uncontrollable and ran with a fixed, flat production profile. This change may have an impact on your scenario outcomes!

## 3. Wind load curves improved

The wind load curves for the default dataset of the Netherlands are now created using the same (KNMI-based) method as used for the [extreme weather years (1987, 1997, 2004)][weather years slide]. This ensures more consistency between the different datasets for the Netherlands. Check out our [Github documentation][wind curves documentation] for a more detailed explanation of this method.

-> ![](/assets/pages/whats_new/wind_curves_en.png) <-

## 4. Documentation more accessible

For certain sliders it was already possible to view the technical specifications so that you could see our assumptions. Now we go one step further and for many sliders we also make our entire background analysis available (which is already on GitHub) at the touch of a button. From the technical specifications table you can download this analysis directly as an Excel file.

-> ![](/assets/pages/whats_new/documentation_download_en.png) <-

## 5. Download slider settings

For saved scenarios it is possible to download the values ​​of your sliders as a CSV file. This can be useful if you want to list all your scenario changes. View your saved scenarios via "User> My scenarios" (top right in the ETM) and click on the title of the desired scenario. Now enter '.csv' after the url (so you get pro.energytransitionmodel.com/saved_scenarios/0000.csv) and the download starts immediately.

## 6. Data export adjusted

The format of the load and price curves of electricity has recently changed. For each column in the data export the extension "input" or "output" is used to indicate whether the data represents demand or supply of electricity. Flexibility solutions have two columns now, both for the electricity input and output. With these changes, the format of the data exports of electricity, network gas and hydrogen are more consistent.

[district heating slide]: /scenario/supply/heat/heat-sources

[data export slide]: /scenario/data/data_export/merit-order-price

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[heat-infra costs documentation]: https://github.com/quintel/documentation/blob/master/general/heat_infrastructure_costs.md

[residual heat documentation]: https://github.com/quintel/documentation/blob/master/general/residual_heat_industry.md

[wind curves documentation]: https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind
