# The Energy Transition Model (ETM) Professional

![](https://docs.energytransitionmodel.com/img/docs/20181031_etmodel_screenshot.png)

This is the source code of the [ETM Pro](https://pro.energytransitionmodel.com/):
an online web app that let you create a future energy scenario for various countries, municipalities, neighbourhoods and more.
This software is [Open Source](LICENSE.txt), so you can fork it and alter at your will.

If you have any questions, please [contact us](http://quintel.com/contact).

## Build Status

### Master
[![Master branch](https://semaphoreci.com/api/v1/quintel/etmodel/branches/master/badge.svg)](https://semaphoreci.com/quintel/etmodel)

### Production
[![Production branch](https://semaphoreci.com/api/v1/quintel/etmodel/branches/production/badge.svg)](https://semaphoreci.com/quintel/etmodel)

## License

The ETM pro is released under the [MIT License](LICENSE.txt).

## Branches

* **master**: Working branch and is tracked by [the ETM beta server](https://beta-pro.energytransitionmodel.com/)
* **production**: Tracks [the ETM production server](https://pro.energytransitionmodel.com/)

## Prerequisites

Mac users should be able to install the following prerequisites with [Homebrew](brew.sh), Ubuntu users can use `apt-get`.
*  Ruby 2.6.6 and a Ruby version manager such as [rbenv](https://github.com/rbenv/rbenv)
* Mysql database server
* Yarn 1.22.5

## Installing

* Pull this repository with `git clone git@github.com:quintel/etmodel.git`
  * **Local Engine** You can communicate with either a local version of ETEngine, or one of our servers by specifying the `api_url` in `config.yml`. To use a local version, change the standard beta server url to `http://localhost:<PORT>` based on which port you are running the Engine on.
  * **Database password** If you added a username and password to your mysql service, please replace the standard login info in `database.yml` with your own credentials.

* Run `bundle install` and `yarn install` to install all the dependencies
* Create and fill local database with `rake db:setup` and `RAILS_ENV=test rake db:setup`
* Fire up your local server with `rails server -p3001`
* Go to [localhost:3001](http://localhost:3001) and you should see the ETM pro!

### Admin access

If you want to get admin access to your own page, the easiest way to do so
is to create an Admin User through the console and follow instructions:

    rake db:create_admin

## Bugs and feature requests

If you encounter a bug or if you have a feature request, you can either let us
know by creating an [Issue](http://github.com/quintel/etmodel/issues) *or* you
can try to fix it yourself and create a
[pull request](http://github.com/quintel/etmodel/pulls).

## With thanks...

The Energy Transition Model is built by [Quintel](https://quintel.com/). It is made possible by
open source software, and assets kindly provided for free by many wonderful people and
organisations.

#### Software

* [Backbone.js](https://backbonejs.org/)
* [D3.js](https://d3js.org/)
* [Ruby on Rails](https://rubyonrails.org/)
* [jQuery](https://jquery.com/)
* and [many](https://github.com/quintel/etmodel/blob/master/Gemfile), [many](https://github.com/quintel/etmodel/blob/master/package.json) more ...

#### Icons and images

* [Emily Jäger, OpenMoji](https://openmoji.org/)
* [FontAwesome](https://fontawesome.com/)
* [FreePik, Flaticon](https://www.flaticon.com/)
* [Phosphor](https://phosphoricons.com/)
