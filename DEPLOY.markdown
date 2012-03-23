# Deploy

The new web server setup uses Nginx + Unicorn. What you should know: files are served by nginx; nginx passes requests to the rails application to unicorn through a unix socket. 

Unicorn is started and kept alive by monit. Monit is started and kept alive by Upstart. The nginx daemon is started by the init `/etc/init.d/nginx` script. (For consistency we should better have upstart manage nginx).

## Nginx

To reload the nginx configuration (a bunch of files in `/etc/nginx/`) the command to run is:

    sudo service nginx restart

The file you will probably be editing is `/etc/nginx/conf.d/APP_NAME.conf`. If the nginx daemon is not running at all you can start it with

    sudo /etc/init.d/nginx start

## Upstart

A few words about upstart, the Ubuntu init daemon, to make things more understandable: upstart defines daemons as jobs. Every job has its own configuration file in `/etc/init` and the file name is `{service}.conf`.
You can check a process status by running `status {service}`. To start or stop a service you use the same syntax: `{start|stop} {service}`.
The monit service is automatically started on boot.

## Unicorn

You can find its configuration in `APP_ROOT/config/unicorn/production.rb`. Monit takes care of the unicorn daemon. If you want to manually kill it you can find its pid in `~/apps/etmodel/shared/pids/unicorn.pid`.
I've added a separate unicorn configuration file for the laptops.

## Deploy in practice

We rarely need to restart nginx. We will more likely restart unicorn.

