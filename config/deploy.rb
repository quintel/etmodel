require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'


set :application, "etmodel"

set :stage, :production

#### UNCOMMENT roles when we setup server

task :production do
  set :domain, "46.137.109.15"
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  set :branch, "master"
  set :server_type, 'production'
end

set :user, 'ubuntu'

set :deploy_to, "/home/ubuntu/apps/#{application}"
set :config_files, "/home/ubuntu/config_files/#{application}"

set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/etmodel.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions set :use_sudo, false
ssh_options[:forward_agent] = true
set :use_sudo,     false
set :rvm_ruby_string, '1.9.2'