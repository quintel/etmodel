var Tracker = {
  track: function(payload) {
    if (!globals.wattnu) return true;
    $.ajax({
      url: '/track',
      data: {data: payload}
    });
    return true;
  },

  delayed_track: function(payload) {
    setTimeout(function(){Tracker.track(payload)}, 150);
  }
};
