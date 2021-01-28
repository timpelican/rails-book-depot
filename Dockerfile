FROM ruby:2.6

LABEL maintainer="tim@pelican.org"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
	nodejs \
	yarn

WORKDIR /usr/src/app

# Gems
COPY Gemfile* /usr/src/app/
ENV BUNDLE_PATH /gems
RUN bundle install

# Yarn
COPY package.json /usr/src/app/
RUN yarn install --check-files

COPY . /usr/src/app/
#Should only ever have to run this once!
#RUN bin/rails webpacker:install

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
