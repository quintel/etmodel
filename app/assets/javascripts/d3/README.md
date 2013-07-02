# D3 Charts.

## How to add a new D3 chart type
This document describes how to add a new D3 chart type to et-model. It is not an introduction to D3.js and readers who have not used D3.js before are advised to go through one of the many tutorials available online.

### Background
Before going into detail on how to create a new D3 chart type, some background on how charts are being rendered in the first place.

The main scenario action `play` triggers the rendering of `views/scenarios/play.html.haml`, which involves the rendering of two partials, namely `output_elements/_chart_template.html` and `output_elements/_table_template.html`, which provide the containers wherein respectively charts and tables will be rendered. This view also triggers the creation of a new AppView, which leads to the eventual rendering of the appropriate chart or table.

By calling the `bootstrap()` function on this AppView instance, a ChartList is instantiated and charts are being loaded. The latter involves making one or more AJAX requests to /output_elements/\<chart_id\>. Upon successfully retrieving the associated data, a new Chart object is instantiated and eventually rendered.

As part of the instantiation of a Chart object, a `@series` attribute is added, which adds particular behaviour associated with certain chart types ('block','scatter' or anything else). Next, a call is made to the chart's  `render()` function. As part of this function, a chart's view class is determined and a new instance of that class is created. It's this last class that contains the actual specification of the D3 chart in question (in case the browser does not support D3, a fallback to jqPlot based charts is available for most chart types). Currently there are 13 chart types provided:

*Generic*
* Bezier
* Mekko
* Vertical Stacked Bar
* Horizontal Stacked Bar
* Grouped Vertical Bar
* Target Bar
* Line
* Block
* Sankey
* Scatter
* Waterfall

*Specific*
* Storage
* CO2 Emissions

### Adding a new chart type

In order to add a new chart type, one has to add a new file to `assets/javascripts/d3/`. The name of the file corresponds with the new type, i.e. `line.coffee` defines line charts, while `sankey.coffee` defines sankey diagrams as used in the ETM. 

The file defines the View class, which extends D3ChartView, which in turn extends BaseChartView, which extends Backbone.View... This View class needs to implement at least 4 funtions:

* initialize()
* can_be_shown_as_table()
* draw()
* refresh()

Apart from creating a new instance of the chart through a call to D3ChartView.prototype.initialize, the `initialize()` function generally also associates the data with the chart, although this is not mandatory.

The `can_be_shown_as_table()` function is a simple function, that returns either `true` or `false`, dependent on the desired behavior.

The `draw()` function contains the actual specification of the chart. Genereally, this involves creating a SVG container of the appropriate size, defining scales, creating axes, plotting series and creating a legend.

The `refresh()` function contains the D3 specifications required to update the chart once the underlying data (=~ gqueries) changes. 

### Linking new chart type to slides
Once the new chart type has been defined, four more steps have to be taken in order to make the new chart type available for use in etmodel:

* Extend `find_view_class()` in `assets/javascripts/lib/models/chart.coffee` in such a way that the proper View class is used. Here it also needs to be indicated whether the chart has been implemented for D3 only or for jqPlot as well. In case of the latter, the jqPlot chart will be used in browsers that don't support D3 (=~ SVG). If only D3-enabled browsers are supported the new chart type has to be added to the array of D3-only charts, which is part of the `supported_by_current_browser()` function within `chart.coffee`.
* In the etmodel database, create a new output_element_type with the same name as that used for the new file.
* In the etmodel database, create a new output_element of the new type.
* Using etmodel's admin front-end, you can now associate the slide(s) in question with the new output_element, which will result in the new chart being displayed once the associated slide(s) become active/in focus.
