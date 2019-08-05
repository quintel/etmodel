# What's new in the Energy Transition Model?

## 1. All RES regions available!

All 30 Dutch RES-regions are now available in the Energy TransitioModel. You can
explore these energy systems and make energy scenarios. For example, look at the
effect of...

* Placing a solar park in Drechtsteden;
* Insulating all terraced houses in Central Holland; or
* Building ten wind turbines in the Cleantech region

-> ![](assets/pages/whats_new/resregions_en.png) <-

## 2. User friendliness improvements

Many improvements have been made to the user friendliness of the ETM.

* **Introduction**: There is a [clear introduction][Workflow slide] where the
  process for creating scenarios is explained.
* **Saving scenarios**: You can use the "save" or "save as" function when
  creating your scenarios. By using the "save" function you overwrite the
  scenario while the name and link remain intact. Using "save as" allows you to
  make a copy, for which you must provide a new name (this is similar to the old
  way of saving a scenario).
* **Supply sliders**: The units of the supply sliders changed from "number of
  units" to MW, which makes it easier to translate known plans and objectives
  into slider settings, without the need for conversions themselves.
* **Residences**: Changes in numbers of residences do not have to be set per
  type of residence anymore. An increase in the total number of residences
  automatically increases the numbers of different residence types, based on the
  current) mix. This mix of residence types (terraced houses, detached houses,
  etc) can be changed. Check out the
  [new residences sliders][Housing stock slide].

## 3. Imported electricity price curve

Instead of the [price of imported electricity][Imported electricity cost slide]
being constant throughout the year, you may now choose to upload a CSV file
which can describe a custom price for each hour (of which there are 8,760 per
year). The position of imported electricity in the merit order will change by
the hour depending on how competitive it is relative to domestic generation
technologies.

-> ![](/assets/pages/whats_new/imported_electricity_price_en.png) <-

[Our documentation][Curve docs] contains more information on this feature,
including instructions on how to format your CSV file.

## 4. Hourly curves updated

The ETM models supply and demand of electricity and hydrogen on an hourly basis.
We have reviewed all profiles in close cooperation with the energy modelling
community and clearly documented the sources and methods on Github. This process
was concluded with a mini-symposium where the results were presented and we
identified areas for improvement.
[Documentation on all hourly curves can be found here][Curve docs].

-> ![](/assets/pages/whats_new/hourlyprofiles_en.png) <-

## 5. Transition path charts

The new transition path charts module allows you to explore the possible transition
paths to a 2050 scenario and discover the actions and consequences for aspired
goals in 2023, 2030 and 2040. The charts provide insights into the transition
paths of the most important aspects of the energy system (final energy demand,
CO<sub>2</sub> emissions, and renewables). For each of these years you are able
to further edit the slider settings to make adjustments to the scenarios.
[Explore the new transition path charts module][Multi year charts].

-> ![](/assets/pages/whats_new/myc_en.png) <-

## 6. Other updates

* **Non-energetic demand chemical industry**: It is possible to adjust the
  non-energetic demand in the chemical industry. For example, fossil carriers
  can be substituted by biomass/hydrogen [with the new sliders][Chemicals slide]
* **Hydrogen plant (CCGT)**: Besides the peak load hydrogen plant, it is also
  possible to use a [base load hydrogen plant (CCTG)][Hydrogen plants slide] in
  a scenario.

[Chemicals slide]: /scenario/demand/industry/chemicals
[Curve docs]: https://github.com/quintel/documentation/blob/master/general/curves.md
[Housing stock slide]: /scenario/demand/households/population-housing-stock
[Hydrogen plants slide]: /scenario/supply/electricity_renewable/hydrogen-plants
[Import price docs]: https://github.com/quintel/documentation/blob/master/general/costs_imported_electricity.md#uploaded-price-curves
[Imported electricity cost slide]: /scenario/costs/electricity_import_costs/costs-of-imported-electricity
[Multi year charts]: /multi_year_charts
[Workflow slide]: /scenario/overview/introduction/how-does-the-energy-transition-model-work
