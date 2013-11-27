# Quintel Energy Transition Model

## Build Status

### Master
![Master branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/8647/badge.png)

### Tutorial
![Tutorial branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/18439/badge.png)

## Branches

* **master**: Working branch. Please always commit to this branch and rebase from here.
* **staging**: Tracks [the beta server](http://beta.et-model.com)
* **production**: Tracks [the production server](http://et-model.com)

## Installing

* Get Ruby 1.9.2 or higher running. (use rbenv)
* Make sure you have installed on your machine:
  * memcached
* Pull this repository with `git clone git@github.com:dennisschoenmakers/etmodel.git`
* Create your own `database.yml` and `config.yml` from the samples in `config/`
* Run `bundle install`
* Run `memcached -d`
* Create local databases for test and development (eg: `etmodel_dev`, `etmodel_test`)
* Get ssh access to staging server (ask Dennis)
* Clone the database from the staging server using `cap staging db2local`

## Deploying

Make sure everything works. Run the tests.

    $> rake spec

To deploy to staging:

    $> cap staging deploy

Do not deploy directly to production, unless you know what you're doing.
