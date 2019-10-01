var pico = {
  ready: function(){
    window.parent.postMessage(pico.message(pico.turbineCount()));
  },

  message: function(power){
    return {
      action: "updateInlandWindTurbine",
      description: "This data is used to update the windturbine power slide " +
                   "in the Enegy transition model. The unit of which power " +
                   "represents the magnitute is Mega Watt",
      argument: {
        power: pico.inMegaWatt(power),
      },
    };
  },

  turbineCount: function(){
    return picoGetTurbineCount();
  },

  /* TODO: this conversion of turbinecount to megawatts is hardcoded now.
           Ask the API!
     V(energy_power_wind_turbine_inland, electricity_output_capacity) */
  inMegaWatt: function(turbines){
    return turbines * 3.0;
  },

  main: function(opts){
    var picoOptions = {};

    // Load the html template
    initPico();

    // Initialize the map
    initPicomap();

    picoOptions.selectedArea = {
      areatype: opts.areaType,
      areaname: opts.areaName,
    };

    picoOptions.windturbineRestrictions = {
      awayFromBuildings:1,
      buildingMinDistance:400,
      awayFromExistingTurbines:0,
      awayFromAirportAndRadar:0,
      awayFromInfrastructure:0,
      outsideNatureReserver:0,
      onlyInAgriculturalarea:0
    };

    picoOptions.showMaps = [];
    picoInitWindenergy(picoOptions);
  }
};
