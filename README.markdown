Quintel Energy Transition Model

# THINGS THAT ARE BAD #

* When deploying to the server, all user sessions are lost. Because we flush the mem_cache_store when deploying. We flush the mem_cache_store because this is the easiest and most stable way to make sure no old graphs and gquery caches are left behind.

* FIXED: The subquery mem_cache caching is probably flawed, when a subquery returns Converters.
  (it was only a theoretical problem) But I added a not_cacheable option to gqueries, that force it to not cache.

# Sections #

## Guides ##

How to add new attributes to converter {ConverterData} (2010-12-28 seb)

## For GQL Users ##

* [GqlQuerySyntaxNode](/doc/Gql/GqlQuerySyntaxNode.html) for a list of available GQL Functions.
* [ConverterApi](/doc/Qernel/ConverterApi.html) for converter-attributes that can be accessed using VALUE(..;...).
* [Carrier](/doc/Qernel/Carrier.html) for carrier-attributes using VALUE(CARRIER(x);...).
* [GraphApi](/doc/Qernel/GraphApi.html) for graph-attributes that can be accessed using GRAPH(...).
* [Area](/doc/Qernel/Area.html) for Area-attributes that can be accessed using AREA(...).


# Branches #

### master ###

The production/online branch. Capistrano will download this branch to the server(s).

### dev ###

Working development version.

### staging ###

Branch for the staging server.


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

* Get Ruby 1.9.1 or higher running. (use rvm)
* Make sure you have installed on your machine:
  * memcached
  * sphinx
  * (for the graphs of the etm-graph also Graphviz and imagemagick)
* Checkout our git repository
* Install all the missing gems
* Create local databases for test and development (eg: etm_dev, etm_test)
* Get ssh access to staging server (ask dennis)
* Clone the database from the staging server using cap staging2local


## Deploying ##

By default capistrano works on staging:

    `$: cap deploy` 

To make capistrano work on production server write *cap prod*:

    `$: cap prod deploy` 


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

## Flow of data migration (mostly for jaap)
Right now (10-10-10)we add the new data on the staging server. When we do a pull from github and, after a migration, the code breaks, then we copy the db from staging to local.

To migrate to the production server we:
- backup the production db
- export the staging db without the tables: scenarios, users & press releases (right now by hand)
- import the exported db into the production

