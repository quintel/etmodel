(function() {
  function receiveMessage(event){
    alert(event.data)
  }
  window.addEventListener("message", receiveMessage, false);
}())
