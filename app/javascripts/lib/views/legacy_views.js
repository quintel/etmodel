/*
 * This are models that are ported straight from Jaap MVC.
 * They aren't yet refactored to a more backbone js style version.
 * 
 *
 *
 *
 */


/**
 * Municipalities are controlled in this class.
 */
var MunicipalityController = Backbone.View.extend({
  initialize:function() {
    this.isShown = false;
    this.municipality = false;
  },
  
  /**
   * This is called after a message is shown. If the value changes, an ajax call
   * will be sent to the backend to let them know, the introduction has been shown.
   */
  setMunicipalityMessageShown:function(value, doUpdateIfNeeded) {
    if(doUpdateIfNeeded && this.isShown != value) {
      $.ajax({ 
        url: "/settings/update?show_municipality_introduction=false",
        method: 'post',// use GET requests. otherwise chrome and safari cause problems.
        async: false
      });
    }
    this.isShown = value;
  },

  /**
   * Show the message!
   */  
  showMessage:function() {
    return this.isMunicipality && !this.isMunicipalityMessageShown();
  }, 
  
  /**
   * Is the municipality message shown?
   */
  isMunicipalityMessageShown:function() {
    return this.isShown;
  },
  
  /**
   * Set the municipality
   */
  setMunicipality:function(municipality) {
    this.municipality = municipality;
  },
  
  /**
   * Returns true if we are inside a municipality.
   */
  isMunicipality:function() {
    return this.municipality; //this.isMunicipality;
  },
  
  /**
   * 
   */
  showMunicipalityMessage:function() {
    alert(I18n.t('municipality.areyousure'));
    this.setMunicipalityMessageShown(true, true);
  }
});
