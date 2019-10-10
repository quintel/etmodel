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

      cp "config/#{file}.sample.yml", "config/#{file}.yml"
    end
  end
end
