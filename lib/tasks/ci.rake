namespace :ci do
  desc <<-DESC
    Runs tasks to prepare a CI build on Semaphore.
  DESC

  task :setup do
    # Config.
    if File.exists?('config/config.yml')
      raise 'config/config.yml already exists. Not continuing.'
    end

    config = YAML.load_file('config/config.sample.yml')
    File.write('config/config.yml', YAML.dump(config))
  end
end
