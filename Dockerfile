FROM ruby:3.1-slim

LABEL maintainer="dev@quintel.com"

RUN apt-get update -yqq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    automake \
    autoconf \
    build-essential \
    curl \
    default-libmysqlclient-dev \
    git \
    gnupg \
    libreadline-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    nodejs \
    vim \
    zlib1g \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

 # Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile* package.json yarn.lock /app/
WORKDIR /app

# Install the V8 pair before the bundle. mini_racer's extconf resolves libv8-node through
# Bundler's restricted load path, and Bundler installs mini_racer before psych, so the gemspec
# reader is broken at exactly that moment: extconf aborts at `require 'libv8-node'`, never learns
# where V8 is, and fails with "Could not create Makefile". Installing both up front means Bundler
# finds them already satisfied instead of compiling mini_racer mid-install. Versions come from the
# lockfile so they cannot drift from it.
RUN LIBV8_VERSION="$(awk '/^    libv8-node \(/ { gsub(/[()]/, ""); print $2; exit }' Gemfile.lock)" \
 && MINI_RACER_VERSION="$(awk '/^    mini_racer \(/ { gsub(/[()]/, ""); print $2; exit }' Gemfile.lock)" \
 && gem install libv8-node -v "$LIBV8_VERSION" --no-document \
 && gem install mini_racer -v "$MINI_RACER_VERSION" --no-document

RUN bundle install --jobs=4 --retry=3
RUN yarn install

COPY . /app/

CMD ["./bin/rails", "s", "-b", "0.0.0.0"]
