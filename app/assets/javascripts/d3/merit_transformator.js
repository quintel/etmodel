/*globals Downsampler,LoadSlicer*/

var MeritTransformator = (function () {
    'use strict';

    function transformSerieValues(serie) {
        if (this.scope.dateSelect.val() > 0) {
            return LoadSlicer.slice(serie, this.scope.dateSelect.getCurrentRange());
        } else {
            return Downsampler.downsample(serie);
        }
    }

    MeritTransformator.prototype = {
        transform: function () {
            this.data.forEach(function(serie) {
                if (!(serie.oldValues)) {
                    serie.oldValues = serie.values;
                }

                serie.values = transformSerieValues.call(this, serie);
            }.bind(this));


            if (this.scope.stack) {
                return this.scope.stack(this.data);
            } else {
                return this.data;
            }
        }
    };

    function MeritTransformator (scope, data) {
        this.scope = scope;
        this.data  = data;
    }

    return MeritTransformator;
}());
