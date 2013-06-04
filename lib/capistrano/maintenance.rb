namespace :maintenance do
  desc "Show offline page"
  task :offline do
    run "cd #{current_path}/public && cp offline.html system/maintenance.html"
  end

  desc "Remove offline page"
  task :online do
    run "cd #{current_path}/public && rm system/maintenance.html"
  end
end
