source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.0.3'
gem 'jquery-rails'
gem 'haml', '3.0.23'
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem 'bluecloth'
gem 'declarative_authorization', '0.5.1'
gem 'formtastic'
gem 'http_status_exceptions', :git => 'git://github.com/japetheape/http_status_exceptions.git' 
gem 'jammit'
gem 'paper_trail', '>= 1.6.4'
gem 'ruby-graphviz', :require => "graphviz"
gem 'treetop', '1.4.8'
gem 'default_value_for'
gem 'paperclip', '>= 2.3.8'
gem 'acts_as_list'
gem 'ancestry', '~> 1.2.3'

# javascript
gem 'sprockets'
gem 'sprockets-rails'
gem 'rack-sprockets'
gem 'yui-compressor'
gem 'i18n-js'

# supporting gems
gem 'annotate'
gem 'tinder'
gem 'hoptoad_notifier', '2.4.2'
gem 'yard', '0.5.4'

# system gems
gem 'thinking-sphinx', '>=2.0.1'
gem 'mysql' # Legacy support. Can be removed when all servers have changed their database.yml files.
gem 'mysql2'
gem 'memcache-client'
gem 'mongrel', '1.2.0.pre2'

#gem 'perftools.rb', :require => 'perftools'
#gem 'visitbench', '0.3.0'

# Optional gems that were commented in environment.rb
# gem 'authlogic-oid'
gem 'rubyzip', '0.9.4'
gem "ruby-openid", :require => "openid"


group :test, :development do
  # It needs to be in the :development group to expose generators and rake tasks without having to type RAILS_ENV=test.
  gem "rspec-rails", "~> 2.1.0"
  gem 'ruby-debug19'
end

group :test do
  gem "autotest"
  #gem 'jasmine'
  gem 'nokogiri'

  gem 'factory_girl', '>= 1.2.3'
  gem 'webrat'
  gem 'selenium-client', '>= 1.2.18'
  gem 'test-unit', '1.2.3'
  gem 'libxml-ruby'
end


