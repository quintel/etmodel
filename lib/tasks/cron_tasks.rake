task :clean_expired_api_scenarios => :environment do
  count = ApiScenario.expired.count
  all = ApiScenario.count
  ApiScenario.expired.delete_all
  puts "#{count} (total: #{all}) expired api_scenarios deleted"
end