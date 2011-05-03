require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'


set :application, "etm"

set :stage, :production


task :staging do
  set :domain, "80.255.251.233"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "staging"
  set :server_type, 'staging'
end

task :testing do
  set :domain, "80.255.251.241"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "testing"
  set :server_type, 'testing'
end
##
# makes the following work. Overrides the staging configuration with production configuration.
# cap prod deploy
#
task :prod do
  set :domain, "80.255.251.223"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "master"
  set :server_type, 'production'
end

#jearprice
task :transitionprice do
  set :domain, "81.30.39.9"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "transitionprice"
  set :server_type, 'production'
end
set :user, 'root'


set :deploy_to, "/var/rails/apps/#{application}"
set :config_files, "/var/rails/config_files"

set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/EnergyConverter.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions set :use_sudo, false
set :git_enable_submodules, 1
# ssh_options[:forward_agent] = true


set :use_sudo,     false