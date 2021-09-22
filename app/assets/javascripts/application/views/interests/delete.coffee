Radio = require('backbone.radio')
View = require('./../base')

class DeleteInterest extends View
  getTemplate: ->
    require './../../templates/interests/delete.hbs'

  ui:
    confirm: '.js-confirm'
    cancel: '.js-cancel'

  events:
    'click @ui.confirm': 'onClickConfirm'
    'click @ui.cancel': 'onClickCancel'

  templateContext: ->
    image: require('images/remove_interest@2x.png')

  initialize: ->
    @channel = Radio.channel('basic')

  onClickCancel: ->
    @channel.trigger 'close:popup'

  onClickConfirm: ->
    @model.destroy().done =>
      @collection.setCurrent @collection.first()
      @channel.trigger 'select:interest', @collection.first()
      @channel.trigger 'deleted:interest'
    .fail =>
      @handelErrorResponse(response)


module.exports = DeleteInterest
