$ = require('jquery')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Post = require('./posts/post')
Empty = require('./empty')

class Content extends Marionette.CollectionView
  className: 'posts'

  childView: Post

  emptyView: Empty

  emptyViewOptions: =>
    collection: @collection

  initialize: ->
    @app = @options.app
    @channel = Radio.channel('basic')
    @channel.on 'created:post', @onUpdateList
    @channel.on 'view:toggle', @onToggleView
    @listenTo @collection, 'fetch:start', @onFetchStart
    @listenTo @collection, 'fetch:done', @onFetchDone
    @listenTo @collection, 'add', @onUpdateList

  onRender: ->
    @$el.addClass @app.storage.get('viewMode')

  onDomRefresh: ->
    setTimeout =>
      @scrollContent()
    , 10

  scrollContent: =>
    @$el[0].scrollTop = @$el[0].scrollHeight

  onUpdateList: =>
    @scrollContent()

  onToggleView: =>
    @$el.toggleClass('grid')

  onFetchStart: ->
    @$el.html('<div class="loader-overlay">
      <div class="loader">
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
      </div>
    </div>')

  onFetchDone: ->
    @$el.html('')
    @render()

module.exports = Content
