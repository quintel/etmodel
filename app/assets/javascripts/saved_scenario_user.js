function showModal(url, height, width) {
  $.fancybox.open({
    href: url,
    type: 'ajax',
    autoSize: false,
    height: height,
    width: width,
    padding: 0
  });
}

$(function() {
  // Render the 'New SavedScenarioUser' view in a modal
  $('.show-new-saved-scenario-user-form').on('click', function(event) {
    showModal(this.dataset.formUrl, 450, 550);

    event.preventDefault();
  });

  // Render the 'Remove SavedScenarioUser' view in a modal
  $('#saved_scenario_users_table').on('click', '.remove-saved-scenario-user', function(event) {
    if (!$(this).parent().hasClass('disabled')){
      showModal(this.dataset.formUrl, 250, 550);
    }

    event.preventDefault();
  });

  // Perform a request to update an existing SavedScenarioUser
  $('#saved_scenario_users_table').on('change', '.update-saved-scenario-user', function(event) {
    event.preventDefault();

    const selectInput = this;
    const selfOwnerRow = $('#saved_scenario_users_table .owner');

    const formUrl = $(selectInput).parent().parent()[0].action;
    const updateValues = $(selectInput).parent().parent().serialize();
    const checkMark = $(selectInput).parent().parent().parent().find('.checkmark');
    const cross = $(selectInput).parent().parent().parent().find('.cross');

    $.ajax({
      url: formUrl + '?' + updateValues,
      method: 'PUT',
      dataType: 'text',
      success: function () {
        $(checkMark).fadeIn();
        checkForDisabled(selectInput, selfOwnerRow);

        setTimeout( function () {
          $(checkMark).fadeToggle();
        }, 3000);
      },
      error: function (response) {
        console.log('Failed to update!');
        console.log(response);

        $(cross).fadeIn();

        setTimeout( function () {
          $(cross).fadeToggle();
        }, 3000);

      }
    });
  });

  // Checks which fields should become disabled/enabled after role changes
  function checkForDisabled(selectInput, selfOwnerRow) {
    let selectSelfOwner = selfOwnerRow.find('.update-saved-scenario-user');
    let trashSelfOwner = selfOwnerRow.find('.remove');

    let ownerValue = selectSelfOwner[0].value;
    let allOwners = $('.update-saved-scenario-user').filter( (_, elem) =>
      {
        return elem.value == ownerValue
      }
    )

    // Lock all options if user changes their own role
    if (selectSelfOwner[0] === selectInput){
      $.each($('.update-saved-scenario-user'), (_, elem) => {
        elem = $(elem);
        elem.prop('disabled', true);
        elem.addClass('disabled');
      })
      $('.remove').addClass('disabled');
    } // Unlock self-role when not the only owner anymore
    else if (selectSelfOwner.prop('disabled') && selectInput.value == ownerValue) {
      selectSelfOwner.prop('disabled', false);
      selectSelfOwner.removeClass('disabled');
      trashSelfOwner.removeClass('disabled');
    } // Lock when becoming only owner
    else if (allOwners.length == 1) {
      selectSelfOwner.prop('disabled', true);
      selectSelfOwner.addClass('disabled');
      trashSelfOwner.addClass('disabled');
    }
  }
});
