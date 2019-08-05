// requires jquery
embeddedPico = {
  attach: function(){
    document.getElementById('host-form')
            .addEventListener('submit', embeddedPico.submit, false)

    document.getElementById('close-modal')
            .addEventListener('click', embeddedPico.close, false)

    document.addEventListener("message", receiveMessag, false);
  },

  submit: function(event){
    // Collect data from form.
    var formData = $("#host-form").serializeArray()
                                  .reduce(function(memo, item){
      memo[item.name] = item.value
      return memo
    }, {action: 'updateForm'} )

    // add unchecked checkboxes to the data.
    document.querySelectorAll("#host-form input[type='checkbox']")
            .forEach( function(cb){
      if(!formData[cb.name]) formData[cb.name] = 0
    })

    document.getElementById("selframe")
            .contentWindow
            .postMessage(formData, "http://localhost:3000")
    setTimeout(embeddedPico.close, 100)
  },

  close: function(event){
    document.getElementsByClassName("modal__backdrop")[0].remove()
    event.preventDefault()
  },

  updateInlandWindTurbine: function(new_value){
    ie = App.input_elements
            .find_by_key('capacity_of_energy_power_wind_turbine_inland')
    ie.set({user_value: new_value})
  },

  receiveMessage: function(event){
    console.log("receive")
    event.preventDefault()
    embeddedPico.updateInlandWindTurbine(event.data)
  }
}
