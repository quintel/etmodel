# Runs a Bluepill command.
#
# @param [String] command The command to be sent to Bluepill.
#
def run_bluepill(command)
  run "/usr/local/rvm/bin/193_bluepill #{command} --no-privileged"
end

# Bluepill is used to monitor the Unicorn processes.
namespace :bluepill do
  desc <<-DESC
    Loads Bluepill. Begins the processes it is expected to monitor (Unicorn) \
    and relaunches them should they crash.
  DESC
  task :start, roles: :app do
    puts '*** Cannot manually start Bluepill; it is managed by Upstart.'
    puts '    See: /etc/init/bluepill-etflex.conf'
  end

  desc <<-DESC
    Restarts Bluepill reloading the configuration. Since Bluepill is an \
    Upstart job, simply quitting Bluepill is sufficient since Upstart will \
    bring it right back up again. Unless the Bluepill config has been \
    changed, you probably want bluepill::restart_monitored instead.
  DESC
  task :restart, roles: :app do
    run_bluepill 'stop'
    run_bluepill 'quit'
  end

  desc <<-DESC
    Restarts Bluepill-monitored processes. This is more graceful than \
    restarting Bluepill itself, since Unicorn won't drop connections for \
    anyone currently in the middle of a request.
  DESC
  task :restart_monitored, roles: :app do
    run_bluepill 'restart'
  end

  desc <<-DESC
    Shows the current Bluepill status. Outputs useful information on the \
    health and status of the processes being monitored by Bluepill.
  DESC
  task :status, roles: :app do
    run_bluepill 'status'
  end
end
