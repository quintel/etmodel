// requires jquery
embeddedPico = {
  attach: function(){
    document.getElementById('close-modal')
            .addEventListener('click', embeddedPico.close,          false)
    window.addEventListener("message", embeddedPico.receiveMessage, false);
  },

  close: function(event){
    console.log(close)
    document.getElementsByClassName("modal__backdrop")[0].remove()
    if(event != undefined){
      event.preventDefault()
    }
  },

  updateInlandWindTurbine: function(new_value){
    ie = App.input_elements
            .find_by_key('capacity_of_energy_power_wind_turbine_inland')
    ie.set({user_value: new_value})
  },

  receiveMessage: function(event){
    message = event.data

    if(message["action"] === "updateInlandWindTurbine"){
      embeddedPico.updateInlandWindTurbine(message.power)

      console.log("before close ")

      // close modal
      embeddedPico.close()

      console.log("after close")
      console.log("before destructing listener")

      // destruct eventlistener after use.
      event.currentTarget
           .removeEventListener(event.type, embeddedPico.receiveMessage)

      console.log("after destructing listener")
    } else {
      console.log("Unmanaged postMessage action")
    }
  }
}
