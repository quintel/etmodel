//= require html5shiv
//= require jquery
//= require jquery.browser

jQuery( function() {
    if( $.browser.msie ) {
        // A 1px increase fixes some bad aliasing when resizing the image
        // down to non-HiDPI resolutions.
        $('#header_inside img[src$="@2x.png"]').attr({ width: '401' });
    }
} );
