source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '~>4.0.1'
gem 'activerecord-session_store'
gem 'activeresource'

gem 'jquery-rails', "~> 2.0.2"
gem 'haml', '~>4.0'
gem 'authlogic'
gem 'httparty', '~> 0.7.4'
gem 'tabs_on_rails', '~>2.1.1'
gem 'kaminari', '~> 0.13.0'
gem 'simple_form'
gem 'nokogiri', '~> 1.6'
gem 'redcarpet'

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
gem "jquery-etmodel-rails", '~> 0.3', :git  => "https://github.com/quintel/etplugin.git"
gem 'jquery-qtip2-rails'

group :development do
  gem 'tomdoc'
  gem 'yard-tomdoc', "~> 0.4.0"
  gem 'annotate', :require => false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'xray-rails'
  gem 'seed_dump'
end

group :test, :development do
  gem 'debugger', '~> 1.6.1'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'rspec-rails', "~> 2.12.0"
  gem 'watchr'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.1.0'
  gem 'shoulda-matchers', require: false
  gem 'webrat'
  gem 'simplecov'
  gem 'webmock', '~> 1.8.0'
  gem 'capybara'
  gem 'launchy'
  gem 'vcr', '~> 2.4.0'
end

group :production do
  gem 'unicorn'
end

gem 'therubyracer', '~> 0.12.0'
gem 'libv8', '~> 3.16.14.3'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'yui-compressor', github: 'sstephenson/ruby-yui-compressor'
gem 'compass-rails', '~> 2.0.alpha.0'
gem 'oily_png' # Faster sprite compilation.

gem 'capistrano', '~> 2'
