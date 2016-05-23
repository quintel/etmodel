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
            return this.data.map(function(serie) {
                return $.extend(
                    {}, serie,
                    { values: transformSerieValues.call(this, serie) }
                );
            }.bind(this));
        }
    };

    function MeritTransformator (scope, data) {
        this.scope = scope;
        this.data  = data;
    }

    return MeritTransformator;
}());
