
set :application, "etmodel"
set :stage, :production
set :server_type, 'production'
set :deploy_to, "/home/ubuntu/apps/etmodel"
set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/etmodel.git"
set :user, 'ubuntu'
set :deploy_via, :remote_cache
# Some files that will need proper permissions set
set :chmod755, "app config db lib public vendor script script/* public/disp*"
ssh_options[:forward_agent] = true
set :use_sudo, false
set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

set :local_db_name, 'etmodel_dev'

task :production do
  set :branch, "production"
  set :domain, "46.137.109.15"
  set :application_key, "#{application}"
  set :db_pass, "Energy2.0"
  set :db_name, application_key
  set :db_user, application_key
  server domain, :web, :app, :db, :primary => true
end

task :staging do
  set :domain, "46.137.123.187"
  set :branch, "staging"
  set :application_key, "#{application}_staging"
  set :db_pass, "feboblokker"
  set :db_name, application_key
  set :db_user, application_key
  server domain, :web, :app, :db, :primary => true
end

# Useful, taken from the capistrano gem
def rake_on_current(*tasks)
  rails_env = fetch(:rails_env, "production")
  rake = fetch(:rake, "rake")
  tasks.each do |t|
    run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end

# RVM Stuff
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3@etmodel'
