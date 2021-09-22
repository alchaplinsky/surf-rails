Marionette = require('backbone.marionette')
Tags = require('./../collections/tags')
List = require('./../views/mainbar/workarea/tags/list')

class Hashtagable extends Marionette.Behavior

  delimiter: '#'

  ui:
    field: '.js-hashtagable'

  events:
    'keyup @ui.field': 'onKeyUpField'
    'keydown @ui.field': 'onKeyDown'
    'keypress @ui.field': 'onKeyPressField'
    'click .item': 'onClickSuggestion'

  initialize: ->
    @view.regions = {}
    @view.regions['suggestionsRegion'] = '.js-suggestions'
    @tags = new Tags()
    @view.isSuggestionsActive = @isSuggestionsActive

  onKeyUpField: (event) ->
    if [13, 16, 37, 38, 39, 40].indexOf(event.keyCode) is -1
      @autocomplete()

  onKeyDown: (event) ->
    if @isSuggestionsActive()
      switch event.keyCode
        when 38
          event.preventDefault()
          @tags.selectNext()
        when 40
          event.preventDefault()
          @tags.selectPrev()

  onKeyPressField: (event) ->
    if event.keyCode is 13 and @isSuggestionsActive()
      event.preventDefault()
      @applyTag() unless event.shiftKey

  onClickSuggestion: ->
    @applyTag()

  isSuggestionsActive: =>
    @tags.length isnt 0

  applyTag: ->
    string = @getFieldValue().substr 0, @getPositions()[0]
    @ui.field.val "#{string}#{@tags.getCurrent().get('name')}"
    setTimeout =>
      @resetSuggestions()
    , 50

  renderSuggestions: ->
    @view.showChildView 'suggestionsRegion', new List collection: @tags

  autocomplete: (event) ->
    @renderSuggestions() unless @isSuggestionsRendered()
    if @isHashTagPresent()
      @getSuggestions @getHashTagQuery()
    else
      @resetSuggestions()

  isSuggestionsRendered: ->
    @view.getChildView('suggestionsRegion')?

  isHashTagPresent: ->
    @getFieldValue().match(@delimiter)? and @getHashTagQuery() isnt ''

  getHashTagQuery: ->
    positions = @getPositions()
    @resetSuggestions() if positions[0] is positions[1]
    @getFieldValue().substring positions[0], positions[1]

  caretPosition: ->
    @ui.field.prop("selectionStart") + 1

  getFieldValue: ->
    @ui.field.val()

  getSuggestions: (query) ->
    unless query is ' '
      @tags.fetch data: query: query

  getPositions: ->
    value = @getFieldValue()
    for i in [@caretPosition()..0]
      if value[i] is @delimiter
        start = i + 1
        break
      if value[i] is ' '
        start = @caretPosition()
        break
    [start, @caretPosition()]

  resetSuggestions: ->
    @tags.reset null

module.exports = Hashtagable
