Marionette = require('backbone.marionette')

class Interest extends Marionette.View
  tagName: 'li'

  getTemplate: -> require('./../../templates/sidebar/interest.hbs')

  triggers:
    'click': 'select:item'

  initialize: ->
    @listenTo @model, 'sync', @render
    @listenTo @model, 'change:shared', @render

  onRender: ->
    @$el.attr('data-id', @model.id)

module.exports = Interest
