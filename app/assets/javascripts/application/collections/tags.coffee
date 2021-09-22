Backbone = require('backbone')

class Tags extends Backbone.Collection
  url: "/api/v1/tags"

  parse: (response) ->
    if response.length > 0
      response[0].current = true
    response

  getCurrent: ->
    @findWhere(current: true)

  setCurrent: (model) ->
    @getCurrent()?.set 'current', false
    model.set 'current', true

  selectPrev: ->
    prevModel = @at @indexOf(@getCurrent()) + 1
    if prevModel then @setCurrent(prevModel) else @setCurrent(@first())

  selectNext: ->
    prevModel = @at @indexOf(@getCurrent()) - 1

    if prevModel then @setCurrent(prevModel) else @setCurrent(@last())

module.exports = Tags
