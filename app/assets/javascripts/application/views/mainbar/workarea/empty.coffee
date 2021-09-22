Marionette = require('backbone.marionette')

class Empty extends Marionette.View

  className: 'empty'

  getTemplate: ->
    if @options.collection.interest.get('posts_count') is 0
      require './../../../templates/mainbar/workarea/empty.hbs'
    else
      require './../../../templates/mainbar/workarea/filtered_empty.hbs'

  templateContext: ->
    image: require('images/empty.png')

module.exports = Empty
