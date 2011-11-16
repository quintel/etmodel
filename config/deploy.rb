require 'bundler/capistrano'

set :application, "etmodel"
set :stage, :production
set :server_type, 'production'

task :production do
  set :branch, "production"
  set :domain, "46.137.109.15"

  set :application_key, "#{application}"
  set :deploy_to, "/home/ubuntu/apps/#{application_key}"
  set :config_files, "/home/ubuntu/config_files/#{application_key}"

  set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
  set :db_pass, "Energy2.0"
  set :db_name, application_key
  set :db_user, application_key

  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
end

task :staging do
  set :domain, "ec2-46-137-123-187.eu-west-1.compute.amazonaws.com"
  set :branch, "staging"

  set :application_key, "#{application}_staging"
  set :deploy_to, "/home/ubuntu/apps/#{application_key}"
  set :config_files, "/home/ubuntu/config_files/#{application_key}"

  set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
  set :db_pass, "1is5sRJmehiULV"
  set :db_name, application_key
  set :db_user, application_key

  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
end


task :release do
  set :domain, "ec2-46-51-146-235.eu-west-1.compute.amazonaws.com"
  set :branch, "release"

  set :application_key, "#{application}_rc"
  set :deploy_to, "/home/ubuntu/apps/#{application}"  ## this is a copy of production, so serverconfig stays the same
  set :config_files, "/home/ubuntu/config_files/#{application}" ## this is a copy of production, so serverconfig stays the same

  set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
  set :db_pass, "Energy2.0"
  set :db_name, application_key
  set :db_user, application_key

  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
end



set :scm, :git
set :repository,  "git@github.com:dennisschoenmakers/etmodel.git"

set :user, 'ubuntu'
set :deploy_via, :remote_cache
set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions set :use_sudo, false
ssh_options[:forward_agent] = true
set :use_sudo,     false

set :rvm_ruby_string, '1.9.2'

set :local_db_name, 'etmodel_dev'

# Useful, taken from the capistrano gem
def rake_on_current(*tasks)
  rails_env = fetch(:rails_env, "production")
  rake = fetch(:rake, "rake")
  tasks.each do |t|
    run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end
