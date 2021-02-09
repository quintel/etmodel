/* globals $*/

$(function () {
  var esdlForm = $('form#import_esdl');

  if (esdlForm.length > 0) {
    // Show loading wheel when starting a scenario
    esdlForm.on('submit', function (e) {
      var form = $(e.target);

      form.find('input[type=submit]').remove();
      form.find('.wait').show();
    });

    // Add the ability to clear the uploaded file field by showing a small
    // x ('span') when the upload-file field is filled.
    if (esdlForm.find('input[type=file]').val()) {
      esdlForm.find('span').show();
    }
    esdlForm.find('span').on('click', function () {
      esdlForm.find('input[type=file]').val('');
      $(this).hide();
    });
    esdlForm.find('input[type=file]').on('input', function () {
      esdlForm.find('span').show();
    });

    // When the page is reloaded, make sure we don't have a now-hidden file
    // selected in the browse Mondaine Drive option
    esdlForm.find('input[name=mondaine_drive_path]').val('');
  }
});

$(function () {
  var mondaineDrive = $('#mondaine_drive');

  if (mondaineDrive.length > 0) {
    browseMondaineDrive($('form#import_esdl'));

    if (mondaineDrive.hasClass('disabled')) {
      mondaineDrive.find('a').on('click', false);
    } else {
      mondaineDrive.find('a').off('click', false);
    }
  }
});

// Browsing the Mondaine Drive
// selectType can be either 'file' or 'folder'
function browseMondaineDrive(form, selectFolder = false) {
  var folders = $('.folder__true');

  if (folders.length > 0) {
    folders.on('click', expandFolder);
  }

  // When a folder is clicked, check if we have already collected its children.
  // If so, we can show/hide them. If not, we have to collect the folders children
  // from the server and create them in the DOM
  function expandFolder() {
    var folder = $(this);
    swapIcon(folder);

    if (folder.next('.children').length > 0) {
      folder.next().toggle(30);
      // When imploding a folder, 'deselect' the 'selected' file within
      folder.next().find('.selected').removeClass('selected');
    } else if (!folder.data('pending')) {
      folder.data('pending', true);

      $.ajax({
        type: 'GET',
        url: '/esdl_suite/browse',
        data: { path: folder.data('id') },
        dataType: 'json',
        success: function (children) {
          folder.after(createChildrenNode(children));
          folder.data('pending', false);
        },
        error: function () {
          // Error mostly occurs when a users esdl suite credentials are expired
          // Refresh page to have them log in again
          folder.off('click', false);
          folder.addClass('folder__false').removeClass('folder__true');
          swapIcon(folder.find('span'));
          folder.data('pending', false);
          window.location.reload();
        },
      });
    }
  }

  // When an element is clicked (selected), add a 'selected' class, and remove the
  // 'required' property from the 'Browse my computer' input. Vice-versa
  // when the element is de-selected.
  function selectElement() {
    var file = $(this);
    var esdlForm = $(form);

    if (file.hasClass('selected')) {
      file.removeClass('selected');
      esdlForm.find('input[type=file]').prop('required', true);
      esdlForm.find('input[name=mondaine_drive_path]').val('');
    } else {
      $('.selected').removeClass('selected');
      file.addClass('selected');
      esdlForm.find('input[type=file]').removeAttr('required');
      esdlForm.find('input[name=mondaine_drive_path]').val(file.data('id'));
    }
  }

  // Create a div.children containing new files and folders to be
  // inserted in the DOM after its parent folder
  function createChildrenNode(children) {
    var childrenNode = $('<div></div>').addClass('children');

    $.each(children, function (_index, child) {
      var icon = $('<span></span>').addClass('fa fa-' + child['type'].split('-')[0]);
      var childNode = $('<div></div>').append(icon).append(child['text']);

      childNode.addClass(child['type'] + '__' + child['children']);
      childNode.data(child);

      if (child['type'] == 'folder' && child['children']) {
        childNode.on('click', expandFolder);
      } else if (child['type'] == 'folder' && !child['children']) {
        childNode.append(' (empty)');
        if (selectFolder) {
          childNode.addClass('hover-pointer');
          childNode.on('click', selectElement);
        }
      } else if (child['type'] == 'file-esdl' && !selectFolder) {
        childNode.on('click', selectElement);
      }
      childrenNode.append(childNode);
    });

    return childrenNode;
  }

  // Swaps open and closed folder icons, and keeps track of the folder being selected if
  // possible
  function swapIcon(folder) {
    var icon = folder.find('span');

    if (icon.hasClass('fa-folder')) {
      icon.addClass('fa-folder-open').removeClass('fa-folder');

      if (selectFolder) {
        $('.selected').removeClass('selected');
        folder.addClass('selected');
        $(form).find('input[name=mondaine_drive_path]').val(folder.data('id'));
      }
    } else {
      icon.addClass('fa-folder').removeClass('fa-folder-open');
    }
  }
}
