namespace :ci do
  desc <<-DESC
    Runs tasks to prepare a CI build on Semaphore.
  DESC

  task :setup do
    # Config.
    %w[config email].each do |file|
      if File.exists?("config/#{ file }.yml")
        raise "config/#{ file }.yml already exists. Not continuing."
      end

      config = YAML.load_file("config/#{ file }.sample.yml")
      File.write("config/#{ file }.yml", YAML.dump(config))
    end
  end
end
