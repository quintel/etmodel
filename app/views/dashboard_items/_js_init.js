/*globals charts,gqueries*/
$(function () {
    'use strict';

    var chart_data, q, i, j,
        popup_charts = $("#dashboard_popup .chart");

    for (i = 0; i < popup_charts.length; i++) {
        chart_data = $(popup_charts[i]).data();
        charts.load(chart_data.chart_id, null, {
            popup:    true,
            force:    true,
            header:   false,
            prunable: true,
            wrapper:  (chart_data.wrapper || "#charts")
        });
    }

    q = gqueries.find_or_create_by_key('dashboard_bio_footprint');

    $("div.present .overlay").width(70 * q.safe_present_value());
    $("div.future  .overlay").width(70 * q.safe_future_value());
});
