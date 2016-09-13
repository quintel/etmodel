/*globals I18n*/

var EmptyChartMessage = (function () {
    'use strict';

    var template = function (chart_key, container) {
        var wrapper,
            existingWrapper = container.find(".empty-wrapper");

        if (existingWrapper.length > 0) {
            wrapper = existingWrapper;
        } else {
            wrapper = $("<div>").addClass("empty-wrapper");
            wrapper.append(
                $("<p>").text(I18n.t("output_elements.common.empty")),
                $("<div>").text(I18n.t("output_elements.empty." + chart_key))
                    .addClass("annotation")
            );

            container.append(wrapper);
        }
        return wrapper;
    };

    return {
        display: function (chart) {
            var container = $(chart.container_selector()),
                wrapper   = template(chart.key, container),
                isEmpty   = chart.is_empty();

            container.toggleClass("empty", isEmpty);

            wrapper.height(chart.height);
            wrapper.toggle(isEmpty);
        }
    };
}());
