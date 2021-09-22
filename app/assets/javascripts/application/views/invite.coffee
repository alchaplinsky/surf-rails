Radio = require('backbone.radio')
View = require('./base')
Model = require('./../models/invite')

class Invite extends View

  getTemplate: ->
    require "./../templates/invite.hbs"

  ui:
    states: '.js-states'
    email: '.js-email'
    field: '.js-field'
    input: '.js-input'
    error: '.js-error'
    button: '.js-button'

  events:
    'click @ui.button': 'onClickSend'

  templateContext: ->
    image: require('images/invite_friends@2x.png')

  initialize: ->
    @channel = Radio.channel('basic')
    @invite = new Model

  onClickSend: ->
    return if @isLoading()
    return if @isEmptyField()
    @showLoading()
    @invite.save(email: @ui.input.val()).done =>
      @ui.email.text @invite.get('email')
      @ui.states.addClass('switched')
    .fail (response) =>
      @hideLoading()
      @handelErrorResponse(response)

  isEmptyField: ->
    @ui.input.val() is ''

  isLoading: ->
    @ui.field.hasClass('loading')

  showLoading: ->
    @ui.field.addClass('loading')
    @ui.button.addClass('disabled')

  hideLoading: ->
    @ui.field.removeClass('loading')
    @ui.button.removeClass('disabled')

  showValidationError: (errors) ->
    @ui.input.addClass('error')
    @ui.error.html "<div class='error-message'>#{errors.email.join(', ')}</div>"

  handelErrorResponse: (response) ->
    error = response.responseJSON
    if error.type is 'validation'
      @showValidationError(error.errors)
    else
      @channel.trigger 'request:error', response

module.exports = Invite
