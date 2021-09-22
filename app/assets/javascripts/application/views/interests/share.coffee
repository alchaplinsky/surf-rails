_ = require('underscore')
Radio = require('backbone.radio')
View = require('./../base')
Users = require('./../../collections/users')
Memberships = require('./../../collections/memberships')
Membership = require('./../../models/membership')
Members = require('./members')
Suggestions = require('./suggestions')

class ShareInterest extends View
  getTemplate: ->
    require './../../templates/interests/share.hbs'

  regions:
    suggestionsRegion: '.js-suggestions-region'
    membersRegion: '.js-members-region'

  ui:
    input: '.js-user-input'

  events:
    'keyup @ui.input': 'onKeyupField'

  initialize: ->
    @users = new Users
    @suggestedUsers = new Users
    @memberships = new Memberships
    @memberships.interest = @model

  ##############################################################################
  onRender: ->
    @memberships.fetch().done =>
      @renderMembers()
    @renderSuggestions()

  onKeyupField: ->
    if @ui.input.val().length > 1
      @fetchSuggestions()
    else
      @suggestedUsers.reset()

  onMembershipCreate: (user) =>
    @clearSuggestions()
    membership = new Membership user_id: user.id, interest_id: @model.id
    membership.save().done =>
      @memberships.add membership
      @model.set 'shared', true

  onMembershipDelete: (membership) =>
    membership.destroy().done =>
      @clearSuggestions()
      @memberships.remove membership
      @model.set 'shared', false if @memberships.length is 1

  ##############################################################################
  fetchSuggestions: ->
    @users.fetch(data: query: @ui.input.val()).done =>
      @suggestedUsers.reset @users.reject((user) =>
        _.contains _.pluck(@memberships.pluck('user'), 'id'), user.id
      )

  renderMembers: ->
    view = new Members collection: @memberships
    @listenTo view, 'membership:delete', @onMembershipDelete
    @showChildView 'membersRegion', view

  renderSuggestions: ->
    view = new Suggestions collection: @suggestedUsers
    @listenTo view, 'membership:create', @onMembershipCreate
    @showChildView 'suggestionsRegion', view

  clearSuggestions: ->
    @suggestedUsers.reset()
    @ui.input.val('')


module.exports = ShareInterest
