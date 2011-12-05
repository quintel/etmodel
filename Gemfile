source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.0.11'
gem 'jquery-rails', "~> 1.0.19"
gem 'haml', '~>3.1.1'
gem 'sass', '~>3.1.1'
gem 'authlogic'
gem 'bluecloth'
gem 'paper_trail', '~>2.2.4'
gem 'default_value_for'
gem 'acts_as_list'
gem 'ancestry', '~> 1.2.3'
gem 'httparty', '~> 0.7.4'
gem 'tabs_on_rails', '~>2.0.1'
gem 'kaminari'
gem 'simple_form'
gem 'acts_as_commentable'

# javascript
gem 'sprockets' # CHECK
gem 'sprockets-rails' # CHECK
gem 'rack-sprockets' # CHECK
gem 'yui-compressor'
gem 'i18n-js'

# supporting gems
gem 'airbrake', '~> 3.0.5'
gem 'newrelic_rpm'

# system gems
gem 'thinking-sphinx', '>=2.0.1'
gem 'mysql2', '~>0.2.6'
gem 'memcache-client'
gem 'mongrel', '1.2.0.pre2'

group :development do
  gem 'yard'
  gem 'annotate', :require => false
  gem 'jslint_on_rails'
  gem 'active_reload', '~> 0.6.1'
end

group :test, :development do
  # It needs to be in the :development group to expose generators and rake tasks without having to type RAILS_ENV=test.
  gem "rspec-rails", "~> 2.7.0"
  gem 'ruby-debug19'
  gem 'pry'
  gem 'watchr'
  gem 'spork'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'webrat'
  gem 'simplecov'
  gem 'fakeweb'
end
