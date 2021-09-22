Marionette = require('backbone.marionette')

class Item extends Marionette.View
  className: 'item'
  getTemplate: ->
    require './../../../../templates/mainbar/workarea/tags/item.hbs'

  events:
    'mouseover': 'onHoverItem'

  initialize: ->
    @listenTo @model, 'change:current', @render

  onRender: ->
    if @model.get('current')?
      @$el.toggleClass 'current', @model.get('current')

  onHoverItem: ->
    @model.collection.setCurrent @model

module.exports = Item
