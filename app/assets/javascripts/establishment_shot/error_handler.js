EstablishmentShot.ErrorHandler = (function () {
    'use strict';

    return {
        display: function (error, extras) {
            $("span.loading").remove();

            error.responseJSON.errors.forEach(function(error) {
                this.scope.before(
                    $('<div/>').addClass('error').text(error)
                );
            }.bind(this));

            this.scope.hide();
        }
    }
}());
