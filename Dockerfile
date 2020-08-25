ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim-buster

LABEL maintainer="dev@quintel.com"

RUN apt-get update -yqq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    automake \
    autoconf \
    build-essential \
    default-libmysqlclient-dev \
    git \
    libreadline-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    nodejs \
    vim \
    zlib1g \
    zlib1g-dev

COPY Gemfile* /usr/src/app/
COPY lib/ymodel/* /usr/src/app/lib/ymodel/
WORKDIR /usr/src/app
RUN bundle install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
