/*
  This script is used for receiving messages from iframes and updating
  various settings in the ETM.
  It uses the postMessage browser API.

  To add an additional action all you have to do is add a property to the
  actions object. Be aware that an action can only be provided with a single
  argument. The argument however can be an array or map.

  At the time of writing the "hook" that activates the code lives in the
  Embeds::PicosController. wich gets

  Example message:
  { action: "updateInlandWindTurbine",
    argument: {
      power: pico.inMegaWatt(power),
    },
  }
*/

// requires jquery
embeds = {
  attach: function(){
    document.getElementById('close-modal')
          .addEventListener('click',   embeds.close,          false)
    window.addEventListener('message', embeds.receiveMessage, false)
  },

  close: function(event){
    document.getElementsByClassName("modal__backdrop")[0].remove()
    if(event != undefined){ event.preventDefault() }
  },

  receiveMessage: function(event){
    actionName      = event.data["action"]
    actionArgument  = event.data["argument"]
    if(embeds.actionIsAvailable(actionName)){
      embeds.actions[actionName](actionArgument)
    } else {
      console.log("Unhandled postMessage action: ", actionName)
    }
  },

  /*
    All properties of the actions object will automaticly be available in the
    API. Its advisable not to polute it with methods that don't have to be
    public.
  */
  actions: {

    // Updates a slider and closes the modal.
    updateInlandWindTurbine: function(argument){
      var inputElement = App.input_elements
              .find_by_key('capacity_of_energy_power_wind_turbine_inland')
      inputElement.set({user_value: argument.power})
      embeds.close()
    },

    // Can be used as an event to close the modal from inside the embed.
    // e.g. the back action inside an embed.
    closeModal: function(argument){
      embeds.close()
    },

    // Method for debugging from external embed.
    sendError: function(argument){
      console.log(argument)
    },
  },

  // Meta methods dealing with actions
    availableActions: function(){
      return Object.getOwnPropertyNames(embeds.actions)
    },

    actionIsAvailable: function(actionName){
      return embeds.availableActions().includes(actionName)
    },
  // end meta methods
}
