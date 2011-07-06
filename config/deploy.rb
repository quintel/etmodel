require 'bundler/capistrano'
# require 'thinking_sphinx/deploy/capistrano'
require 'hoptoad_notifier/capistrano'

set :application, "etmodel"
set :stage, :production
set :domain, "46.137.109.15"
set :server_type, 'production'

role :web, domain # Your HTTP server, Apache/etc
role :app, domain # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

#### UNCOMMENT roles when we setup server

task :production do
  set :branch, "master"
  set :application_key, "#{application}"
  set :deploy_to, "/home/ubuntu/apps/#{application_key}"
  set :config_files, "/home/ubuntu/config_files/#{application_key}"
end

task :staging do
  set :application_key, "#{application}_staging"
  set :branch, "staging"
  set :deploy_to, "/home/ubuntu/apps/#{application_key}"
  set :config_files, "/home/ubuntu/config_files/#{application_key}"
end


set :user, 'ubuntu'

set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/etmodel.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions set :use_sudo, false
ssh_options[:forward_agent] = true
set :use_sudo,     false
set :rvm_ruby_string, '1.9.2'
