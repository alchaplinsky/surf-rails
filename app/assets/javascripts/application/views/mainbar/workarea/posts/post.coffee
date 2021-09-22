Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Author = require('./author')
Tags = require('./tags')
Text = require('./text')

class Post extends Marionette.View

  getTemplate: ->
    require "../../../../templates/mainbar/posts/#{@model.getType()}.hbs"

  className: 'post'

  regions:
    author: '.js-author-region'
    text: '.js-text-region'
    tags: '.js-tags-region'

  ui:
    retry: '.js-retry'

  events:
    'click': 'onClickDetails'
    'click @ui.retry': 'onClickRetry'
    'click a': 'onClickLink'
    'mouseleave': 'onMouseLeave'

  urlPattern: /(http|ftp|https:\/\/[\w\-_]+\.{1}[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/gi

  initialize: ->
    @channel = Radio.channel('basic')
    @listenTo @model, 'sync', @render
    @listenTo @model, 'change:failed', @onPostFailed
    @listenTo @model, 'change:current', @render

  templateContext: ->
    text: @formattedText()
    textPresent: => @model.get('text') isnt ''

  ##############################################################################
  onRender: ->
    @setClassNames()
    @renderAuthor()
    @renderText()
    @renderTags()

  onPostFailed: =>
    @render()

  onClickRetry: =>
    @model.set failed: false
    @model.save().done =>
      @channel.trigger 'created:post'
    .fail (response) =>
      @model.set failed: true

  onClickLink: (event) ->
    event.stopPropagation()

  onClickDetails: ->
    @model.collection.setCurrent @model
    @channel.trigger 'show:details', @model

  onMouseLeave: ->
    @channel.trigger 'post:out:of:focus', @model

  onChildviewClickTag: (view, event) ->
    @model.collection.trigger 'selected:tag', event.currentTarget.textContent

  ##############################################################################
  renderAuthor: ->
    if @model.get('owner')?
      @showChildView 'author', new Author model: @model

  renderText: ->
    if !@model.isPending() and @model.getType() isnt 'note' and @model.getType() isnt 'image'
      @showChildView 'text', new Text model: @model

  renderTags: ->
    if !@model.isPending() and @model.tagsPresent()
      @showChildView 'tags', new Tags model: @model

  setClassNames: ->
    @$el.removeClass 'failed raw'
    @$el.addClass @model.getType()
    @$el.toggleClass 'current', (@model.get('current') is true)

  formattedText: ->
    text = @model.get('text')
    textWithoutUrls = text.replace @urlPattern, ''
    return '' if textWithoutUrls is '' and @model.get('link')
    @wrapURLs(text)

  wrapURLs: (text) ->
    text.replace @urlPattern, (url) ->
      protocol_pattern = /^(?:(?:https?|ftp):\/\/)/i
      href = if protocol_pattern.test(url) then url else 'http://' + url
      '<a href="' + href + '">' + url + '</a>'

module.exports = Post
