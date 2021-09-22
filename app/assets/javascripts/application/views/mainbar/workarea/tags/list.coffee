Marionette = require('backbone.marionette')
Item = require('./item')

class List extends Marionette.CollectionView
  className: 'autocomplete'
  childView: Item

module.exports = List
