var Tracker = {
  track: function(payload) {
    if (!globals.wattnu) return true;
    $.ajax({
      url: '/track',
      data: {data: payload}
    });
    return true;
  }
};
