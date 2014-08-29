desc 'Copy database from the server to your local database'
task db2local: ['deploy:set_rails_env'] do
  on roles(:app) do
    within current_path do
      filename = nil

      info 'Creating DB export'

      with rails_env: fetch(:rails_env) do
        filename = capture(:rake, 'db:dump_sql').strip
      end

      download!(current_path.join(filename), filename)
      execute(:rm, current_path.join(filename))

      local_conf = YAML.load_file('config/database.yml')['development']

      username   = local_conf['username']
      password   = local_conf['password']
      database   = local_conf['database']

      credentials = [
        "--user=#{ username }",
        password ? "-p #{ password }" : ''
      ].compact.join(' ')

      info 'Importing database'

      system "gunzip -f #{ filename }"

      system "mysqladmin -f #{ credentials } drop #{ database }"
      system "mysqladmin #{ credentials } create #{ database }"
      system "mysql #{ credentials } #{ database } < #{ filename.chomp('.gz') }"

      system "rm #{ filename.chomp('.gz') }"

      info 'Finished importing database'
    end
  end
end
