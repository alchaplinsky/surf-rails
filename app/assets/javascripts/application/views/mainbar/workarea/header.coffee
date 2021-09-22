_ = require('underscore')
_.string = require('underscore.string')
$ = require('jquery')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Hashtagable = require('./../../../behaviors/hashtagable')

class Header extends Marionette.View

  getTemplate: ->
    require './../../../templates/mainbar/workarea/header.hbs'

  ui:
    settings: '.js-settings'
    viewToggle: '.js-view-toggle'
    context: '.js-context'
    edit: '.js-edit'
    share: '.js-share'
    delete: '.js-delete'
    leave: '.js-leave'
    search: '.js-search'
    clear: '.js-clear'
    name: '.js-name'
    filter: '.js-filter'
    currentFilter: '.js-filter.current'
    sidebarToggle: '.js-sidebar-toggler'

  events:
    'keyup @ui.search': 'onKeyUp'
    'click @ui.clear': 'onClickClear'
    'click @ui.filter': 'onClickFilter'
    'click @ui.settings': 'onClickSettings'
    'click @ui.edit': 'onClickEdit'
    'click @ui.share': 'onClickShare'
    'click @ui.delete': 'onClickDelete'
    'click @ui.viewToggle': 'onClickViewToggle'
    'click @ui.leave': 'onClickLeave'
    'click @ui.sidebarToggle': 'onClickSidebarOpen'

  className: 'header'

  behaviors:
    Hashtagable:
      behaviorClass: Hashtagable

  filters: ['link', 'note', 'image', 'attachment']

  templateContext: ->
    icon: require('images/icon.png')
    interest: @interest.get('name')
    isInterestOwner: @isInterestOwner
    itemsCount: @interest.get('posts_count')
    linksPresent: @allPosts.count('link') isnt 0
    notesPresent: @allPosts.count('note') isnt 0
    imagesPresent: @allPosts.count('image') isnt 0
    attachmentsPresent: @allPosts.count('attachment') isnt 0
    linksCount: @allPosts.count('link')
    notesCount: @allPosts.count('note')
    imagesCount: @allPosts.count('image')
    attachmentsCount: @allPosts.count('attachment')
    totalCount: @totalCount
    deleteOptionClass: @deleteOptionClass

  initialize: ->
    @app = @options.app
    @interest = @options.interest
    @posts = @options.posts
    @currentFilter = 'all'
    @allPosts = _.clone @posts
    @channel = Radio.channel('basic')
    @channel.on 'select:interest', @onSelectInterest
    @channel.on 'updated:interest', @onUpdatedInterest
    @listenTo @posts, 'selected:tag', @onTagSelect
    @listenTo @posts, 'fetch:done', @updatePostsData
    @listenTo @posts, 'sync', @updatePostsData
    @listenTo @posts, 'remove', @updatePostsData

  onRender: ->
    if @app.storage.get('viewMode') is 'grid'
      @ui.viewToggle.addClass('icon-list')
    else
      @ui.viewToggle.addClass('icon-bricks')

  onSelectInterest: (interest) =>
    @interest = interest
    @ui.name.text @interest.get('name')
    @$("[id$='-filter']").hide()
    @$el.find("#count-all").html @totalCount()

  onUpdatedInterest: =>
    @render()

  onKeyUp: =>
    @toggleClearVisibility()
    @channel.trigger 'search:query:changed', @ui.search.val()
    @channel.trigger 'filter:posts', @currentFilter, @ui.search.val()

  onClickClear: =>
    @ui.clear.hide()
    @ui.search.val('')
    @channel.trigger 'search:query:changed', @ui.search.val()
    @channel.trigger 'filter:posts', @currentFilter, ''

  onClickSettings: =>
    @showContextMenu()

  onClickViewToggle: =>
    @channel.trigger 'view:toggle'
    @ui.viewToggle.toggleClass('icon-list icon-bricks')
    if @app.storage.get('viewMode') is 'grid'
      @app.storage.set 'viewMode', 'list'
    else
      @app.storage.set 'viewMode', 'grid'

  onClickSidebarOpen: =>
    @channel.trigger 'sidebar:slide'

  onClickEdit: =>
    @contextTrigger('edit:interest')

  onClickShare: =>
    @contextTrigger('share:interest')

  onClickDelete: =>
    return if @isLastInterest()
    @contextTrigger('delete:interest')

  onClickLeave: =>
    @contextTrigger('leave:interest')

  onClickFilter: (event) ->
    @switchCurrent event.currentTarget
    @currentFilter = @$(event.currentTarget).data('filter')
    @channel.trigger 'filter:posts', @currentFilter, @ui.search.val()

  onTagSelect: (query) =>
    @ui.search.val(query)
    @toggleClearVisibility()
    @channel.trigger 'filter:posts', @currentFilter, @ui.search.val()

  onDocumentClick: (event) =>
    return if event.target is @ui.context[0]
    return if event.target is @ui.settings[0]
    return if $.contains(@ui.context[0], event.target)
    @hideContextMenu()

  ##############################################################################
  contextTrigger: (event) ->
    @ui.context.removeClass('shown')
    @channel.trigger event, @interest

  totalCount: =>
    if @interest.get('posts_count') is 0
      '<span>0 items</span>'
    else
      "<a href='#' class='js-filter current' data-filter='all'>All #{@interest.get('posts_count')}</a>"

  isLastInterest: ->
    @interest.collection.length is 1

  isInterestOwner: =>
    @interest.get('membership').role is 'owner'

  updatePostsData: ->
    @allPosts = _.clone @posts
    @interest.set 'posts_count', @posts.length
    @render()

  updateFilter: (type, count) ->
    @$el.find("##{type}-filter .count").text(count)
    @$el.find("##{type}-filter").show() if count isnt 0

  toggleClearVisibility: ->
    if _.string.isBlank @ui.search.val()
      @ui.clear.hide()
    else
      @ui.clear.show()

  switchCurrent: (element) ->
    @ui.filter.removeClass('current')
    @$(element).addClass('current')

  showContextMenu: ->
    @ui.context.addClass('shown')
    @bindDocument()

  hideContextMenu: ->
    @ui.context.removeClass('shown')
    @unbindDocument()

  bindDocument: ->
    $(document).on 'click', @onDocumentClick

  unbindDocument: ->
    $(document).off 'click', @onDocumentClick

  deleteOptionClass: =>
    if @isLastInterest() then 'disabled' else ''


module.exports = Header
