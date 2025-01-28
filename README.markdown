# The Energy Transition Model (ETM) Professional


![](https://docs.energytransitionmodel.com/img/docs/20181031_etmodel_screenshot.png)

This is the source code of the [ETM Pro](https://pro.energytransitionmodel.com/):
an online web app that let you create a future energy scenario for various countries, municipalities, neighbourhoods and more.
This software is [Open Source](LICENSE.txt), so you can fork it and alter at your will.

If you have any questions, please [contact us](http://quintel.com/contact).

## Build Status

### Master
[![Build Status](https://quintel.semaphoreci.com/badges/etmodel/branches/master.svg)](https://quintel.semaphoreci.com/projects/etmodel)

### Production
[![Build Status](https://quintel.semaphoreci.com/badges/etmodel/branches/production.svg)](https://quintel.semaphoreci.com/projects/etmodel)

## License

The ETM pro is released under the [MIT License](LICENSE.txt).

## Branches

* **master**: Working branch and is tracked by [the ETM beta server](https://beta-pro.energytransitionmodel.com/)
* **production**: Tracks [the ETM production server](https://pro.energytransitionmodel.com/)

## Installation with Docker

New users are recommended to use Docker to run ETEngine. Doing so will avoid the need to install additional dependencies.

1. Get a copy of [ETModel](https://github.com/quintel/etmodel). You may choose to clone the repository using Git, or download a ZIP archive from Github.

2. Build the ETModel image:

    ```sh
    docker-compose build
    ```

3. Install dependencies and seed the database:

   ```sh
   docker-compose run --rm web bash -c 'bin/rails db:drop && bin/setup'
   ```

   This command drops any existing ETModel database; be sure only to run this during the initial setup! This step will also provide you with an e-mail address and password for an administrator account.

4. By default, ETModel will send requests to the beta (staging) version of ETEngine. This is used for testing purposes and is more frequently updated than the live (production) version.

    #### Run ETEngine locally

    If you wish to run [a local copy of ETEngine](https://github.com/quintel/etengine#installation-with-docker), ETModel must be told where to find its API. You must first find your machine's local/private IP address; ETModel will use this to send messages directly to ETEngine, and also by your browser when you are using the ETModel application to create scenarios. To get your IP address, run:

    ```sh
    ipconfig getifaddr en0   # on macOS
    hostname -I              # on Linux
    ipconfig                 # on Windows
    ```

    * [macOS](https://www.hellotech.com/guide/for/how-to-find-ip-address-on-mac)
    * [Ubuntu](https://help.ubuntu.com/stable/ubuntu-help/net-findip.html.en)

    Create a file called `config/settings.local.yml` containing:

    ```yaml
    ete_url: http://YOUR_IP_ADDRESS:3000
    ```

    #### Branches

    When running ETEngine locally, be sure to use the same branch or tag for ETModel, ETEngine, and ETSource. You are likely to encounter errors if you fail to do so.

    For example, if you wish to run the latest version all three should be set to the `master` branch. If you wish to run the production release from March 2022, they should all use the same tag:

    ```sh
    cd ../etengine && git checkout 2022.03
    cd ../etsource && git checkout 2022.03
    cd ../etmodel  && git checkout 2022.03
    ```

5. Launch the containers:

   ```
   docker-compose up
   ```

   After starting application will become available at http://localhost:3001 after a few seconds. This is indicated by the message "Listening on http://0.0.0.0:3001".

## Installation without Docker

### Prerequisites

Mac users should be able to install the following prerequisites with [Homebrew](brew.sh), Ubuntu users can use `apt-get`.
*  Ruby 2.6.6 and a Ruby version manager such as [rbenv](https://github.com/rbenv/rbenv)
* Mysql database server
* Yarn 1.22.5

### Installing

* Pull this repository with `git clone git@github.com:quintel/etmodel.git`
  * **Local Engine** You can communicate with either a local version of ETEngine, or one of our servers by specifying the `ete_url` in `config.yml`. To use a local version, change the standard beta server url to `http://localhost:<PORT>` based on which port you are running the Engine on.
  * **Database password** If you added a username and password to your mysql service, please replace the standard login info in `database.yml` with your own credentials.

* Run `bundle install` and `yarn install` to install all the dependencies
* Create and fill local database with `rake db:setup` and `RAILS_ENV=test rake db:setup`
* Fire up your local server with `rails server -p3001`
* Go to [localhost:3001](http://localhost:3001) and you should see the ETM pro!

## Admin access

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

#### Wiki

[Wiki](../../wiki)
