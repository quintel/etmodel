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

    function mapSerie(serie) {
        if (!serie.skip) {
            return $.extend(
                {}, serie,
                { values: transformSerieValues.call(this, serie) }
          );
        }
    }

    MeritTransformator.prototype = {
        transform: function () {
            return this.data.map(mapSerie.bind(this)).filter(function (d) {
                return d != undefined;
            });
        }
    };

    function MeritTransformator (scope, data) {
        this.scope = scope;
        this.data  = data;
    }

    return MeritTransformator;
}());
