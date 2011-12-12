# ETflex Bluepill configuration
# -----------------------------
#
# Bluepill monitors the processes used by ETflex (e.g. Unicorn, Reque) and
# ensures that they are up and running, and not consuming too much memory or
# CPU time (which may indicate a problem).
#
# This configuration is heavily inspired by the following Gist and blog pos:
#
#   https://gist.github.com/973882
#   http://blog.halftoneapp.com/unicorn-bluepill-nginx
#
# For Bluepill documentation, including how to add additional applications to
# be monitored, head here:
#
#   https://github.com/arya/bluepill
#

# Set environment variables
rails_env  = ENV['RAILS_ENV']    || 'production'
rails_root = ENV['RAILS_ROOT']   || "/home/ubuntu/apps/etmodel_nginx/current"

log_file   = "#{rails_root}/log/bluepill.log"

Bluepill.application('etmodel', log_file: log_file) do |app|
  app.process('unicorn') do |process|

    # THE APPLICATION --------------------------------------------------------

    process.pid_file    = "#{rails_root}/tmp/pids/unicorn.pid"
    process.working_dir = "#{rails_root}"

    # Set the command line argument to START Unicorn.
    process.start_command =
      "bundle exec unicorn -D " \
      "-c #{rails_root}/config/unicorn/#{rails_env}.rb " \
      "-E #{rails_env}"

    # Set the command line argument to STOP Unicorn.
    process.stop_command = 'kill -QUIT {{PID}}'

    # Set the command line argument to RESTART Unicorn. (The USR2 causes the
    # master to re-create itself and spawn a new worker pool).
    #
    # TODO Documentation says you need to -QUIT also?
    #
    process.restart_command = 'kill -USR2 {{PID}}'

    # If the process status changes five times within three minutes, stop
    # monitoring for five minutes to give time for things to stabalise.
    process.checks :flapping, times: 5, within: 3.minutes, retry_in: 5.minutes

    # GRACE PERIODS ----------------------------------------------------------

    # After we start the app, how long should we wait until we start
    # monitoring the application. This needs to be long enough for the Rails
    # application and worker processes to boot otherwise Bluepill will think
    # that the process failed to start.
    process.start_grace_time = 10.seconds

    # Same as above, grace period after we've restarted the application
    process.restart_grace_time = 8.seconds

    # APPLICATION CHECKS -----------------------------------------------------

    process.checks :cpu_usage, every: 10, below: 30,            times: 3
    process.checks :mem_usage, every: 10, below: 300.megabytes, times: [3, 5]

    # SETUP UNICORN CHILDREN MONITORING --------------------------------------

    process.monitor_children do |child|
      child.checks :cpu_usage, every: 10, below: 25,            times: 3
      child.checks :mem_usage, every: 10, below: 200.megabytes, times: [3, 5]

      child.stop_command = "kill -QUIT {{PID}}"
    end

  end
end
