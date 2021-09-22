_ = require('underscore')
_.string = require('underscore.string')
Marionette = require('backbone.marionette')

class Text extends Marionette.View

  getTemplate: ->
    require "./../../../../templates/mainbar/posts/partials/text.hbs"

  templateContext: ->
    textPresent: =>
      not _.string.isBlank @model.get('text')

module.exports = Text
