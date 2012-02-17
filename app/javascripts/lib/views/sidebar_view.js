var SidebarView = Backbone.View.extend({
  bootstrap: function() {
    _.each(
      $("#sidebar ul li"), function(item){
        var gquery = $(item).attr('data-gquery');
        if(gquery) {
          new Gquery({key: gquery});
        }
      }
    );
  },
  
  update_bars: function() {
    _.each(
      $("#sidebar ul li"), function(item){
        var gquery = $(item).attr('data-gquery'); 
        if(gquery) {
          var result = gqueries.with_key(gquery)[0].get('future_value');
          var percentage = "" + Math.round(result * 100) + "%";
          var padded_percentage = "" + Math.round(result * 90) + "%";
          $(item).find(".bar").css('width', padded_percentage);
          $(item).find(".value").html(percentage).css('left', padded_percentage);
        }
      }
    );
  }
});

window.sidebar = new SidebarView();
