Radio = require('backbone.radio')
View = require('./../base')

class EditInterest extends View
  getTemplate: ->
    require './../../templates/interests/edit.hbs'

  ui:
    field: '.js-field'
    input: '.js-interest-name'
    button: '.js-button'

  events:
    'click @ui.button':  'onClickButton'

  templateContext: ->
    image: require('images/interest@2x.png')

  initialize: ->
    @channel = Radio.channel('basic')

  onClickButton: ->
    @showLoading()
    @model.save(name: @ui.input.val()).done =>
      @channel.trigger 'updated:interest', @model
    .fail (response) =>
      @hideLoading()
      @handelErrorResponse(response)

  showLoading: ->
    @ui.button.addClass('disabled')
    @ui.field.addClass('loading')

  hideLoading: ->
    @ui.button.removeClass('disabled')
    @ui.field.removeClass('loading')


module.exports = EditInterest
