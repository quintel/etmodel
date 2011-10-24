namespace :maintenance do
  desc "Show offline page"
  task :offline do
    run "cd #{current_path}/public && cp offline.html index.html"
  end
  
  desc "Remove offline page"
  task :online do
    run "cd #{current_path}/public && rm index.html"
  end  
end