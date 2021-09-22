Marionette = require('backbone.marionette')

class Author extends Marionette.View

  getTemplate: ->
    require "./../../../../templates/mainbar/posts/partials/author.hbs"

  className: 'authorship'

module.exports = Author
