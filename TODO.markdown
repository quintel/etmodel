TODO
====

Random thoughts on possible improvements:

App
---

* The event chains could be simplified, especially in the fetch-scenario-id / get-slider-values / make-api-request / load-chart-and-dashboard sequence. JQuery deferred objects have been added late and they could be used extensively

Charts
------

* Drop jqplot (and IE8) support: this will simplify the chart code immensely
* Refactor the chart series objects and collections
* Chart locking and default charts: I suggest rethinking the entire app interface
* Chart-related callbacks: they're defined in multiple locations. The entire app could be backbonejs-ified, but memory leaks, especially event-wise, will be an issue to take into account
* Some D3 layouts can be extracted
* The chart initialization and first rendering sequence feels ugly. Check ETPlugin's charts to see a better approach - there it has been possible because there was no need to support the old jqplot stuff


Tests
-----

* Find a definitive solution to the fixtures/factories issue. Integration tests are plagued by the initial data setup (which is fixture based!)
* Find out a long term strategy for the API calls strategy: mock stuff out or extend VCR coverage
* VCR requires the ugly NastyProxy: it would be nice to get rid of it

Dashboard
---------

* Refactoring is possible. The dashboard items could make use of inheritance to clean-up the code

Naming
------

Some objects should be renamed, these are my suggestions:

* constraint -> dashboard_item
* output_element -> chart
* input_element -> slider

Content
-------
* Hard coded HTML in descriptions should be removed, especially video embeds
