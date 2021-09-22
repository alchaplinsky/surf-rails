$ = require('jquery')
Marionette = require('backbone.marionette')
Posts = require('./../../../collections/posts')
Header = require('./header')
Subheader = require('./subheader')
List = require('./list')
Form = require('./form')

class Workarea extends Marionette.View

  getTemplate: ->
    require './../../../templates/mainbar/workarea/workarea.hbs'

  className: 'workarea'

  ui:
    header: '.js-header'
    subheader: '.js-subheader'
    content: '.js-content'
    footer: '.js-form'

  regions:
    headerRegion: '.js-header'
    subheaderRegion: '.js-subheader'
    contentRegion: '.js-content'
    formRegion: '.js-form'

  initialize: ->
    @app = @options.app
    @interest = @options.interest
    @posts = @options.posts

  onRender: ->
    @renderHeader()
    @renderSubheader()
    @renderList()
    @renderForm()
    @adjustHeight()
    $(window).on 'resize', @adjustHeight

  renderHeader: ->
    header = new Header
      app: @app
      interest: @interest
      posts: @posts
    @showChildView 'headerRegion', header

  renderSubheader: ->
    @showChildView 'subheaderRegion', new Subheader
      interest: @interest
      posts: @posts

  renderList: ->
    @showChildView 'contentRegion', new List
      app: @app
      collection: @posts

  renderForm: ->
    @showChildView 'formRegion', new Form
      posts: @posts
      interest: @interest

  adjustHeight: =>
    setTimeout =>
      height = $(window).height() - @ui.header.outerHeight() - @ui.footer.outerHeight() - @ui.subheader.outerHeight()
      @ui.content.height height
    , 0

module.exports = Workarea
