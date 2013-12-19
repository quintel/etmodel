set :application, "etmodel"
set :server_type, 'production'
set :deploy_to, "/u/apps/etmodel"
set :scm, :git
set :repository,  "git@github.com:quintel/etmodel.git"
set :user, 'ubuntu'
set :deploy_via, :remote_cache
# Some files that will need proper permissions set
set :chmod755, "app config db lib public vendor script script/* public/disp*"
ssh_options[:forward_agent] = true
set :use_sudo, false
set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'
set :local_db_name, 'etmodel_dev'

task :production do
  set :branch,          'production'
  set :rails_env,       'production'
  set :application_key, 'etmodel'
  set :domain,          read_domain_from_config

  server domain, :web, :app, :db, :primary => true

  set :airbrake_key,    remote_config(:config, :airbrake_api_key)
  set :db_host,         remote_config(:database, :host)
  set :db_name,         remote_config(:database, :database)
  set :db_user,         remote_config(:database, :username)
  set :db_pass,         remote_config(:database, :password)
end

task :staging do
  set :branch,          'staging'
  set :rails_env,       'staging'
  set :application_key, 'etmodel_staging'
  set :domain,          read_domain_from_config

  server domain, :web, :app, :db, :primary => true

  set :airbrake_key,    remote_config(:config, :airbrake_api_key)
  set :db_host,         remote_config(:database, :host)
  set :db_name,         remote_config(:database, :database)
  set :db_user,         remote_config(:database, :username)
  set :db_pass,         remote_config(:database, :password)
end

# Useful, taken from the capistrano gem
def rake_on_current(*tasks)
  rails_env = fetch(:rails_env, rails_env)
  rake = fetch(:rake, "rake")
  tasks.each do |t|
    run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end

# Reads and returns the contents of a remote +path+, caching it in case of
# multiple calls.
def remote_file(path)
  @remote_files ||= {}
  @remote_files[path] ||= YAML.load(capture("cat #{ path }"))
end

# Reads the remote database.yml file to read the value of an attribute. If a
# matching environment variable is set (prefixed with "DB_"), it will be used
# instead.
def remote_config(file, key)
  ENV["DB_#{ key.to_s.upcase }"] ||
    remote_file(
      "#{ shared_path }/config/#{ file }.yml"
    )[rails_env.to_s][key.to_s]
end

# Reads the domain to which we'll deploy. Uses the "domain" setting from
# database.yml, or the DOMAIN environment variable.
def read_domain_from_config
  ENV['DOMAIN'] ||
    YAML.load_file('config/database.yml')[rails_env.to_s]['domain']
end
