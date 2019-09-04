ruby '2.6.3'

source 'http://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2'
gem 'activerecord-session_store'
gem 'activeresource', '~> 5.0'

gem 'jquery-rails', "~> 4.2.2"
gem 'haml', '~> 5.0'
gem 'authlogic'
gem 'bcrypt'
gem 'httparty'
gem 'tabs_on_rails', '~> 3.0'
gem 'kaminari', '~> 1.0.1'
gem 'simple_form'
gem 'nokogiri', '~> 1.10'
gem 'rdiscount'
gem 'loofah'
gem 'rails-html-sanitizer'
gem 'font-awesome-rails'
gem 'non-stupid-digest-assets'
gem 'http_accept_language'

# javascript
gem 'rails-i18n'
gem 'i18n-js', '~> 3'
gem 'jbuilder'

# supporting gems
gem 'sentry-raven'

# system gems
gem 'mysql2'
gem 'dalli'

gem 'dynamic_form'

# Reports / PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# jquery-etmodel-rails contains the jquery.etmodel.js plugin
# When working on the plugin, use :path => '/path/to/etplugin'
# gem "jquery-etmodel-rails", :path => "~/Sites/etplugin"
gem 'jquery-etmodel-rails', ref: 'c668ad4', github: 'quintel/etplugin'

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'tomdoc'
  gem 'yard-tomdoc', "~> 0.4.0"

  gem 'better_errors'
  gem 'seed_dump'

  # Deploy with Capistrano.
  gem 'capistrano',             '~> 3.9',   require: false
  gem 'capistrano-rbenv',       '~> 2.0',   require: false
  gem 'capistrano-rails',       '~> 1.1',   require: false
  gem 'capistrano-bundler',     '~> 1.1',   require: false
  gem 'capistrano-maintenance', '~> 1.0',   require: false
  gem 'capistrano3-puma',       '~> 3.1.1', require: false
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'rspec-rails', "~> 3.5"
  gem 'watchr'

  gem 'rubocop', '~> 0.71.0', require: false
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
  gem 'puma'
  gem 'newrelic_rpm'
end

gem 'therubyracer', '~> 0.12.0'
gem 'libv8', '~> 3.16.14.3'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'compass-rails'
gem 'compass-blueprint'
gem 'oily_png' # Faster sprite compilation.
