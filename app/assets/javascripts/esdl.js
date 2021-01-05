/* globals $*/

$(function() {
  var esdlForm = $('form#import_esdl');

  if (esdlForm.length) {
    esdlForm.submit(function(e) {
      //also check for mondaine drive
      var form = $(e.target);

      form.find('input[type=submit]').remove();
      form.find('.wait').show();
    });

    esdlForm.find('.upload_file').hover(
      function() {
        $('#mondaine_drive').addClass('soften');
      },
      function() {
        $('#mondaine_drive').removeClass('soften');
      }
    );
  }
});

$(function() {
  var mondaineDrive = $('#mondaine_drive');

  if (mondaineDrive.length) {
    if (mondaineDrive.hasClass('disabled')) {
      mondaineDrive.find('a').bind('click', false);
    } else {
      mondaineDrive.find('a').unbind('click', false);

      mondaineDrive.hover(
        function() {
          $('#import_esdl .upload_file').addClass('soften');
        },
        function() {
          $('#import_esdl .upload_file').removeClass('soften');
        }
      );
    }
  }
});

$(function() {
  var folders = $('.folder__true');

  if (folders.length) {
    $.each(folders, function(_index, folder) {
      $(folder).bind('click', expandFolder);
    });
  }

  function expandFolder() {
    var folder = $(this);
    swapIcon(folder.find('span'));

    if (folder.next('.children').length) {
      folder.next().toggle(30);
    } else if (!folder.data('pending')) {
      folder.data('pending', true);

      $.ajax({
        type: 'GET',
        url: '/esdl_suite/browse',
        data: { path: folder.data('id') },
        success: function(children) {
          folder.after(createChildrenNode(children));
          folder.data('pending', false);
        }
      });
    }
  }

  function selectFile() {
    var file = $(this);
    if (file.hasClass('selected')) {
      file.removeClass('selected');
    } else {
      $.each($('.selected'), function() {
        $(this).removeClass('selected');
      });
      file.addClass('selected');
    }
  }

  function swapIcon(icon) {
    if (icon.hasClass('fa-folder')) {
      icon.addClass('fa-folder-open').removeClass('fa-folder');
    } else {
      icon.addClass('fa-folder').removeClass('fa-folder-open');
    }
  }

  function createChildrenNode(children) {
    var childrenNode = $('<div></div>').addClass('children');

    $.each(children, function(_index, child) {
      var icon = $('<span></span>').addClass('fa fa-' + child['type'].split('-')[0]);
      var childNode = $('<div></div>')
        .append(icon)
        .append(child['text']);

      childNode.addClass(child['type'] + '__' + child['children']);
      childNode.data(child);

      if (child['type'] == 'folder' && child['children'] == true) {
        childNode.bind('click', expandFolder);
      } else if (child['type'] == 'file-esdl') {
        childNode.bind('click', selectFile);
      }
      childrenNode.append(childNode);
    });

    return childrenNode;
  }
});
