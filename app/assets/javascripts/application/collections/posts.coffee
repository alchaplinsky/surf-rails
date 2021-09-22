_ = require('underscore')
Backbone = require('backbone')
Post = require('./../models/post')

class Posts extends Backbone.Collection
  model: Post

  url: ->
    "/api/v1/interests/#{@interest.id}/submissions"

  setCurrent: (model) ->
    @unsetCurrent()
    model.set('current', true)

  unsetCurrent: ->
    if current = @findWhere(current: true)
      current.set('current', false)

  count: (type) ->
    @detect(type).length

  detect: (type) ->
    @where (item) -> item.get(type)?

  filterByQuery: (query) ->
    structure = @_parseQuery(query)
    @filter (post) -> post.respondsToAny structure

  _parseQuery: (query) ->
    _.map(query.trim().split(' '), (item) -> item.split('+'))

module.exports = Posts
