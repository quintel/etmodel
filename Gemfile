# frozen_string_literal: true

ruby '2.6.6'

source 'http://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.0.3.7'
gem 'activerecord-session_store'
gem 'activeresource', '~> 5.1'

gem 'jquery-rails', '~> 4.2.2'
gem 'local_time'
gem 'haml', '~> 5.0'
gem 'authlogic'
gem 'openid_connect'
gem 'bcrypt'
gem 'httparty'
gem 'tabs_on_rails', '~> 3.0'
gem 'kaminari', '~> 1.2.1'
gem 'simple_form'
gem 'nokogiri', '~> 1.12'
gem 'rdiscount'
gem 'loofah'
gem 'rails-html-sanitizer', '~> 1.3.0'
gem 'font-awesome-rails'
gem 'non-stupid-digest-assets'
gem 'http_accept_language'
gem 'browser'
gem 'valid_email2'

# javascript
gem 'webpacker'
gem 'babel-transpiler'
gem 'rails-i18n'
gem 'i18n-js', '~> 3'
gem 'jbuilder'

# supporting gems
gem 'sentry-raven'

# system gems
gem 'mysql2'
gem 'dalli'

gem 'dynamic_form'

gem 'jquery-etmodel-rails', ref: '8a64146', github: 'quintel/etplugin'

gem 'inky-rb', require: 'inky'
gem 'premailer-rails'

gem 'ymodel', path: 'lib/ymodel/'

group :development do
  gem 'letter_opener'

  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

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
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'rspec-rails', '~> 4.0'
  gem 'watchr'

  gem 'rubocop', '~> 1.10.0', require: false
  gem 'rubocop-performance',  require: false
  gem 'rubocop-rails',        require: false
  gem 'rubocop-rspec',        require: false

  gem 'pry-byebug', platform: :mri
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.8'
  gem 'shoulda-matchers', require: false
  gem 'rails-controller-testing'
  gem 'simplecov'
  gem 'webmock', '>= 3.5'
  gem 'capybara'
  gem 'launchy'
  gem 'vcr', '~> 3.0.3'
end

group :production, :staging do
  # Puma 5 doesn't support daemon mode (used by capistrano3-puma). We need to investigate if this
  # is an issue. Using Puma 5 with capistrano3-puma's Systemd mode would be a better solution, but
  # this may require privileges unavailable to the SSH user.
  gem 'puma', '< 5'
  gem 'newrelic_rpm'
end

gem 'mini_racer', '>= 0.4.0.beta1'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'oily_png' # Faster sprite compilation.
