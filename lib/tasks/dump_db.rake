namespace :db do
  desc 'Dumps the entire database to a gzipped SQL file'
  task dump_sql: :environment do
    config   = Rails.configuration.database_configuration
    host     = config[Rails.env]["host"]
    database = config[Rails.env]["database"]
    username = config[Rails.env]["username"]
    password = config[Rails.env]["password"]

    dump_to  = "#{ database }_#{ Time.now.utc.to_formatted_s(:number) }.sql.gz"

    system([
      'mysqldump', "--user #{ username }",
      password ? "--password=#{ password }" : nil,
      "--host=#{ host }", "#{ database }", "| gzip > tmp/#{ dump_to }"
    ].compact.join(' '))

    puts "tmp/#{ dump_to }"
  end
end
