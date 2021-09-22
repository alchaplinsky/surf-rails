_ = require('underscore')
$ = require('jquery')
Marionette = require('backbone.marionette')
MediumEditor = require('medium-editor')
Hashtagable = require('./../../../behaviors/hashtagable')

class Form extends Marionette.View

  getTemplate: ->
    require "./../../../templates/mainbar/details/#{@getType()}.hbs"

  className: 'editorial'

  ui:
    title: 'input[name=title]'
    description: 'textarea[name=description]'
    text: 'textarea[name=text]'
    tags: 'input[name=tag_list]'

  behaviors:
    Hashtagable:
      behaviorClass: Hashtagable

  delay: 1000

  templateContext: ->
    readonly: @options.readonly
    tags: @getTags()

  initialize: ->
    @onKeyUpField = _.debounce @onStopTyping, @delay

  onRender: ->
    @$el.addClass('link') if @model.getType() is 'link'
    unless @options.readonly
      @editor = new MediumEditor(@ui.text)
    _.delay @bindKeyUp, 100

  bindKeyUp: =>
    $('.medium-editor-element, .js-input').on 'keyup', @onKeyUpField

  onStopTyping: =>
    @ui.title.removeClass('error')
    $('.error-message').empty()
    @savePost()

  getType: ->
    @model.getType()

  postAttributes: ->
    attributes = tag_list: @ui.tags.val()
    _.extend attributes, @["#{@model.getType()}Attrs"]()

  linkAttrs: ->
    link_attributes:
      title: @ui.title.val()
      description: @ui.description.val()

  noteAttrs: ->
    note_attributes:
      title: @ui.title.val()
      text: @ui.text.val()

  imageAttrs: ->
    image_attributes:
      title: @ui.title.val()

  attachmentAttrs: ->
    attachment_attributes:
      title: @ui.title.val()

  savePost: ->
    @model.interest = @options.interest
    @model.save(submission: @postAttributes()).fail (response) =>
      for key, errors of response.responseJSON.errors
        @ui[key].addClass('error')
        @$("label[for=#{key}] .error-message").text(errors[0])

  getTags: ->
    _.map(@model.get('tags'), (tag) ->
      "##{tag.name}"
    ).join(' ')

module.exports = Form
