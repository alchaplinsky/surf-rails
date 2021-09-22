Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Interest = require('./../../models/interest')

class AddInterest extends Marionette.View
  getTemplate: ->
    require './../../templates/interests/create.hbs'
  ui:
    enter: '.js-enter'
    field: '.js-field'
    input: '.js-interest-name'
    error: '.js-error'

  events:
    'keyup @ui.input': 'onKeyupField'
    'click @ui.enter': 'onClickCreate'

  initialize: ->
    @channel = Radio.channel('basic')
    @interest = new Interest()

  templateContext: ->
    image: require('images/interest@2x.png')

  ##############################################################################
  onKeyupField: (e) ->
    if e.keyCode is 13
      @handleEnterKey()
    else
      @clearErrors()

  onClickCreate: ->
    @handleEnterKey()

  ##############################################################################
  handleEnterKey: ->
    return if @isLoading()
    return if @isEmptyField()
    @showLoading()
    @interest.save(name: @ui.input.val()).done =>
      @collection.add @interest, silent: true
      @collection.setCurrent @interest
      @channel.trigger 'created:interest'
      @channel.trigger 'select:interest', @interest
    .fail (response) =>
      @hideLoading()
      @handelErrorResponse(response)

  handelErrorResponse: (response) ->
    error = response.responseJSON
    if error.type is 'validation'
      @showValidationError(error.errors)
    else
      @channel.trigger 'request:error', response

  isEmptyField: ->
    @ui.input.val() is ''

  isLoading: ->
    @ui.field.hasClass('loading')

  showLoading: ->
    @ui.field.addClass('loading')

  hideLoading: ->
    @ui.field.removeClass('loading')

  clearErrors: ->
    unless @isEmptyField()
      @ui.input.removeClass('error')
      @ui.error.html('')

  showValidationError: (errors) ->
    @ui.input.addClass('error')
    @ui.error.html errors.name.join(', ')

module.exports = AddInterest
