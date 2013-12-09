# Quintel Energy Transition Model PRO

## Build Status

### Master
![Master branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/8647/badge.png)

### Production
![Production branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/110957/badge.png)

### Staging
![Staging branch](https://semaphoreapp.com/api/v1/projects/4c715d68deace497255af08727d617d510d3e01d/81874/badge.png)

## License

The ETM pro is released under the [MIT License](LICENSE.txt).

## Branches

* **master**: Working branch. Please always commit to this branch and rebase from here.
* **staging**: Tracks [the ETM beta server](http://beta.pro.et-model.com)
* **production**: Tracks [the ETM production server](http://pro.et-model.com)

## Installing

* Install Ruby 1.9.3 or higher.
* Pull this repository with `git clone git@github.com:quintel/etmodel.git`
* Create your personal configuration files from the samples with
  ```
  cp -vn config/database.sample.yml config/database.yml
  cp -vn config/config.sample.yml config/config.yml
  cp -vn config/email.sample.yml config/email.yml
  ```

* Run `bundle install` to install all the dependencies
* Create local database with `rake db:create`
* Fill the database with `rake db:reset`
* Fire up your local server with `rails server -p3000`
* Got to [localhost:3000][http://localhost:3000] and you should see the ETM pro!

### Admin access

If you want to get admin access to your own page, the easiest way to do so
is to create an Admin User through the console and follow instructions:

    rake db:create_admin

## Bugs and feature requests

If you encounter a bug or if you have a feature request, you can either let us
know by creating an [Issue](github/quintel/etmodel/issues) *or* you can try to
fix it yourself and create a [pull request](github.com/quintel/pulls).
