def system_v(cmd)
  info "Execute '#{cmd}'"
  system cmd
end

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
        password && "--password=#{ password }"
      ].compact.join(' ')

      info 'Importing database'

      system_v "gunzip -f #{ filename }"

      system_v "mysqladmin -f #{ credentials } drop #{ database }"
      system_v "mysqladmin #{ credentials } create #{ database }"
      system_v "mysql #{ credentials } #{ database } < #{ filename.chomp('.gz') }"

      system_v "rm #{ filename.chomp('.gz') }"

      info 'Finished importing database'
    end
  end
end
