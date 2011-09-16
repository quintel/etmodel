namespace :db do
  desc "Move production db to staging db, overwriting everything"
  task :prod2staging do    
    warning("You know what you're doing, right? You will overwrite the staging db!")
    
    puts "Loading production environment"
      production
    puts "Dumping database #{db_name} to /tmp"
      file = dump_db_to_tmp
    puts "Loading staging environment"
      staging
      puts "target database: #{db_name}"
    puts "I should now be emptying staging"
      db.empty
    puts "And filling staging with production data"
      load_sql_into_db(file)
  end

  desc "Move staging db to production db, overwriting only the safe tables"
  task :staging2prod do
    puts "this recipe is not ready yet"
    # tables = %w{
    #   areas
    #   carriers
    #   converter_positions
    #   converters
    #   converters_groups
    #   dataset_carrier_data
    #   dataset_converter_data
    #   dataset_link_data
    #   dataset_slot_data
    #   gql_test_cases
    #   gqueries
    #   gquery_groups
    #   graphs
    #   groups
    #   inputs
    #   links
    #   query_table_cells
    #   query_tables
    #   slots
    #   versions
    # }
    # # We're not updating scenarios!
    # 
    # warning("You know what you're doing, right? You will overwrite most production tables!")
    # 
    # puts "Loading staging environment"
    #   staging
    #   # partial dump of staging
    #   file = dump_db_to_tmp(tables)
    #   get file
    # puts "Loading production environment"
    #   production
    #   load_sql_into_db(file)
  end
  
  desc "Empty db - be sure you know what you're doing"
  task :empty do
    warning("You know what you're doing, right? This will drop the current db")
    
    puts "Dropping the remote db and recreating a new one!"
    puts "I'll first make a backup on /tmp though"
    dump_db_to_tmp
    run "mysqladmin drop #{db_name}"
    run "mysqladmin create #{db_name} -u #{db_user} --password=#{db_pass}"
  end
  
  desc "If you've unintenionally ran db:empty"
  task :oops do
    puts "Shame on you!"
    file = "/tmp/#{db_name}.sql"
    run "mysql -u #{db_user} --password=#{db_pass} --host=#{db_host} #{db_name} < #{file}"
  end
end

desc "Move db server to local db"
task :db2local do
  file = dump_db_to_tmp
  puts "Gzipping sql file"
    run "gzip -f #{file}"
  puts "Downloading gzip file"
    get file + ".gz", "#{db_name}.sql.gz"
  puts "Gunzip gzip file"
    system "gunzip -f #{db_name}.sql.gz"
  puts "Importing sql file to db"
    system "mysqladmin -f -u root drop #{local_db_name}"
    system "mysqladmin -u root create #{local_db_name}"
    system "mysql -u root #{local_db_name} < #{db_name}.sql"
end

# Helper methods

# dumps the entire db to the tmp folder and returns the full filename
# the optional tables parameter should be an array of string
def dump_db_to_tmp(tables = [])
  file = "/tmp/#{db_name}.sql"
  puts "Exporting db to sql file, filename: #{file}"
  run "mysqldump -u #{db_user} --password=#{db_pass} --host=#{db_host} #{db_name} #{tables.join(' ')}> #{file}"
  file
end

# watchout! this works on remote boxes, not on the developer box
def load_sql_into_db(file)
  puts "Importing sql file to db"
  run "mysql -u #{db_user} --password=#{db_pass} --host=#{db_host} #{db_name} < #{file}"
end

def warning(msg)
  puts "Warning! These tasks have destructive effects."
  unless Capistrano::CLI.ui.agree(msg)
    puts "Wise man"; exit
  end
end
