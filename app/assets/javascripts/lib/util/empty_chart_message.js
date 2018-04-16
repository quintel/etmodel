/*globals I18n*/

var EmptyChartMessage = (function () {
    'use strict';

    var template = function (chart_key, container) {
        var wrapper,
            annotation,
            existingWrapper = container.find(".empty-wrapper");

        if (I18n.lookup('output_elements.empty.' + chart_key)) {
            annotation = $("<div>").text(I18n.t("output_elements.empty." + chart_key))
                .addClass("annotation")
        }

        if (existingWrapper.length > 0) {
            wrapper = existingWrapper;
        } else {
            wrapper = $("<div>").addClass("empty-wrapper");

            wrapper.append(
                $("<p>").text(I18n.t("output_elements.common.empty")),
                annotation
            );

            container.append(wrapper);
        }
        return wrapper;
    };

    return {
        display: function (chart) {
            var container = $(chart.container_selector()),
                wrapper   = template(chart.model.get('key'), container),
                isEmpty   = chart.is_empty();

            container.toggleClass("empty", isEmpty);

            wrapper.height(chart.height);
            wrapper.toggle(isEmpty);
        }
    };
}());
