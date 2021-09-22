Backbone = require('backbone')

class User extends Backbone.Model

  url: '/api/v1/users/me'

module.exports = User
