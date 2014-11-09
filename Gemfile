source 'https://rubygems.org'

ruby '2.1.1'

#:: Stack
gem 'rails', '4.1.0'    # Rails.
gem 'nokogiri'          # xml/html parsing.
gem 'omniauth-facebook' # Facebook login.
gem 'turbolinks'
gem 'unicorn'           # Webserver.

#:: Database
gem 'pg'                # Heroku requires postgresql.


#:: Javascripts
gem 'ember-rails'       # Javascript MVC
gem 'ember-source'
gem 'jquery-cdn'          # Use jquery as the JavaScript library
gem 'lodash-rails'        # Javascript toolbelt.
gem 'bootstrap-sass'      # css stylesheets
gem 'autoprefixer-rails'

#:: Asset processors
gem 'sass-rails'        # Use SCSS for stylesheets.
gem 'coffee-rails'      # Use CoffeeScript for .js.coffee assets and views.
gem 'haml-rails'        # Use Hamle for .html.haml views.
gem 'emblem-rails'      # Use Emblem for handlebars templates.
gem 'uglifier'          # Use Uglifier as compressor for JavaScript assets.
gem 'jbuilder'          # Builds JSON objects.
gem 'yajl-ruby'         # Faster json engine.

#:: JavaScript Runtime Environment
gem 'therubyracer'

#:: Heroku
gem 'heroku', group: [:development, :test] # Interacts with heroku.
gem 'rails_12factor', group: :production   #
gem 'bugsnag'                              # Web based crash reporting.

#:: Testing gems.
group :test do
  gem 'faker'               # Supplies fake data.
  gem 'factory_girl_rails'  # Generates records for testing.
end

gem 'sdoc', require: false, group: :doc # Generate code docs.


#:: Development tools
group :development do
  gem 'debugger', group: :test # Enables dubugger support.
  gem 'quiet_assets'           # Removed 'GET asset' from development logs.
  gem 'spring'                 # Enables fast start of rails commands.
  gem 'guard'                  # Exec commands on file changes.
  gem 'guard-minitest'             # Add test support to Guard.
  gem 'rb-readline', '~> 0.5.0', require: false
end
