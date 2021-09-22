$ = require('jquery')
autosize = require('autosize')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Post = require('./../../../models/post')
Hashtagable = require('./../../../behaviors/hashtagable')

class Form extends Marionette.View

  getTemplate: ->
    require './../../../templates/mainbar/workarea/form.hbs'

  behaviors:
    Hashtagable:
      behaviorClass: Hashtagable

  ui:
    enter: '.js-enter'
    field: '.js-post-text'
    suggestions: '.js-suggestions'

  events:
    'click @ui.enter': 'handleEnterKey'
    'keypress @ui.field': 'onKeyPressField'

  initialize: ->
    @interest = @options.interest
    @posts = @options.posts
    @channel = Radio.channel('basic')
    @channel.on 'select:interest', @onSelectInterest
    @buildPost()

  ##############################################################################
  onRender: ->
    autosize(@ui.field)

  onSelectInterest: (interest) =>
    @post.interest = @interest = interest

  onKeyPressField: (event) ->
    if event.keyCode is 13 and !event.shiftKey
      event.preventDefault()
      @handleEnterKey(event)

  handleEnterKey: (event) ->
    return if @ui.field.val() is ''
    @submitPost() unless @isSuggestionsActive()

  submitPost: ->
    @publishPost()
    @clearField()
    @savePost()

  buildPost: ->
    @post = new Post
    @post.interest = @interest

  clearField: ->
    @ui.field.val('').css('height', 'auto').focus()

  publishPost: ->
    regex = new RegExp('\n', 'g')
    @post.set text: @ui.field.val().replace(regex, "<br />")
    @posts.add @post

  savePost: ->
    @post.save().done =>
      @channel.trigger 'created:post'
      @buildPost()
    .fail (response) =>
      @post.set failed: true

module.exports = Form
