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
  set :branch, "production"
  set :domain, from_config(:production, :domain)
  set :rails_env, "production"
  set :application_key, "etmodel"
  set :db_pass, from_config(:production, :password)
  set :db_name, application_key
  set :db_user, application_key
  set :airbrake_key, from_config(:production, :airbrake_key)
  set :db_host, from_config(:production, :host)
  server domain, :web, :app, :db, :primary => true
end

task :staging do
  set :domain, from_config(:staging, :domain)
  set :branch, "staging"
  set :rails_env, "staging"
  set :application_key, "etmodel_staging"
  set :db_pass, from_config(:staging, :password)
  set :db_name, application_key
  set :db_user, application_key
  set :airbrake_key, from_config(:staging, :airbrake_key)
  set :db_host, from_config(:staging, :host)
  server domain, :web, :app, :db, :primary => true
end

# Useful, taken from the capistrano gem
def rake_on_current(*tasks)
  rails_env = fetch(:rails_env, rails_env)
  rake = fetch(:rake, "rake")
  tasks.each do |t|
    run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end

# Returns the value of +key+ from the database.yml for a particular
# +environment+
def from_config(environment, key)
  ENV[key.to_s.upcase] ||
    deploy_config(environment)[key.to_s]
end

# Loads the deployment configuration for the given +environment+.
def deploy_config(environment)
  @deploy_config ||= begin
    config = YAML.load_file(File.expand_path('../database.yml', __FILE__))

    unless config.key?(environment.to_s)
      raise "No deploy config found for the #{ environment } environment!"
    end

    config[environment.to_s]
  end
end
