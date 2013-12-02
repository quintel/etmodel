# Quintel Energy Transition Model

## Build Status

### Master
![Master branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/8647/badge.png)

### Production
![Production branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/110957/badge.png)

### Staging
![Staging branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/81874/badge.png)

## Branches

* **master**: Working branch. Please always commit to this branch and rebase from here.
* **staging**: Tracks [the ETM beta server](http://beta.pro.et-model.com)
* **production**: Tracks [the ETM production server](http://pro.et-model.com)

## Installing

* Install Ruby 1.9.3 or higher. (We can recommend [rbenv](https://github.com/sstephenson/rbenv) by the way.)
* Pull this repository (`git clone git@github.com:quintel/etmodel.git`)
* Create your own `database.yml` and `config.yml` from the samples in `config/`.
* Run `bundle install` to install all the dependencies
* Create local databases with `rake db:create`.
* Clone the database from the staging server using `cap staging db2local`

## Bugs and feature requests

If you encounter a bug or if you have a feature request, you can either let us know by creating an [Issue](issues/new) *or* you can try to fix it yourself and create a [pull request](pulls/new).
