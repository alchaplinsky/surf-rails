Marionette = require('backbone.marionette')

class View extends Marionette.View

  constructor: (options) ->
    @app = options.app
    super options


module.exports = View
