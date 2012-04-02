require 'thinking_sphinx/deploy/capistrano'
namespace :sphinx do
  desc "Link up Sphinx's indexes."
  task :symlink_stuff, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end

  desc "Rebuild and restart"
  task :rebuild_and_restart, :roles => [:app] do
    # The silly TS capistrano recipes are repeating some steps twice
    stop_gracefully
    rake_on_current "thinking_sphinx:configure"
    rake_on_current "thinking_sphinx:index"
    rake_on_current "thinking_sphinx:start"
  end

  task :stop_gracefully do
    begin
      rake_on_current "thinking_sphinx:stop"
    rescue
      puts "ThinkingSphinx is not running. No stop required."
    end
  end
end

after "deploy:symlink", :roles => [:app] do
  sphinx.symlink_stuff
  # rake_on_current "thinking_sphinx:rebuild"
end
