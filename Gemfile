# frozen_string_literal: true

ruby '~> 3.4.7'

source 'http://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'activerecord-session_store'
gem 'activeresource', '~> 6.0'
gem 'rails', '~> 8.1.0'

gem 'browser'
gem 'config'
gem 'discard'
gem 'font-awesome-rails'
gem 'haml', '~> 5.0'
gem 'http_accept_language'
gem 'httparty'
gem 'inline_svg'
gem 'invisible_captcha'
gem 'jquery-rails', '~> 4.4.0'
gem 'kaminari', '~> 1.2.1'
gem 'local_time'
gem 'loofah'
gem 'nokogiri', '~> 1.19'
gem 'non-stupid-digest-assets', github: 'alexspeller/non-stupid-digest-assets'
gem 'rails-html-sanitizer', '~> 1.6'
gem 'rdiscount', '~> 2.2.7.3'
gem 'simple_form'
gem 'tabs_on_rails', '~> 3.0'
gem 'valid_email2'

# Authentication
gem 'cancancan'
gem 'identity', ref: '26f582e', github: 'quintel/identity_rails'

# javascript
gem 'babel-transpiler'
gem 'i18n-js', '~> 3'
gem 'jbuilder'
gem 'rails-i18n'
gem 'shakapacker', '9.5.0'
gem 'sprockets-rails', require: 'sprockets/railtie'

# supporting gems
gem 'sentry-rails'
gem 'sentry-ruby'

# system gems
gem 'solid_cache'
gem 'mysql2'

gem 'dynamic_form'

gem 'jquery-etmodel-rails', ref: '4f87ea2', github: 'quintel/etplugin'

# Engine
gem 'dry-initializer'
gem 'dry-monads'
gem 'dry-struct'
gem 'dry-validation'

group :development do
  gem 'letter_opener'

  gem 'tomdoc'
  gem 'yard-tomdoc', '~> 0.4.0'

  gem 'better_errors'
  gem 'seed_dump'
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'rspec-rails', '~> 6.1.2'
  gem 'watchr'

  gem 'rubocop', '~> 1.0',    require: false
  gem 'rubocop-performance',  require: false
  gem 'rubocop-rails',        require: false
  gem 'rubocop-rspec',        require: false

  gem 'pry-byebug', platform: :mri
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver', '~> 4.10'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
  gem 'vcr', '~> 6.0'
  gem 'webdrivers', '~> 5.3.0'
  gem 'webmock', '>= 3.5'
end

gem 'puma'

group :production, :staging do
  gem 'newrelic_rpm'
end

gem 'coffee-rails'
gem 'mini_racer', '>= 0.12'
gem 'oily_png' # Faster sprite compilation.
gem 'sassc-rails'
gem 'terser'
