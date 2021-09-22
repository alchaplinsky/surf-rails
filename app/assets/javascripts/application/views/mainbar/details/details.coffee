Clipboard = require('clipboard')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Contextable = require('./../../../behaviors/contextable')
Form = require('./form')

class Details extends Marionette.View

  getTemplate: ->
    require './../../../templates/mainbar/details/details.hbs'

  className: 'details'

  regions:
    formRegion: '.js-form-region'

  ui:
    back: '.js-back'
    share: '.js-share'
    delete: '.js-delete'
    copy: '.js-copy'

  events:
    'click @ui.back': 'onClickBack'
    'click @ui.share': 'onClickShare'
    'click @ui.delete': 'onClickDelete'
    'click @ui.copy': 'onClickCopy'

  behaviors:
    Contextable:
      behaviorClass: Contextable

  templateContext: ->
    url: @model.getUrl()
    readonly: @readonly

  initialize: ->
    @app = @options.app
    @channel = Radio.channel('basic')
    @interest = @options.interest

  onRender: ->
    @showChildView 'formRegion', new Form
      readonly: @readonly()
      model: @model
      interest: @interest

  onClickDelete: ->
    @model.interest = @interest
    @channel.trigger 'delete:post', @model

  onClickShare: (event) ->
    clipboard = new Clipboard '.js-copy', text: => @model.getUrl()

  onClickCopy: ->
    @hideContextMenu()

  onClickBack: ->
    @channel.trigger 'close:details'
    @destroy()

  readonly: =>
    @app.user.id isnt @model.get('user_id')

module.exports = Details
