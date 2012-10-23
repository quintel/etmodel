set :application, "etmodel"
set :server_type, 'production'
set :deploy_to, "/u/apps/etmodel"
set :db_host, "etm.cr6sxqj0itls.eu-west-1.rds.amazonaws.com"
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
  set :domain, "et-model.com"
  set :rails_env, "production"
  set :application_key, "etmodel"
  set :db_pass, "HaLjXwRWmu60DK"
  set :db_name, application_key
  set :db_user, application_key
  set :airbrake_key, "aadd4cc40d52dabf842d4dce932e84a3"
  server domain, :web, :app, :db, :primary => true
end

task :staging do
  set :domain, "beta.et-model.com"
  set :branch, "staging"
  set :rails_env, "staging"
  set :application_key, "etmodel_staging"
  set :db_pass, "1is5sRJmehiULV"
  set :db_name, application_key
  set :db_user, application_key
  set :airbrake_key, "a736722b2610573160a2f015f036488b"
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

