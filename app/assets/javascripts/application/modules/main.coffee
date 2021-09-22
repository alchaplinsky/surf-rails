_ = require('underscore')
_.string = require('underscore.string')
$ = require('jquery')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')
Storage = require('./../services/storage')
User = require('./../models/user')
Interests = require('./../collections/interests')
Posts = require('./../collections/posts')
Layout = require('./../views/layout')

class Main extends Marionette.Object

  channelName: 'basic'

  radioEvents:
    'select:interest': 'onSelectInterest'
    'filter:posts': 'onFilterPosts'
    'cable:interest_membership:created': 'onInterestShared'
    'cable:interest_membership:deleted': 'onInterestUnshared'
    'cable:submission:created': 'onSubmissionCreated'

  initialize: ->
    @storage = new Storage(@options)
    @channel = Radio.channel('basic')
    @user = new User()
    @interests = new Interests()
    @interests.storage = @storage
    @posts = new Posts()
    @initViewMode()
    @renderLayout()
    @loadUserData()

  ##############################################################################
  onSelectInterest: (interest) =>
    @loadPosts()

  onFilterPosts: (type, query) ->
    @filterPosts(type, query)

  onDeleteInterest: ->
    @interests.setCurrent @interests.first()
    @channel.trigger 'select:interest', @interests.first()
    @channel.trigger 'deleted:interest'

  onInterestShared: ->
    @interests.fetch()

  onInterestUnshared: (data) ->
    @onDeleteInterest() if @interests.getCurrent().id is data.interest_id
    @loadInterests()

  onSubmissionCreated: (data) ->
    if @interests.getCurrent().id is data.interest_id
      @loadPosts()

  ##############################################################################
  initViewMode: ->
    @storage.set 'viewMode', 'list' unless @storage.get('viewMode')

  filterPosts: (type, query) ->
    posts = @filterPostsByType(type)
    models = @filterPostsByQuery(posts, query)
    @posts.reset models

  filterPostsByType: (type) ->
    models = if type is 'all' then @allPosts.models else @allPosts.detect(type)
    @posts.reset models, silent: true

  filterPostsByQuery: (posts, query) ->
    if _.string.isBlank query then @posts.models else @posts.filterByQuery(query)

  loadUserData: ->
    $.when(@user.fetch(), @interests.fetch()).then =>
      @loadPosts()
    .fail (response) =>
      @channel.trigger 'request:error', response

  loadInterests: ->
    @interests.fetch().done =>
      @loadPosts()
    .fail (response) =>
      @channel.trigger 'request:error', response

  loadPosts: ->
    @posts.interest = @interests.getCurrent()
    @posts.trigger 'fetch:start'
    @posts.fetch().done =>
      @posts.trigger 'fetch:done'
      @allPosts = _.clone(@posts)
    .fail (response) =>
      @channel.trigger 'request:error', response

  renderLayout: ->
    @layout = new Layout app: @, el: $('#body')
    @layout.render()

module.exports = Main
