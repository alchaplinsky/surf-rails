Marionette = require('backbone.marionette')

class Tags extends Marionette.View

  getTemplate: ->
    require "./../../../../templates/mainbar/posts/partials/tags.hbs"

  className: 'tags'

  ui:
    tag: '.js-tag'

  triggers:
    'click @ui.tag': 'click:tag'

module.exports = Tags
