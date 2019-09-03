// requires jquery
embeddedPico = {
  attach: function(){
    document.getElementById('close-modal')
            .addEventListener('click',   embeddedPico.close,          false)
    window.addEventListener(  'message', embeddedPico.receiveMessage, false)
  },

  close: function(event){
    document.getElementsByClassName("modal__backdrop")[0].remove()
    if(event != undefined){ event.preventDefault() }
  },

  updateInlandWindTurbine: function(new_value){
    var ie = App.input_elements
            .find_by_key('capacity_of_energy_power_wind_turbine_inland')
    ie.set({user_value: new_value})
  },

  receiveMessage: function(event){
    message = event.data

    if(message["action"] === "updateInlandWindTurbine"){
      embeddedPico.updateInlandWindTurbine(message.power)

      // close modal
      embeddedPico.close()

      // destruct event listener after use.
      event.currentTarget
           .removeEventListener(event.type, embeddedPico.receiveMessage)

    // Log something ifthe postMessage action is isn't handled.
    } else {
      console.log("Unhandled postMessage action")
    }
  }
}
