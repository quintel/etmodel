(function(){
  // I dislike having a hard link in this location. Maybe we should add a class
  // to the link that enables us to pick up the link and use it below.
  picoLinkSelector = 'a[href$="/embeds/pico"]'

  $(document).ready(function () {
    $(picoLinkSelector).fancybox({ href: '/embeds/pico',
                                   type: 'iframe',
                                   minHeight: 500 })
    embeds.attach()
  })
}())
