require 'bundler/capistrano'
require 'airbrake/capistrano'

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'lib/capistrano/db_recipes'
load 'lib/capistrano/memcached'
load 'lib/capistrano/maintenance'
load 'lib/capistrano/unicorn'
load 'deploy/assets'

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
  task :link_configuration_files do
    run "ln -sf #{shared_path}/config/config.yml #{release_path}/config/"
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/media #{release_path}/public/media"
    run "ln -nfs #{shared_path}/media/videos #{release_path}/public/videos"
  end
end

before "deploy:assets:precompile", "deploy:link_configuration_files"
after "deploy:update_code", "deploy:link_configuration_files"
after "deploy", "deploy:cleanup"
after "deploy", "memcached:flush"
