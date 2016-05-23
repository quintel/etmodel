/*globals Downsampler,LoadSlicer*/

var MeritTransformator = (function () {
    'use strict';

    function transformSerieValues(serie) {
        if (this.scope.dateSelect.val() > 0) {
            return LoadSlicer.slice(serie, this.scope.dateSelect.val());
        } else {
            return Downsampler.downsample(serie);
        }
    }

    MeritTransformator.prototype = {
        transform: function () {
            this.data.forEach(function(serie) {
                serie.values = transformSerieValues.call(this, serie);
            }.bind(this));


            return this.data;
        }
    };

    function MeritTransformator (scope, data) {
        this.scope = scope;
        this.data  = $.extend(true, [], data);
    }

    return MeritTransformator;
}());
