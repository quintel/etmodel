/**
 * 'busyBox' v1.1
 * @author Roger Padilla C. - rogerjose81@gmail.com
 * Web: http://rogerpadilla.wordpress.com/2010/05/24/jquery-busybox/
 * Licensed under Apached License v2.0
 */
(function($) {

	/**
	 * Main function; used to initialize the plugin or for calling the available functionalities of the plugin (such as 'open' or 'close').
	 * The 'arguments' array is used to obtain the received parameters
	 */
	$.fn.busyBox = function() {

		$.fn.busyBox.self = this;

		if(arguments[0] == 'open') {
			$.fn.busyBox.open();
		} else if(arguments[0] == 'close') {
			$.fn.busyBox.close();
		} else {
			$.fn.busyBox.init(arguments[0]);
		}

		return this;
	};

	/**
	 * Initialize the plugin using the passed options
	 */
	$.fn.busyBox.init = function(options) {

		$.fn.busyBox.opts = $.extend({}, $.fn.busyBox.defaults, options);

		// Adds the default classes if they are not present in the passed classes
		if($.fn.busyBox.opts.classes.indexOf($.fn.busyBox.defaults.classes) === -1){
			$.fn.busyBox.opts.classes += ' ' + $.fn.busyBox.defaults.classes;
		}

		$.fn.busyBox.container = $(document.body);

		if($.fn.busyBox.opts.autoOpen){
			$.fn.busyBox.open();
		}
	};

	/**
	 * Display all the 'busyBoxes' over the matched boxes
	 */
	$.fn.busyBox.open = function(){

		var box, inner, e, bOffset, bWidth, bHeight, iTop, iLeft;

		$.fn.busyBox.self.each(function(index) {

			e = $(this);
			bWidth = e.outerWidth();
			bHeight = e.outerHeight();
			bOffset = e.offset();

			box = $('<div />');
			box.attr('id', 'busybox_' + index);
			box.addClass($.fn.busyBox.opts.classes);

			box.css({
				width: bWidth,
				height: bHeight,
				top: bOffset.top,
				left: -9999 // Used to not display the box yet without hidden it (needed to be able to calculate its dimensions)
			});

			inner = $($.fn.busyBox.opts.spinner);
			inner.attr('id', 'busybox_spinner_' + index);
			inner.addClass('busybox-spinner');

			box.append(inner);

			$.fn.busyBox.container.append(box);

			// Set the position of the inner message inside its parent. Calculates the 'top' and/or 'left' coordinates of the inner-message (inside its parent) if those properties were configured as 'auto'
			iTop = ($.fn.busyBox.opts.top == 'auto' ? ((bHeight / 2) - (inner.outerHeight() / 2)) + 'px' : $.fn.busyBox.opts.top);
			iLeft = ($.fn.busyBox.opts.left == 'auto' ? ((bWidth / 2) - (inner.outerWidth() / 2)) + 'px' : $.fn.busyBox.opts.left);

			inner.css({
				position: 'absolute',
				top: iTop,
				left: iLeft,
				opacity: 1.0
			});

			// Hidde and relocate the 'busyBox' (previously displayed using a negative left-coord to be able to calculate its dimensions)
			box.css({display: 'none', left: bOffset.left});
		});

		// Display all the 'busyBoxes'
		$.fn.busyBox.container.find('.' + $.fn.busyBox.defaults.classes).fadeIn('fast', $.fn.busyBox.opts.displayed.call(this));
	};

	/**
	 * Closes all the 'busyBoxes' being showed
	 */
	$.fn.busyBox.close = function(){
		if($.fn.busyBox.container) {
			$.fn.busyBox.container.find('.' + $.fn.busyBox.defaults.classes).fadeOut('fast', function(){
				$(this).remove();
			});
		}
	};

	/**
	 * Default configuration
	 */
	$.fn.busyBox.defaults = {
		autoOpen: true,
		spinner: '<em>Cargando&#8230;</em>',
		classes: 'busybox',
		top: 'auto',
		left: 'auto',
		displayed: function(){}
	};

})(jQuery);