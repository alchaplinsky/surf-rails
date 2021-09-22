Backbone = require('backbone')
Membership = require('./../models/membership')

class Memberships extends Backbone.Collection

  model: Membership

  url: -> "/api/v1/interests/#{@interest.id}/interest_memberships"

module.exports = Memberships
