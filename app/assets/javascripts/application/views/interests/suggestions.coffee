Marionette = require('backbone.marionette')
Suggestion = require('./suggestion')

class Suggestions extends Marionette.CollectionView
  tagName: 'ul'

  childView: Suggestion

  childViewOptions:
    template: 'suggestion'

  onChildviewMembershipCreate: (view) ->
    @trigger 'membership:create', view.model

module.exports = Suggestions
