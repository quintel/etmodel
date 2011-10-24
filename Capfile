load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'thinking_sphinx/deploy/capistrano'
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/memcached'
load 'lib/capistrano/sphinx'
load 'lib/capistrano/maintenance'

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
  task :copy_configuration_files do
    run "cp #{config_files}/* #{release_path}/config/"
    run "cd #{release_path}; chmod 777 public/images public/stylesheets tmp"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/assets/pdf #{release_path}/public/pdf"
    run "cd #{release_path} && bundle install --without development test"

    memcached.flush
  end

  # with mod_rails these are a no-op
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    memcached.restart
  end

  desc "Notify Airbrake of the deployment"
  task :notify_airbrake, :except => { :no_release => true } do
    rails_env = fetch(:airbrake_env, fetch(:rails_env, "production"))
    local_user = ENV['USER'] || ENV['USERNAME']
    notify_command = "bundle exec rake RAILS_ENV=production airbrake:deploy TO=#{rails_env} REVISION=#{current_revision} REPO=#{repository} USER=#{local_user}"
    if application_key == "etmodel"
      notify_command << " API_KEY=aadd4cc40d52dabf842d4dce932e84a3"
    elsif application_key == "etmodel_staging"
      notify_command << " API_KEY=a736722b2610573160a2f015f036488b"
    elsif application_key == "etmodel_rc"
      notify_command << " API_KEY=8edae760000e07b30fb5099e9585701d"
    end
    puts "Notifying Airbrake of Deploy of #{server_type} (#{notify_command})"
    run "cd #{release_path} && #{notify_command}"
    puts "Airbrake Notification Complete."
  end
end

after "deploy:update_code", "deploy:copy_configuration_files"
# after "deploy", "deploy:migrate"
# after "deploy", "deploy:cleanup" # why?
after "deploy", "deploy:notify_airbrake"
after "deploy:symlink", "sphinx:symlink_indexes"

# Thinking sphinx keeps hanging on the stop phase.
# If you migrate, run manually thinking_sphinx:rebuild
# after "deploy:migrations", "sphinx:rebuild_and_restart"
