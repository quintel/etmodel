# frozen_string_literal: true

ruby '~> 3.1.1'

source 'http://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 7.1.3'
gem 'activerecord-session_store'
gem 'activeresource', '~> 6.0'

gem 'jquery-rails', '~> 4.4.0'
gem 'local_time'
gem 'haml', '~> 5.0'
gem 'config'
gem 'httparty'
gem 'tabs_on_rails', '~> 3.0'
gem 'kaminari', '~> 1.2.1'
gem 'simple_form'
gem 'nokogiri', '~> 1.16'
gem 'rdiscount', '~> 2.2.7.3'
gem 'loofah'
gem 'rails-html-sanitizer', '~> 1.6'
gem 'font-awesome-rails'
gem 'non-stupid-digest-assets'
gem 'http_accept_language'
gem 'browser'
gem 'valid_email2'
gem 'discard'
gem 'invisible_captcha'
gem 'inline_svg'

# Authentication
gem 'cancancan'
gem 'identity', ref: 'df08519', github: 'quintel/identity_rails'

# javascript
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'shakapacker', '6.0.0'
gem 'babel-transpiler'
gem 'rails-i18n'
gem 'i18n-js', '~> 3'
gem 'jbuilder'

# supporting gems
gem 'sentry-ruby'
gem 'sentry-rails'

# system gems
gem 'mysql2'
gem 'dalli'

gem 'dynamic_form'

gem 'jquery-etmodel-rails', ref: '4f87ea2', github: 'quintel/etplugin'

# Engine
gem 'dry-initializer'
gem 'dry-struct'
gem 'dry-validation'
gem 'dry-monads'

group :development do
  gem 'letter_opener'

  gem 'tomdoc'
  gem 'yard-tomdoc', '~> 0.4.0'

  gem 'better_errors'
  gem 'seed_dump'

  # Deploy with Capistrano.
  gem 'capistrano',             '~> 3.9',   require: false
  gem 'capistrano-rbenv',       '~> 2.0',   require: false
  gem 'capistrano-rails',       '~> 1.1',   require: false
  gem 'capistrano-bundler',     '~> 1.1',   require: false
  gem 'capistrano-maintenance', '~> 1.0',   require: false
  gem 'capistrano3-puma',       '~> 5.0.4', require: false

  gem 'ed25519',                            require: false
  gem 'bcrypt_pbkdf',                       require: false
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
  gem 'capybara', '~> 3.40.0'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.8'
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

group :production, :staging do
  # Puma 5 doesn't support daemon mode (used by capistrano3-puma). We need to investigate if this
  # is an issue. Using Puma 5 with capistrano3-puma's Systemd mode would be a better solution, but
  # this may require privileges unavailable to the SSH user.
  gem 'puma'
  gem 'newrelic_rpm'
end

gem 'mini_racer', '>= 0.12'
gem 'sassc-rails'
gem 'coffee-rails'
gem 'terser'
gem 'oily_png' # Faster sprite compilation.
