_ = require('underscore')
$ = require('jquery')
Radio = require('backbone.radio')
View = require('./base')
Popup = require('./popup')
Mainbar = require('./mainbar/mainbar')
Sidebar = require('./sidebar/sidebar')
AddInterest = require('./interests/create')
EditInterest = require('./interests/edit')
ShareInterest = require('./interests/share')
DeleteInterest = require('./interests/delete')
DeletePost = require('./mainbar/details/delete')
InviteUser = require('./invite')
Membership = require('./../models/membership')

class Layout extends View

  getTemplate: ->
    require "./../templates/#{@template()}.hbs"

  template: ->
    if @app.user.get('email') then 'layout' else 'loading'

  regions:
    sidebarRegion: '.js-sidebar-region'
    mainbarRegion: '.js-mainbar-region'
    overlayRegion: '.js-overlay-region'

  templateContext: ->
    image: require('images/sidebar_loading.png')

  initialize: ->
    @channel = Radio.channel('basic')
    @channel.on 'select:interest', @onSelectInterest
    @channel.on 'add:interest', @renderAddInterest
    @channel.on 'edit:interest': @renderEditInterest
    @channel.on 'share:interest': @renderShareInterest
    @channel.on 'delete:interest', @renderDeleteInterest
    @channel.on 'leave:interest', @onLeaveInterest
    @channel.on 'delete:post', @renderDeletePost
    @channel.on 'created:post', @onPostCreated
    @channel.on 'deleted:post', @onPostDeleted
    @channel.on 'invite:user': @renderInviteUser
    @channel.on 'sidebar:slide', @onSidebarSlide
    @listenToOnce @app.posts, 'fetch:done', @renderLayout

  ##############################################################################
  onPostCreated: =>
    @fetchInterest()

  onPostDeleted: =>
    @mainbar.closeDetails()
    @fetchInterest()

  onSelectInterest: (interest) =>
    @channel.trigger 'close:details'

  onLeaveInterest: (interest) =>
    @removeMembership interest

  onSidebarSlide: =>
    @getRegion('sidebarRegion').$el.toggleClass 'opened'

  ##############################################################################
  renderLayout: =>
    @render()
    @renderSidebar()
    @renderMainbar()

  renderSidebar: ->
    @sidebar = new Sidebar app: @app
    @showChildView 'sidebarRegion', @sidebar

  renderMainbar: ->
    @mainbar = new Mainbar app: @app
    @showChildView 'mainbarRegion', @mainbar

  renderAddInterest: =>
    @showPopup AddInterest, collection: @app.interests

  renderEditInterest: (interest) =>
    @showPopup EditInterest, model: interest

  renderShareInterest: (interest) =>
    @showPopup ShareInterest, model: interest

  renderDeleteInterest: (interest) =>
    @showPopup DeleteInterest, collection: @app.interests, model: interest

  renderDeletePost: (post) =>
    @showPopup DeletePost, model: post

  renderInviteUser: =>
    @showPopup InviteUser

  showPopup: (view, options) ->
    contentView = new view _.extend(app: @app, options)
    popupView = new Popup app: @app, view: contentView
    @showChildView 'overlayRegion', popupView

  removeMembership: (interest) ->
    @membership = new Membership id: interest.get('membership').id
    @membership.destroy().done =>
      @app.interests.remove interest
      @app.interests.setCurrent @app.interests.first()
      @channel.trigger 'select:interest', @app.interests.first()
      @channel.trigger 'deleted:interest', interest

  fetchInterest: ->
    @app.interests.getCurrent().fetch()

module.exports = Layout
