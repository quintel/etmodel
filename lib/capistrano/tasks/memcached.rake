namespace :memcached do
  desc 'Start memcached'
  task :start do
    on(roles(:app)) { sudo '/etc/init.d/memcached start' }
  end

  desc 'Stop memcached'
  task :stop do
    on(roles(:app)) { sudo '/etc/init.d/memcached stop' }
  end

  desc 'Restart memcached'
  task :restart do
    on(roles(:app)) { sudo '/etc/init.d/memcached restart' }
  end

  desc 'Flush memcached - this assumes memcached is on port 11211'
  task :flush do
    on(roles(:app)) { execute "echo 'flush_all' | nc -q 1 localhost 11211" }
  end
end
