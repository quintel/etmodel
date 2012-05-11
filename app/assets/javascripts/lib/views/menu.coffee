$(document).ready ->
  accordion = $('#sidebar h4').on 'click', () ->
    $(this).next('ul').toggle()