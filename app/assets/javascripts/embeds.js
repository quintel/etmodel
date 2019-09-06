/*
  This script is used for receiving messages from iframes and updating
  settings in the ETM. It uses the postMessage browser API for receiving cross
  domain messages.
  To add an additional message handler all you have to do is add a function to
  the actions object. Be aware that an action can only be provided with a single
  argument. The however can be an array or map but can't (or shouldn't) contain
  functions.

  The messages have to conform to a specific schema.
    - An action key is required and should match an action declared in this file.
    - An argument key with value is required and its schema is dependent on the
      matching action below.

  Below is an example message.

  * {
  *   action: "updateInlandWindTurbine",
  *   argument: {
  *     power: pico.inMegaWatt(power)
  *   }
  * }

*/

var embeds = {
  attach: function(){
    window.addEventListener('message', embeds.receiveMessage, true);
  },

  detach: function(){
    window.removeEventListener('message', embeds.receiveMessage, true);
  },

  /*
    dependencies:
     - jquery
     - fancybox
  */
  close: function(event){
    $.fancybox.close();
  },

  receiveMessage: function(event){
    var actionName      = event.data.action;
    var actionArgument  = event.data.argument;
    if(embeds.actionIsAvailable(actionName)){
      embeds.actions[actionName](actionArgument);
    } else {
      console.log("Unhandled postMessage action: ", actionName);
    }
  },

  /*
    All properties of the actions object will automaticly be available in the
    API and callable by cross domain embeds. Its advisable not to polute.
  */
  actions: {
    // Updates a slider and closes the modal.
    updateInlandWindTurbine: function(argument){
      var inputElement = App.input_elements
              .find_by_key('capacity_of_energy_power_wind_turbine_inland');
      inputElement.set({user_value: argument.power});
      embeds.close();
    },

    // Can be used as an event to close the modal from inside the embed.
    // e.g. the back action inside an embed.
    closeModal: function(argument){
      embeds.close();
    },

    // Method for debugging from external embed.
    sendError: function(argument){
      console.log(argument);
    },
  },

  // Helper functions
  availableActions: function(){
    return Object.getOwnPropertyNames(embeds.actions);
  },

  actionIsAvailable: function(actionName){
    return embeds.availableActions().indexOf(actionName) !== -1;
  },
};
