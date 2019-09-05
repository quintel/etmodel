// embeds_pico_path is mentioned
(function(){
  picoLinkSelector = 'a[href$="/embeds/pico"]';

  $(document).ready(function () {
    $(picoLinkSelector).fancybox({ href: '/embeds/pico',
                                   type: 'iframe',
                                   minHeight: 500,
                                   afterClose: embeds.detach,
                                   afterLoad: embeds.attach,  });
  });
}());
