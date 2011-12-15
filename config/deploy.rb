require 'bundler/capistrano'

set :application, "etmodel"
set :stage, :production
set :server_type, 'production'

# Staging uses now nginx while production still uses apache.
# There can be issues when you restart the web server, be sure to check the
# capistrano output.
task :production do
  set :branch, "production"
  set :domain, "46.137.109.15"

  set :application_key, "#{application}"
  set :deploy_to, "/home/ubuntu/apps/#{application_key}"

  set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
  set :db_pass, "Energy2.0"
  set :db_name, application_key
  set :db_user, application_key

  server domain, :web, :app, :db, :primary => true
end

# This is the previous staging server. It is kept for safety reasons, it should
# be dropped as soon as possible.
task :apache do
  set :domain, "79.125.109.178"
  set :branch, "apache"

  set :application_key, "#{application}_staging"
  set :deploy_to, "/home/ubuntu/apps/#{application_key}"

  set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
  set :db_pass, "1is5sRJmehiULV"
  set :db_name, application_key
  set :db_user, application_key

  server domain, :web, :app, :db, :primary => true
end

# This is the new nginx-based beta
#
task :staging do
  set :domain, "46.137.123.187"
  set :branch, "staging"

  set :application_key, "#{application}_staging"
  set :deploy_to, "/home/ubuntu/apps/etmodel_nginx"

  set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
  set :db_pass, "feboblokker"
  set :db_name, application_key
  set :db_user, application_key

  server domain, :web, :app, :db, :primary => true
end

set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/etmodel.git"

set :user, 'ubuntu'
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions set :use_sudo, false
ssh_options[:forward_agent] = true
set :use_sudo,     false

set :local_db_name, 'etmodel_dev'

# Useful, taken from the capistrano gem
def rake_on_current(*tasks)
  rails_env = fetch(:rails_env, "production")
  rake = fetch(:rake, "rake")
  tasks.each do |t|
    run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3@etmodel_nginx'        # Or whatever env you want it to run in.
