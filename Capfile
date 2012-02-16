require 'bundler/capistrano'

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'thinking_sphinx/deploy/capistrano'
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/memcached'
load 'lib/capistrano/sphinx'
load 'lib/capistrano/maintenance'
load 'lib/capistrano/unicorn'

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
  task :link_configuration_files do
    run "ln -s #{shared_path}/config/config.yml #{release_path}/config/"
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/"
    run "ln -s #{shared_path}/config/sphinx.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/assets/pdf #{release_path}/public/pdf"
    run "ln -nfs #{shared_path}/assets/videos #{release_path}/public/videos"
    # memcached.flush
  end

  desc "Notify Airbrake of the deployment"
  task :notify_airbrake, :except => { :no_release => true } do
    rails_env = fetch(:airbrake_env, fetch(:rails_env, "production"))
    local_user = ENV['USER'] || ENV['USERNAME']
    notify_command = "#{bundle_cmd} exec rake RAILS_ENV=production airbrake:deploy \
      TO=#{rails_env} REVISION=#{current_revision} REPO=#{repository}       \
      USER=#{local_user} API_KEY=#{airbrake_key}"
    puts "Notifying Airbrake of Deploy of #{server_type} (#{notify_command})"
    run "cd #{release_path} && #{notify_command}"
    puts "Airbrake Notification Complete."
  end
end

after "deploy:update_code", "deploy:link_configuration_files"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:notify_airbrake"
after "deploy:symlink", "sphinx:symlink_indexes"

# Thinking sphinx keeps hanging on the stop phase.
# If you migrate, run manually thinking_sphinx:rebuild
# after "deploy:migrations", "sphinx:rebuild_and_restart"
