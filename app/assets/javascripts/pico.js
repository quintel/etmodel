var pico = {
  ready: function(){
    node = document.getElementById("picoturbinecount")
    power = node.textContent.replace(/\./g,"")
    window.parent.postMessage(pico.message(power))
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
    }
  },


  /* TODO: this conversion of turbinecount to megawatts is hardcoded now.
           Ask the API!
     V(energy_power_wind_turbine_inland, electricity_output_capacity) */
  inMegaWatt: function(turbines){
    return turbines * 3.0
  },

  main: function(opts){
    pico.areaType = opts.areaType,
    pico.areaName = opts.areaName

    // Load the html template
    initPico()

    // Initialize the map
    initPicomap();

    // Initialize the windturbine module with a specified area
    // areatype:'gemeente', areaname:'Neder-Betuwe', areacode:'1740'
    var selectedArea = {
      areatype: pico.areaType,
      areaname: pico.areaName
    }
    picoInitWindenergy(selectedArea);
  }
}
