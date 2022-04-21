FROM ruby:2.7.3

ENV TZ="Europe/Paris"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && apt-get install -y postgresql-client libpq-dev libvips ffmpeg yarn curl dirmngr apt-transport-https lsb-release ca-certificates nodejs
RUN gem install bundler --no-document -v 2.3.9

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

