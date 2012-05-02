var Tracker = {
  // tracks to the internal log
  track: function(payload) {
    if (!globals.wattnu) return true;
    $.ajax({
      url: '/track',
      data: {data: payload}
    });
    return true;
  },

  delayed_track: function(payload) {
    setTimeout(function(){Tracker.track(payload);}, 150);
  },

  // Google Analytics event tracking
  event_track: function(category,action,label,value) {
    if(!globals.standalone && window.pageTracker ){
      pageTracker._trackEvent(category, action, label, value);
    }
    return true;
  }
};
