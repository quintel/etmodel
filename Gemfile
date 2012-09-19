source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.2.8'
gem 'jquery-rails', "~> 2.0.2"
gem 'haml', '~>3.1.4'
gem 'authlogic'
gem 'paper_trail', '~>2.2.4'
gem 'httparty', '~> 0.7.4'
gem 'tabs_on_rails', '~>2.1.1'
gem 'kaminari', '~> 0.13.0'
gem 'simple_form'
gem 'acts_as_commentable'
gem 'nokogiri'

# javascript
gem 'i18n-js'
gem 'jbuilder'

# supporting gems
gem 'airbrake', '~> 3.1.2'

# system gems
gem 'mysql2', '~>0.3.11'
gem 'memcache-client'

gem 'dynamic_form'
gem 'sunspot_rails'

# jquery-etmodel-rails contains the jquery.etmodel.js plugin
# When working on the plugin, use :path => '/path/to/etplugin'
# gem "jquery-etmodel-rails", :path => "~/Sites/etplugin"
gem "jquery-etmodel-rails", '~> 0.2.2', :git  => "git://github.com/dennisschoenmakers/etplugin"

group :development do
  gem 'tomdoc'
  gem 'yard-tomdoc', "~> 0.4.0"
  gem 'annotate', :require => false
  gem 'sunspot_solr'
  gem 'quiet_assets'
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'rspec-rails', "~> 2.11.0"
  gem 'watchr'
end

group :test do
  gem 'factory_girl_rails', '~> 3.0'
  gem 'shoulda-matchers'
  gem 'webrat'
  gem 'simplecov'
  gem 'webmock'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'launchy'
  gem 'vcr'
end

group :production do
  gem 'unicorn'
end

group :assets do
  gem 'therubyracer', '0.11.0beta6'
  gem 'libv8', '~> 3.11.8'
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier'
  gem 'yui-compressor'
  gem 'compass-rails'
  gem 'oily_png' # Faster sprite compilation.
end

gem 'capistrano'
gem 'hipchat'
