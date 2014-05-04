source 'https://rubygems.org'

ruby '2.1.1'

#:: Stack
gem 'rails', '4.1.0' # Rails
gem 'nokogiri' # xml/html parsing
gem 'whenever' # Schedule and run tasks with cron
gem 'turbolinks'

# Facebook login
gem 'omniauth-facebook'

#:: Database
gem 'pg'      # Postgres database for heroku
gem 'rails_12factor', group: :production

#:: Javascripts
gem 'ember-rails'
gem 'jquery-cdn'       # Use jquery as the JavaScript library
gem 'typeahead-rails'  # Twitter typeahead.js, search bar autocomplete
gem 'underscore-rails' # Javascript toolbelt.
gem 'bootstrap-sass'   # css stylesheets

#:: Asset processors
gem 'sass-rails'               # Use SCSS for stylesheets
gem 'coffee-rails'             # Use CoffeeScript for .js.coffee assets and views
gem 'haml-rails'               # Use Hamle for .html.haml views
gem 'emblem-rails'             # Use Emblem for handlebars templates TODO: replace with hamlbars
gem 'uglifier'                 # Use Uglifier as compressor for JavaScript assets

gem 'jbuilder'           # Build JSON APIs with ease TODO: I think I don't need this, serializers does the same thing
gem 'yajl-ruby'          # Faster json engine

#:: JavaScript Runtime Environment
gem 'therubyracer'

group :test, :development do
  gem 'heroku'
  gem 'bugsnag'
end

group :test do
  gem 'faker'
  gem 'factory_girl_rails'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'unicorn' # Webserver

#:: Development tools
gem 'debugger', group: [:development, :test]
gem 'quiet_assets', :group => :development


