Quintel Energy Transition Model

# THINGS THAT ARE BAD #

* When deploying to the server, all user sessions are lost. Because we flush the mem_cache_store when deploying. We flush the mem_cache_store because this is the easiest and most stable way to make sure no old graphs and gquery caches are left behind.

* FIXED: The subquery mem_cache caching is probably flawed, when a subquery returns Converters.
  (it was only a theoretical problem) But I added a not_cacheable option to gqueries, that force it to not cache.

# Branches #

### master ###

Working branch. Please always commit to this branch and rebase from here.

### staging ###

Tracks deployment on the staging/beta server (http://beta.et-model.com)

### production ###

Branch for the production server (http://et-model.com)

# Guides for Developers #

## How/where do I add a new attribute ##

### Converter attributes ###

Attributes are country-specific fixed numbers. E.g presetdemand, typical_capacity, etc. Some people call them inputs (Alexander).

Assuming you want to add a new attribute "foobar" to converter:

* create a migration
    script/generate migration add_foobar_to_converters foobar:float
* migrate
* in Qernel::ConverterApi add :foobar to the ATTRIBUTES_USED array.

Finished. In the next import of a graph, the attributes will be stored. Make sure that the csv export from wouters excel has the correct attribute name.

### Area data ###

Basically works the same for Area data, except that the actual numbers are not automatically updated, but have to be added manually through /admin/areas.

### Link and Carrier ###

* create migration
in the according Qernel Class
* add an attr_accessor
* update the constructor initialize
or
* update the to_qernel method in the corresponding ActiveRecord model.

## Building/kickstarting on a new machine ##

* Get Ruby 1.9.2 or higher running. (use rvm)
* Make sure you have installed on your machine:
  * memcached
  * sphinx
  * (for the graphs of the etm-graph also Graphviz and imagemagick)
* Checkout our git repository
* Run 'bundle install'
* Create local databases for test and development (eg: etm_dev, etm_test)
* Get ssh access to staging server (ask Dennis)
* Clone the database from the staging server using cap staging db2local


## Deploying ##

To deploy to staging:

    `$: cap staging deploy`

To make capistrano work on production server write *cap prod*:

    `$: cap production deploy`


1. Make sure everything works. Run the tests.

    `(dev)$: rake spec`

2. Commit and push all the changes

    `(dev)$ git push origin dev`

3. Switch to master branch

    `(dev)$ git checkout master`

4.  Merge dev branch

    `(master)$ git merge dev`

5. If merge errors, clean up and commit.

6. Push master branch online

    `(master)$ git push`

7. If you have commited any changes (while in the master branch), merge back into dev

    `(master)$ git checkout dev`
    `(dev)$ git merge master`
    `(dev)$ git checkout master`

8. Now deploy to the *staging* server

    `(master)$ cap staging deploy`
    `(master)$ cap staging deploy:migrations (if migrations exist)`

9. (Optional) Update seed data on the *staging* server

    `(master)$ cap deploy:seed`

10. Test *staging*

11. Deploy to the *production* server

    `(master)$ cap prod deploy`
    `etc.`

12. Switch back to dev branch

    `(master)$ gco dev`

# Deployments #

Paolo can write some nice prose here about the deployment procedure and what mighty scripts to use...

# Search

If the full-text search doesn't work then probably thinking sphinx isn't running. You can start it with

    `cap staging sphinx:rebuild_and_restart`

Or, if the index has already been built

    `cap staging thinking_sphinx:start`


