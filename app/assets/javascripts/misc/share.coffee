window.Surf = {}
class window.Surf.Share

  facebookUrl: 'https://www.facebook.com/sharer/sharer.php?u='
  linkedinUrl: 'https://www.linkedin.com/shareArticle?mini=true&url='
  googleUrl: 'https://plus.google.com/share?url='
  twitterUrl: 'https://twitter.com/intent/tweet?text='

  constructor: (@url) ->
    $(document).on 'click', '.share-button.icon-facebook', => @shareFacebook()
    $(document).on 'click', '.share-button.icon-linkedin', => @shareLinkedin()
    $(document).on 'click', '.share-button.icon-google-plus', => @shareGoogle()
    $(document).on 'click', '.share-button.icon-twitter', (event) => @shareTwitter(event)

  shareFacebook: ->
    @share("#{@facebookUrl}#{@url}", 'Facebook')

  shareLinkedin: ->
    @share("#{@linkedinUrl}#{@url}", 'LinkedIn')

  shareGoogle: ->
    @share("#{@googleUrl}#{@url}", 'Google+')

  shareTwitter: (event) ->
    title = $(event.currentTarget).data('title')
    text = "#{title} via @surfappio #{@url}"
    @share("#{@twitterUrl}#{text}", 'Twitter')

  share: (url, title) ->
    window.open(url, title, "height=400,width=550")
