source 'https://rubygems.org'
ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false

gem 'webpacker', '4.0.7'

gem 'applepie-rails', '0.1.1'
gem 'config', '1.7.1'
gem 'devise', '4.6.2'
gem 'omniauth-facebook', '5.0.0'
gem 'omniauth-google-oauth2', '0.7.0'

gem 'carrierwave', '~> 1.3.1'
gem 'mini_magick', '4.9.3'

gem 'metainspector', '5.6.0'
gem 'meta-tags', '2.11.1'

gem 'hashid-rails', '1.2.2'

gem 'sidekiq', '5.2.7'

gem 'rails_admin', '1.4.2'

gem 'pundit', '2.0.1'

gem 'browser', '2.5.3'

gem 'kaminari', '1.1.1'

gem 'httparty', '0.17.0'

gem 'paypal-checkout-sdk'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'exception_notification', '4.3.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '3.8.2'
  gem 'factory_bot_rails', '5.0.2'
  gem 'shoulda-matchers', '4.0.1'
  gem 'capybara', '~> 3.22.0'
  # gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'capybara-feature_helpers', '0.0.2'
  gem 'selenium-webdriver', '3.142.3'
  gem 'database_cleaner',   '1.7.0'
  gem 'rspec-example_steps', '3.0.2'
  gem 'webmock', '3.6.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Deploy
  gem 'capistrano-rvm'
  gem 'capistrano', '3.11.0'
  gem 'capistrano-rails', '1.4.0'
  gem 'capistrano-sidekiq', '1.0.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
