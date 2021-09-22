$ = require('jquery')
Radio = require('backbone.radio')
Main = require('./modules/main')
Error = require('./views/error')

class Surf

  constructor: (@settings) ->
    @subscribe()
    @launchMainModule()

  subscribe: ->
    @channel = Radio.channel('basic')
    @channel.on 'request:error', @onRequestError
    @channel.on 'application:retry', @launch

  ##############################################################################
  onRequestError: (response) =>
    @handleErrorResponse(response)

  ##############################################################################
  notificationsUrl: (apiToken) ->
    "#{@settings.apiHost}/cable?token=#{apiToken}"

  launchMainModule: ->
    @module.destroy() if @module?
    @module = new Main(@settings)

  handleErrorResponse: (response) ->
    switch response.status
      when 401
        window.location.assign '/login'
      when 500
        @renderError('Oops, unexpected error occurred')
      else
        @renderError('Could not establish connection to server')

  renderError: (message) ->
    @error = new Error el: $('#body'), message: message
    @error.render()

module.exports = Surf
