$ = require('jquery')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')

class Contextable extends Marionette.Behavior

  ui:
    toggle: '.js-context-toggle'
    context: '.js-context'

  events:
    'click @ui.toggle': 'onClickToggle'

  initialize: ->
    @channel = Radio.channel('basic')
    @channel.on 'post:out:of:focus', @onOutOfFocus
    @view.hideContextMenu = @hideContextMenu

  onClickToggle: (event) ->
    event.stopPropagation()
    @showContextMenu()

  onDocumentClick: (event) =>
    return if event.target is @ui.context[0]
    return if event.currentTarget is @ui.toggle[0]
    return if $.contains(@ui.context[0], event.target)
    @hideContextMenu()

  onOutOfFocus: (model) =>
    @hideContextMenu() if model is @view.model and @contextIsShown()

  showContextMenu: ->
    @ui.context.addClass('shown')
    @bindDocument()

  hideContextMenu: =>
    @ui.context.removeClass('shown')
    @unbindDocument()

  contextIsShown: ->
    return false if typeof @ui.context is 'string'
    @ui.context.length isnt 0

  bindDocument: ->
    $(document).on 'click', @onDocumentClick

  unbindDocument: ->
    $(document).off 'click', @onDocumentClick

module.exports = Contextable
