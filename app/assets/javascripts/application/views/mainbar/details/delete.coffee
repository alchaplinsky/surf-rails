Radio = require('backbone.radio')
View = require('./../../base')

class DeletePost extends View
  getTemplate: ->
    require './../../../templates/mainbar/details/delete.hbs'

  ui:
    confirm: '.js-confirm'
    cancel: '.js-cancel'

  events:
    'click @ui.confirm': 'onClickConfirm'
    'click @ui.cancel': 'onClickCancel'

  initialize: ->
    @channel = Radio.channel('basic')

  onClickCancel: ->
    @channel.trigger 'close:popup'

  onClickConfirm: ->
    @model.destroy().done =>
      @channel.trigger 'deleted:post'
    .fail =>
      @handelErrorResponse(response)

module.exports = DeletePost
