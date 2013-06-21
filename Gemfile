source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.2.13'
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
# Change back to RubyGems once Invalid Byte Sequence error is fixed:
#   https://github.com/fnando/i18n-js/pull/139
gem 'i18n-js', :github => 'fnando/i18n-js'
gem 'jbuilder'

# supporting gems
gem 'airbrake', '~> 3.1.2'

# Used to print process information before each log line.
gem 'better_logging'

# system gems
gem 'mysql2', '~>0.3.11'
gem 'dalli'

gem 'dynamic_form'
gem 'sunspot_rails'

# jquery-etmodel-rails contains the jquery.etmodel.js plugin
# When working on the plugin, use :path => '/path/to/etplugin'
# gem "jquery-etmodel-rails", :path => "~/Sites/etplugin"
gem "jquery-etmodel-rails", '~> 0.3', :git  => "https://github.com/quintel/etplugin.git"
gem 'jquery-qtip2-rails'

group :development do
  gem 'tomdoc'
  gem 'yard-tomdoc', "~> 0.4.0"
  gem 'annotate', :require => false
  gem 'sunspot_solr'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'xray-rails'
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'rspec-rails', "~> 2.12.0"
  gem 'watchr'
  gem 'jasminerice'
end

group :test do
  gem 'factory_girl_rails', '~> 4.1.0'
  gem 'shoulda-matchers', require: false
  gem 'webrat'
  gem 'simplecov'
  gem 'webmock', '~> 1.8.0'
  gem 'capybara', '~> 2.0.2'
  gem 'capybara-webkit', '~> 0.14.1'
  gem 'launchy'
  gem 'vcr', '~> 2.4.0'
end

group :production do
  gem 'unicorn'
end

group :assets do
  gem 'therubyracer', '~> 0.11.1'
  gem 'libv8', '~> 3.11.8.17'
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier'
  gem 'yui-compressor'
  gem 'compass-rails'
  gem 'oily_png' # Faster sprite compilation.
end

gem 'capistrano'
