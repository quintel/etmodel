embeddedPico = {
  attach: function(){
    document.getElementById('host-form')
            .addEventListener('submit', submit(event), false)
    console.log("attached")
    document.getElementById('close-modal')
            .addEventListener('submit', close(event), false)
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
  },

  close: function(event){
    document.getElementByClass("modal__backdrop")
            .remove()
    event.preventDefault()
  },
}

$(document).ready(embeddedPico(attach));
