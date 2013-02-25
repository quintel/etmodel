//= require jquery.fancybox
//= require jquery.easing-1.3
//= require jquery.cycle
//= require jquery.busybox
//= require jquery.ajaxQueue
//= require jquery.qtip

$.fn.qtip.defaults.style.classes = "qtip-bootstrap"

// these have been added for IE, that has issues with events on SVG elements
$.fn.qtip.defaults.show.event = "mouseover"
$.fn.qtip.defaults.hide.event = "mouseout"
