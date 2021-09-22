Backbone = require('backbone')
Interest = require('./../models/interest')

class Interests extends Backbone.Collection
  model: Interest
  comparator: 'name'
  url: "/api/v1/interests"

  getCurrent: ->
    if id = parseInt(@storage.get('currentInterest'))
      @findWhere(id: id) || @first()
    else
      @first()

  setCurrent: (interest) ->
    @storage.set 'currentInterest', interest.id

module.exports = Interests
