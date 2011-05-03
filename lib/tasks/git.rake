namespace :git do
  desc 'Find last tests'
  task :last_changed_tests do
    
    amt_days = ENV["DAYS"] ? ENV["DAYS"].to_i : 5
    few_days_ago = (Time.now - amt_days.days).strftime("%Y/%m/%d")
    command = %{git log --raw --since=%s | grep "spec/.*.rb$" | cut -c37-} % few_days_ago
  
    puts `#{command}`
  end
  
  
  
  desc 'Copy database to branch specific database'
  task :create_branch_dbs  do
    branch = current_branch
    puts "Setting git config..."
    `git config --bool branch.#{branch}.database true`
    puts "Creating databases..."
    `rake db:create`
    puts "Copying etm_dev_dev to etm_dev_#{branch}..."
    `mysqldump -u root etm_dev_dev | mysql -u root etm_dev_#{branch}`
    puts "Copying etm_test_dev to etm_test_#{branch}..."
    `mysqldump -u root etm_test_dev | mysql -u root etm_test_#{branch}`
  end
  
  def current_branch
    `git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'`.gsub('*', '').strip
  end
    
end