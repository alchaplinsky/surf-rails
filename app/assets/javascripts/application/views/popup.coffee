Radio = require('backbone.radio')
View = require('./base')

class Popup extends View

  getTemplate: ->
    require "./../templates/popup.hbs"

  className: 'overlay'

  ui:
    close: '.js-close'

  events:
    'click @ui.close': 'onClickClose'

  regions:
    contentRegion: '.js-content-region'

  initialize: ->
    @channel = Radio.channel('basic')
    @channel.once 'created:interest', @onDone
    @channel.once 'updated:interest', @onDone
    @channel.once 'deleted:interest', @onDone
    @channel.once 'deleted:post', @onDone
    @channel.once 'close:popup', @onDone

  onRender: ->
    @showChildView 'contentRegion', @options.view

  onClickClose: ->
    @destroy()

  onDone: =>
    @destroy()

module.exports = Popup
