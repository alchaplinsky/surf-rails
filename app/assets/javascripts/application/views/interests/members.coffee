Marionette = require('backbone.marionette')
Member = require('./member')

class Members extends Marionette.CollectionView

  childView: Member

  onChildviewMembershipDelete: (view) ->
    @trigger 'membership:delete', view.model

module.exports = Members
