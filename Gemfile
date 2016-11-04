source 'http://rubygems.org'
source 'http://gems.github.com'

ruby '2.3.1'

gem 'rails', '~> 4.1.0'
gem 'activerecord-session_store'
gem 'activeresource'

gem 'jquery-rails', "~> 2.0.2"
gem 'haml', '~>4.0'
gem 'authlogic'
gem 'bcrypt' # binarylogic/authlogic#405
gem 'scrypt' # binarylogic/authlogic#405
gem 'httparty'
gem 'tabs_on_rails', '~>2.1.1'
gem 'kaminari', '~> 0.13.0'
gem 'simple_form'
gem 'nokogiri', '~> 1.6'
gem 'redcarpet'
gem 'font-awesome-rails'
gem 'non-stupid-digest-assets', github: 'wtfiwtz/non-stupid-digest-assets', ref: '9c8f1a94'

# javascript
# Change back to RubyGems once Invalid Byte Sequence error is fixed:
#   https://github.com/fnando/i18n-js/pull/139
gem 'i18n-js', :github => 'fnando/i18n-js'
gem 'jbuilder'

# supporting gems
gem 'airbrake', '~> 3.1.2'

# system gems
gem 'mysql2', '~>0.3.11'
gem 'dalli'

gem 'dynamic_form'

# jquery-etmodel-rails contains the jquery.etmodel.js plugin
# When working on the plugin, use :path => '/path/to/etplugin'
# gem "jquery-etmodel-rails", :path => "~/Sites/etplugin"
gem 'jquery-etmodel-rails', ref: 'c668ad4', github: 'quintel/etplugin'
gem 'jquery-qtip2-rails'

group :development do
  gem 'spring'
  gem 'tomdoc'
  gem 'yard-tomdoc', "~> 0.4.0"
  gem 'annotate', :require => false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'seed_dump'

  # Deploy with Capistrano.
  gem 'capistrano',             '~> 3.0',   require: false
  gem 'capistrano-rbenv',       '~> 2.0',   require: false
  gem 'capistrano-rails',       '~> 1.1',   require: false
  gem 'capistrano-bundler',     '~> 1.1',   require: false
  gem 'capistrano3-unicorn',    '~> 0.2',   require: false
  gem 'capistrano-maintenance', '~> 1.0',   require: false
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'rspec-rails', "~> 2.14"
  gem 'watchr'

  gem 'pry-byebug', platforms: [:mri_20, :mri_21]
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.1'
  gem 'shoulda-matchers', require: false
  gem 'webrat'
  gem 'simplecov'
  gem 'webmock', '~> 1.8.0'
  gem 'capybara'
  gem 'launchy'
  gem 'vcr', '~> 2.4.0'
end

group :production, :staging do
  gem 'unicorn'
  gem 'newrelic_rpm'
end

gem 'therubyracer', '~> 0.12.0'
gem 'libv8', '~> 3.16.14.3'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'compass-rails'
gem 'oily_png' # Faster sprite compilation.
