_ = require('underscore')
$ = require('jquery')
Radio = require('backbone.radio')
Marionette = require('backbone.marionette')

class Subheader extends Marionette.View
  getTemplate: ->
    require './../../../templates/mainbar/workarea/subheader.hbs'

  className: 'subheader'

  ui:
    tag: '.js-tag'

  events:
    'click @ui.tag': 'onClickTag'

  initialize: ->
    @posts = @options.posts
    @interest = @options.interest
    @channel = Radio.channel('basic')
    @channel.on 'select:interest', @onSelectInterest
    @channel.on 'search:query:changed', @onSearchQueryChanged

  templateContext: ->
    tags: @interest.get('tags')

  ##############################################################################
  onRender: ->
    if @interest.get('tags').length is 0
      @$el.hide()
    else
      @$el.show()

  onSelectInterest: (@interest) =>
    @render()

  onClickTag: (event) ->
    return false if $(event.currentTarget).hasClass('active')
    @ui.tag.removeClass 'active'
    $(event.currentTarget).addClass('active')
    @posts.trigger 'selected:tag', event.currentTarget.textContent

  onSearchQueryChanged: (query) =>
    @ui.tag.removeClass 'active'
    for tag in _.intersection(@queryTags(query), @interest.get('tags'))
      @ui.tag.filter(":contains(#{tag})").addClass 'active'

  ##############################################################################
  queryTags: (query) ->
    _.compact _.map(query.split(/\+|\s/), (item) ->
      if item.match(/^#/) then item.replace(/#/g, '') else false
    )

module.exports = Subheader
