$ = require('jquery')
Radio = require('backbone.radio')
View = require('./../base')
Interests = require('./interests')

class Sidebar extends View

  className: 'sidebar'

  getTemplate: ->
    require('./../../templates/sidebar/sidebar.hbs')

  ui:
    account: '.js-account'
    counter: '.js-count'
    list: '.js-list'
    invite: '.js-invite'
    addInterest: '.js-add-interest'
    sidebarClose: '.js-sidebar-close-toggle'

  events:
    'click @ui.invite': 'onClickInvite'
    'click @ui.addInterest': 'onClickAddInterest'
    'click @ui.sidebarClose': 'onClickSidebarClose'

  regions:
    interestsRegion: '.js-interests'

  initialize: ->
    @model = @app.user
    @channel = Radio.channel('basic')
    @channel.on 'created:interest', @updateCounter
    @channel.on 'deleted:interest', @updateCounter

  templateContext: ->
    letter: => @model.get('first_name')?[0]

  #############################################################################
  onRender: ->
    @adjustHeight()
    @updateCounter()
    @renderInterests()
    $(window).on 'resize', @adjustHeight

  onClickAddInterest: ->
    @channel.trigger 'add:interest'

  onClickInvite: ->
    @channel.trigger 'invite:user'

  onClickSidebarClose: ->
    @channel.trigger 'sidebar:slide'

  #############################################################################
  renderInterests: ->
    interests = new Interests
      collection: @app.interests
    @showChildView 'interestsRegion', interests

  updateCounter: =>
    @ui.counter.text "(#{@app.interests.length})"

  adjustHeight: =>
    height = $(window).height() - @ui.account.outerHeight() - @ui.invite.outerHeight() - 20
    @ui.list.height height

module.exports = Sidebar
