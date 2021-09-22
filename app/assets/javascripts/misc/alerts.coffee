$ ->
  setTimeout ->
    $('.alert, .notice').addClass('shown')
    setTimeout ->
      $('.alert, .notice').removeClass('shown')
    , 3000
  , 500
