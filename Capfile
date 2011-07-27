load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'thinking_sphinx/deploy/capistrano'
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/memcached'

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
  task :copy_configuration_files do
    run "cp #{config_files}/* #{release_path}/config/"
    run "cd #{release_path}; chmod 777 public/images public/stylesheets tmp"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/assets/pdf #{release_path}/public/pdf"
    run "ln -nfs #{shared_path}/vendor_bundle #{release_path}/vendor/bundle"
    run "cd #{release_path} && bundle install --without development test"

    memcached.flush
    #symlink_sphinx_indexes
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    # The above does not re-index. If any of your define_index blocks
    # in your models have changed, you will need to perform an index.
    # If these are changing frequently, you can use the following
    # in place of running_start
    # thinking_sphinx.stop
    # thinking_sphinx.index
    # thinking_sphinx.start

    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end


  desc "Notify Hoptoad of the deployment"
  task :notify_hoptoad, :except => { :no_release => true } do
    rails_env = fetch(:hoptoad_env, fetch(:rails_env, "production"))
    local_user = ENV['USER'] || ENV['USERNAME']
    notify_command = "bundle exec rake hoptoad:deploy TO=#{rails_env} REVISION=#{current_revision} REPO=#{repository} USER=#{local_user}"
    notify_command << " API_KEY=aadd4cc40d52dabf842d4dce932e84a3"
    puts "Notifying Hoptoad of Deploy of #{server_type} (#{notify_command})"
    run "cd #{release_path} && #{notify_command}"
    puts "Hoptoad Notification Complete."
  end
end

task :before_update_code, :roles => [:app] do
  thinking_sphinx.stop
end

desc "Link up Sphinx's indexes."
task :symlink_sphinx_indexes, :roles => [:app] do
  run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
end


after "deploy:update_code", "deploy:copy_configuration_files"
after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:notify_hoptoad"
