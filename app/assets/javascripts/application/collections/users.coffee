Backbone = require('backbone')

class Users extends Backbone.Collection
  url: "/api/v1/users"

module.exports = Users
