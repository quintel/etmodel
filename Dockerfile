FROM ruby:3.3-slim

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

RUN apt-get update && apt-get install -y curl gnupg \
  && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" \
     | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

 # Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile* package.json yarn.lock /app/
WORKDIR /app

RUN bundle install --jobs=4 --retry=3
RUN yarn install

COPY . /app/

CMD ["./bin/rails", "s", "-b", "0.0.0.0"]
