# Deploy

The new web server setup uses Nginx + Unicorn. What you should know: files are served by nginx; nginx passes requests to the rails application to unicorn through a unix socket. 

Unicorn is started and kept alive by Bluepill. Bluepill is started and kept alive by Upstart. The nginx daemon is started by the init `/etc/init.d/nginx` script. (For consistency we should better have upstart manage nginx).

## Nginx

To reload the nginx configuration (a bunch of files in `/etc/nginx/`) the command to run is:

    sudo killall -HUP nginx

The file you will probably be editing is `/etc/nginx/conf.d/APP_NAME.conf`.

## Upstart

A few words about upstart, the Ubuntu init daemon, to make things more understandable: upstart defines daemons as jobs. Every job has its own configuration file in `/etc/init` and the file name is `{service}.conf`.
You can check a process status by running `status {service}`. To start or stop a service you use the same syntax: `{start|stop} {service}`.
The bluepill service is automatically started on boot and the command that actually starts bluepill is

    exec su -s /bin/sh -c 'exec "$0" "$@"' ubuntu -- /usr/local/rvm/bin/193_bluepill load /home/ubuntu/apps/etmodel/current/config/bluepill/production.rb --no-privileged

You may notice the rvm wrapper script.

## Bluepill

Bluepill is a process monitoring tool written in ruby. Once you have a configuration file (ours is `APP_ROOT/config/bluepill/nginx.rb`) you can load it running:

    sudo bluepill load {configuration file}

To check its status run

    sudo bluepill status

To start or stop a service run

    sudo bluepill [process name] {start|stop|restart} 

The process name is defined in the configuration file. In our case it is called `unicorn`. If you omit the process name then the command will be applied to all processes.
In our setup the bluepill executable is `/usr/local/rvm/bin/193_bluepill`. We can think about adding it to $PATH.

## Unicorn

You can find its configuration in `APP_ROOT/config/unicorn/production.rb`.

## Deploy in practice

We rarely need to restart nginx. We will more likely restart unicorn. The capistrano recipe `bluepill:restart_monitored` takes care of this and is aumotically called at the end of `cap [environment] deploy`, so there should be no need to call it manually.

## Links

* https://github.com/arya/bluepill/blob/master/README.md