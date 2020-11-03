ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim-buster

LABEL maintainer="dev@quintel.com"

RUN apt-get update -yqq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    automake \
    autoconf \
    build-essential \
    curl \
    default-libmysqlclient-dev \
    git \
    libreadline-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    vim \
    zlib1g \
    zlib1g-dev

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash \
 && apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/* \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -y yarn && rm -rf /var/lib/apt/lists/*

COPY Gemfile* /usr/src/app/
COPY lib/ymodel/* /usr/src/app/lib/ymodel/
WORKDIR /usr/src/app
RUN bundle install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
