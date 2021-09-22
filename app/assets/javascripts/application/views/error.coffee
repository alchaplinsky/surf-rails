Radio = require 'backbone.radio'
Marionette = require 'backbone.marionette'

class Error extends Marionette.View

  getTemplate: ->
    require './../templates/error.hbs'

  ui:
    tryAgainButton: '.js-try-again'

  events:
    'click @ui.tryAgainButton': 'onClickTryAgain'

  templateContext: ->
    image: require('images/logo.png')
    message: @options.message

  initialize: ->
    @channel = Radio.channel('basic')

  onClickTryAgain: ->
    @channel.trigger('application:retry')

module.exports = Error
