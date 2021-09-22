Marionette = require('backbone.marionette')

class Suggestion extends Marionette.View

  getTemplate: ->
    require "./../../templates/interests/suggestion.hbs"
  tagName: 'li'
  className: ''

  ui:
    add: '.js-add'

  triggers:
    'click': 'membership:create'

  templateContext: ->
    letter: => @model.get('first_name')?[0]

module.exports = Suggestion
