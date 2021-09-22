Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Interest = require('./interest')

class Interests extends Marionette.CollectionView
  className: 'interests'
  tagName: 'ul'

  childView: Interest

  childViewEvents:
    'select:item': 'onItemClick'

  initialize: ->
    @channel = Radio.channel('basic')
    @channel.on 'select:interest', @onSelectInterest

  onRender: ->
    @$el.find("li[data-id=#{@collection.getCurrent().id}]").addClass('current')

  onSelectInterest: =>
    @render()

  onItemClick: (child) ->
    return if child.model is child.model.collection.getCurrent()
    @collection.setCurrent child.model
    @channel.trigger 'select:interest', child.model

module.exports = Interests
