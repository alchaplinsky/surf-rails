$ = require('jquery')
Radio = require('backbone.radio')
View = require('./../base')
Workarea = require('./workarea/workarea')
Details = require('./details/details')

class Mainbar extends View

  getTemplate: ->
    require './../../templates/mainbar/mainbar.hbs'

  className: 'mainbar'

  regions:
    workareaRegion: '.js-workarea-region'
    detailsRegion: '.js-details-region'

  initialize: ->
    @channel = Radio.channel('basic')
    @channel.on 'show:details', @onShowDetails
    @channel.on 'close:details', @onCloseDetails

  onRender: ->
    @renderWorkarea()

  onShowDetails: (model) =>
    @ensureWindowWidth()
    @renderDetails(model)
    @$el.addClass('split')

  onCloseDetails: =>
    @closeDetails()

  renderWorkarea: ->
    workarea = new Workarea
      app: @app
      interest: @app.interests.getCurrent()
      posts: @app.posts
    @showChildView 'workareaRegion', workarea

  renderDetails: (model) ->
    details = new Details
      app: @app
      interest: @app.interests.getCurrent()
      model: model
    @showChildView 'detailsRegion', details

  closeDetails: ->
    @$el.removeClass('split')
    @app.posts.unsetCurrent()
    @detachChildView 'detailsRegion'

  ensureWindowWidth: ->
    @channel.trigger 'expand:window' if @$el.width() < 700


module.exports = Mainbar
