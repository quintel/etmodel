var PeakLoad = Backbone.Model.extend({
  /* move demand population to the right => peak load is triggered => Popup
   * move demand population to the left => no peak load anymore
   * move demand population to the right again => peak load is triggered again
   * => if you want the popup to reappear again, set this to true. 
   *     (disadvantage: for every api_call the settings have to be synced to etmodel)
   */   
  SHOW_EVERY_TIME_PEAK_LOAD_IS_TRIGGERED : false,


  initialize : function() {
    _.bindAll(this, 'check_results');
    this.bind('change', this.check_results);

    // DEBT: make Gqueries
    this.gqueries = {
      'lv' :    new Gquery({key : 'peak_load_check_lv'}),
      'mv-lv' : new Gquery({key : 'peak_load_check_mv-lv'}),
      'mv'    : new Gquery({key : 'peak_load_check_mv'}),
      'hv-mv' : new Gquery({key : 'peak_load_check_hv-mv'}),
      'hv'    : new Gquery({key : 'peak_load_check_hv'})
    };

    this.grid_investment_needed_gquery = new Gquery({key : 'peak_load_check_total'});
  },
  check_results : function() {
    if (this.grid_investment_needed()) {
      if (this.unknown_parts_affected() && App.settings.get("track_peak_load")) {
        notify_grid_investment_needed(this.parts_affected().join(','));
        if (!this.SHOW_EVERY_TIME_PEAK_LOAD_IS_TRIGGERED) this.save_state_in_session(); 
      }
    }
    if (this.SHOW_EVERY_TIME_PEAK_LOAD_IS_TRIGGERED) this.save_state_in_session();
  },

  save_state_in_session : function() {
    App.settings.set({network_parts_affected : this.parts_affected() });
    App.settings.save();
  },

  /*
   * @return Boolean
   */
  grid_investment_needed : function() {
    return this.grid_investment_needed_gquery.result()[0][1];
  },

  /*
   * @return Array [lv, mv-lv, mv, hv-mv, hv]
   */
  parts_affected : function() {
    return _.compact(
      _.map(this.gqueries, function(gquery, part_affected) {
        return gquery.result()[0][1] ? part_affected : null;
      })
    );
  },
  
  /*
   * @return Boolean
   */
  unknown_parts_affected : function() {
    return  _.any(this.parts_affected(), function(key) { 
      return !(_.include(App.settings.get("network_parts_affected"), key));
    });
  }
  
});


function notify_grid_investment_needed(parts) {
  $.fancybox({
    width   : 960,
    padding : 30,
    href    : '/pages/grid_investment_needed?parts=' + parts,
    type    : 'ajax',
    onComplete: function() {$.fancybox.resize();}
  });
}

function disable_peak_load_tracking() {
  $("#track_peak_load_settings").attr('checked', false);
  toggle_peak_load_tracking();
}

function toggle_peak_load_tracking(){
  App.settings.set({track_peak_load : $("#track_peak_load_settings").is(':checked')});
  close_fancybox();
}