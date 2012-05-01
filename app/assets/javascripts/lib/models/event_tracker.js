var EventTracker = {
  event_track: function(category,action,label,value) {
    if(!globals.standalone && pageTracker ){
      pageTracker._trackEvent(category, action, label, value);
    }
    return true;
  },

};
