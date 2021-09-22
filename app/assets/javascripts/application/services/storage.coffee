class Storage

  constructor: (@options) ->

  get: (key) ->
    localStorage.getItem("surf:#{@options.env}:#{key}")

  set: (key, value) ->
    localStorage.setItem("surf:#{@options.env}:#{key}", value)

  remove: (key) ->
    localStorage.removeItem("surf:#{@options.env}:#{key}")

module.exports = Storage
