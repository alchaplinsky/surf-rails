_ = require('underscore')
_.string = require('underscore.string')
Backbone = require('backbone')

class Post extends Backbone.Model

  urlRoot: -> "/api/v1/interests/#{@interest.id}/submissions"

  getType: ->
    if @get('link')?
      'link'
    else if @get('note')?
      'note'
    else if @get('image')?
      'image'
    else if @get('attachment')?
      'attachment'
    else if @get('failed')? and @get('failed')
      'failed'
    else
      'raw'

  getUrl: ->
    @get(@getType()).url

  isPending: ->
    @getType() is 'raw' or @getType() is 'failed'

  tagsPresent: ->
    @get('tags').length isnt 0

  ##############################################################################
  respondsToAny: (queries) ->
    _.some queries, (query) => @respondsToEvery query

  respondsToEvery: (subqueries) ->
    _.every subqueries, (subquery) =>
      if subquery.match(/^#/)?
        @taggedWith(subquery)
      else
        @respondsTo subquery

  taggedWith: (tag) ->
    _.contains @tagNames(), tag.replace('#', '')

  tagNames: ->
    _.map(@get('tags'), 'name')

  respondsTo: (query) ->
    @["#{@getType()}RespondsTo"](query)

  linkRespondsTo: (query) ->
    obj = @get('link')
    @_match(obj.title, query) or @_match(obj.description, query)

  noteRespondsTo: (query) ->
    obj = @get('note')
    @_match(obj.title, query) or @_match(obj.text, query)

  imageRespondsTo: (query) ->
    @_match(@get('image').title, query)

  attachmentRespondsTo: (query) ->
    @_match(@get('attachment').title, query)

  _match: (string, substr) ->
    unless _.string.isBlank string
      string.toLowerCase().match substr.toLowerCase()

module.exports = Post
