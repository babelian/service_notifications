FROM ruby:2.5.3-alpine3.8

ARG DOCKER_BUILD=1
ENV DOCKER=1

RUN apk add --update \
    build-base \
    ruby-dev \
    sqlite-dev \
    bash \
    git \
    && echo "gem: --no-document" > ~/.gemrc \
    && gem install bundler --version 1.17.3 \
    && gem install nokogiri --version 1.10.4 \
    && gem install sqlite3 --version 1.3.13

RUN mkdir -p /app
WORKDIR /app
COPY lib/service_notifications/version.rb /app/lib/service_notifications/version.rb
COPY Gemfile* service_notifications.gemspec /app/
RUN bundle install
COPY . /app