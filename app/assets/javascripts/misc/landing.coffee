$ ->
  if document.location.pathname is '/'
    $(window).on 'scroll', ->
      if $('body').scrollTop() > 0
        $('.navbar').addClass 'is-sticky'
      else
        $('.navbar').removeClass 'is-sticky'
