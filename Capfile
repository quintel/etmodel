load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :memcached do 
  desc "Start memcached"
  task :start, :roles => [:app] do
    sudo "/etc/init.d/memcached start"
  end

  desc "Stop memcached"
  task :stop, :roles => [:app] do
    sudo "/etc/init.d/memcached stop"
  end

  desc "Restart memcached"
  task :restart, :roles => [:app] do
    sudo "/etc/init.d/memcached restart"
  end        

  desc "Flush memcached - this assumes memcached is on port 11211"
  task :flush, :roles => [:app] do
    run "echo 'flush_all' | nc -q 1 localhost 11211"
  end     
end

namespace :ts do
  desc "Start Search"
  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec rake ts:start RAILS_ENV=production"
  end

  desc "Stop Search"
  task :stop, :roles => :app do
    run "cd #{current_path} && bundle exec rake ts:stop RAILS_ENV=production"
  end

  desc "Rebuild Search"
  task :rebuild, :roles => :app do
    run "cd #{current_path} && bundle exec rake ts:stop RAILS_ENV=production"
    run "cd #{current_path} && bundle exec rake ts:config RAILS_ENV=production"
    run "cd #{current_path} && bundle exec rake ts:index RAILS_ENV=production"
    run "cd #{current_path} && bundle exec rake ts:start RAILS_ENV=production"
  end

  desc "Index Search"
  task :index, :roles => :app do
    run "cd #{current_path} && bundle exec rake ts:in RAILS_ENV=production"
  end
end


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

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
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

after "deploy:update_code", "deploy:copy_configuration_files"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:notify_hoptoad"

desc "Move db server to local db"
task :db2local do
  puts "Exporting db to sql file"
  file = "/tmp/#{application_key}.sql"
  run "mysqldump -u #{application_key} --password=Energy2.0 --host=etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com #{application_key} > #{file}"
  puts "Gzipping sql file"
  run "gzip -f #{file}"
  puts "Downloading gzip file"
  get file + ".gz", "#{application_key}.sql.gz"
  puts "Gunzip gzip file"
  system "gunzip -f #{application_key}.sql.gz"
  puts "Importing sql file to db"
  system "mysql -u root etmodel_dev < #{application_key}.sql"
end
