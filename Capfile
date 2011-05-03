load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :memcached do 
  desc "Start memcached"
  task :start, :roles => [:app] do
    run "/etc/init.d/memcached start"
  end

  desc "Stop memcached"
  task :stop, :roles => [:app] do
    run "/etc/init.d/memcached stop"
  end

  desc "Restart memcached"
  task :restart, :roles => [:app] do
    run "/etc/init.d/memcached restart"
  end        

  desc "Flush memcached - this assumes memcached is on port 11211"
  task :flush, :roles => [:app] do
    run "echo 'flush_all' | nc -q 1 localhost 11211"
  end     
end


namespace :deploy do
  desc "generate rdoc (only on staging)" 
  task :generate_rdoc  do
    if server_type == 'staging' 
      dir = release_path
      run "cd #{dir}; rake yard;"      
      run "ln -nfs #{dir}/doc #{dir}/public/doc"
    end
  end

  task :after_update_code do
    run "cp #{shared_path}/config_files/database.yml #{release_path}/config/database.yml"
    run "cp #{shared_path}/config_files/server_variables.rb #{release_path}/config/server_variables.rb"
    run "cp #{shared_path}/config_files/hoptoad.rb #{release_path}/config/initializers/hoptoad.rb"
    run "cd #{release_path}; ls -lh public"
    run "cd #{release_path}; chmod 777 public/sprockets public/images public/stylesheets import tmp"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/assets/pdf #{release_path}/public/pdf"
    run "ln -nfs #{shared_path}/vendor_bundle #{release_path}/vendor/bundle"
    run "cd #{release_path} && bundle install"

    #deploy.generate_rdoc
    memcached.flush
    symlink_sphinx_indexes
  end

  desc 'Import seeds on server'
  task :seed, :roles => [:db] do
    run "cd #{deploy_to}/current; rake db:seed RAILS_ENV=#{stage}"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    # The above does not re-index. If any of your define_index blocks
    # in your models have changed, you will need to perform an index.
    # If these are changing frequently, you can use the following
    # in place of running_start

    thinking_sphinx.stop
    if stage == 'production' or stage == 'transitionprice'
      # Only re-index on production servers to save time with deploys
      #  we don't necessarly need search engine on testing & staging.
      thinking_sphinx.index
    end
    thinking_sphinx.start

    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end

  task :after_deploy do
    run "chmod 777 #{release_path}/log/searchd.production.pid"
    deploy.cleanup
    notify_hoptoad
  end
  
  desc "Notify Hoptoad of the deployment"
  task :notify_hoptoad, :except => { :no_release => true } do
    rails_env = fetch(:hoptoad_env, fetch(:rails_env, "production"))
    local_user = ENV['USER'] || ENV['USERNAME']
    notify_command = "rake hoptoad:deploy TO=#{rails_env} REVISION=#{current_revision} REPO=#{repository} USER=#{local_user}"
    case server_type
      when 'transitionprice'
        notify_command << " API_KEY=1d5a09b7fdf676e3ff69d20eba322caa"
      when 'testing'
        notify_command << " API_KEY=05a325f77515e6a413bc4adb8980d3f8"
      when 'staging'
        notify_command << " API_KEY=2c213df905badf7362e925de0b28e7a8"
      when 'prod'
        notify_command << " API_KEY=3ea5a72aad48a32d7bb486bc71ad4fd5"
    end
    
    puts "Notifying Hoptoad of Deploy of #{server_type} (#{notify_command})"
    run "cd #{release_path} && #{notify_command}"
    puts "Hoptoad Notification Complete."
  end

end

desc "Move db server to local db"
task :db2local do
  puts "Exporting db to sql file"
  file = "/root/tmp/etm_#{server_type}.sql"
  run "mysqldump -u root --password=quintel etm_#{server_type} > #{file}"
  puts "Gzipping sql file"
  run "gzip -f #{file}"
  puts "Downloading gzip file"
  get file+".gz", "etm_#{server_type}.sql.gz" 
  puts "Gunzip gzip file"
  system "gunzip -f etm_#{server_type}.sql.gz"
  puts "Importing sql file to db"
  system "mysql -u root etm_dev < etm_#{server_type}.sql"
end


%w[staging testing prod].each do |stage|
  desc "Move #{stage} db to local db"
  task "#{stage}2local" do
    self.send(stage)
    db2local
  end
end