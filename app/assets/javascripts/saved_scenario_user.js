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
    showModal(this.dataset.formUrl, 250, 550);

    event.preventDefault();
  });

  // Perform a request to update an existing SavedScenarioUser
  $('#saved_scenario_users_table').on('change', '.update-saved-scenario-user', function(event) {
    $(this).parent().parent().trigger('submit');

    event.preventDefault();
  });
});
