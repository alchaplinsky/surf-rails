_ = require('underscore')
Marionette = require('backbone.marionette')

class Member extends Marionette.View

  getTemplate: ->
    require "./../../templates/interests/member.hbs"
  className: 'item'

  ui:
    remove: '.js-remove'

  triggers:
    'click @ui.remove': 'membership:delete'

  serializeData: ->
    _.extend {}, @model.get('user'), @helpers()

  helpers: ->
    letter: @model.get('user').first_name?[0]
    isRemovable: @model.get('role') isnt 'owner'

module.exports = Member
