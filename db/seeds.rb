require 'active_record/fixtures'

Dir[Rails.root.join("db/seed", "*.{yml,csv}").to_s].each do |file|
  Fixtures.create_fixtures("db/seed", File.basename(file, '.*'))
end
