var pico = {
  ready: function(){
    node = document.getElementById("picoturbinecount")
    power = node.textContent
    window.parent.postMessage(pico.message(power))
  },

  message: function(power){
    return {
      action: "updateInlandWindTurbine",
      power: pico.inMegaWatt(power),
      description: "This data is used to update the windturbine power slide " +
                   "in the Enegy transition model. The unit of which power " +
                   "represents the magnitute is Mega Watt"
    }
  },

  inMegaWatt: function(turbines){
    // source: V(energy_power_wind_turbine_inland, electricity_output_capacity)
    return turbines * 3.0
  }
}
