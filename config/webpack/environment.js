const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')

environment.loaders.append('handlebars', {
  test: /\.hbs$/,
  use: 'handlebars-loader'
})


environment.loaders.prepend('coffee', coffee)
module.exports = environment
