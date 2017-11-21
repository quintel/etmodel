# The Energy Transition Model (ETM) Professional

![](http://f.cl.ly/items/291h3S0g3E2U3L1T0Z2H/Screen%20Shot%202013-12-10%20at%2013.38.35.png)

This is the source code of the [ETM Pro](http://pro.et-model.com):
an online web app that let you create a future energy scenario for various countries.
This software is [Open Source](LICENSE.txt), so you can fork it and alter at your will.

If you have any questions, please [contact us](http://quintel.com/contact).

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

* **master**: Working branch and is tracked by [the ETM beta server](http://beta.pro.et-model.com)
* **production**: Tracks [the ETM production server](http://pro.et-model.com)

## Dependencies

* Ruby 1.9.3, 2.1.2 or 2.3
* Mysql database server

## Installing

* Pull this repository with `git clone git@github.com:quintel/etmodel.git`
* Create your personal configuration files from the samples with

  ```bash
  cp -vn config/database.sample.yml config/database.yml
  cp -vn config/config.sample.yml config/config.yml
  cp -vn config/email.sample.yml config/email.yml
  ```
  
  for the lazy:
  
  ```bash
  cd config
  for i in *.sample.yml; do; j="$(echo $i | sed 's/.sample//g')"; cp -vn $i $j; done;
  ```
  
  
  * Probably set "standalone" to `true` in "config/config.yml"

* Run `bundle install` to install all the dependencies
* Create and fill local database with `rake db:setup` and `RAILS_ENV=test rake db:setup`
* Fire up your local server with `rails server -p3000`
* Go to [localhost:3000](http://localhost:3000) and you should see the ETM pro!

### Admin access

If you want to get admin access to your own page, the easiest way to do so
is to create an Admin User through the console and follow instructions:

    rake db:create_admin

## Bugs and feature requests

If you encounter a bug or if you have a feature request, you can either let us
know by creating an [Issue](http://github.com/quintel/etmodel/issues) *or* you
can try to fix it yourself and create a
[pull request](http://github.com/quintel/etmodel/pulls).
