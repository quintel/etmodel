$(document).ready(function () {
  
  var time = $('ul.toggle_year').data('time'),
      button;

  if (time == 'present'){   
    button = $('li#present a');
  } else {
    button = $('li#future a');
  }

  button.click(function () {return false;});
  button.addClass('inactive');
});