# syntax=docker/dockerfile:1
FROM ruby:2.7.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem update --system 3.2.3
RUN gem install bundler -v 2.3.27

ENV APP_HOME /myapp
WORKDIR $APP_HOME
COPY . $APP_HOME
ENV BUNDLE_PATH /bundle
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Run yarn install after copying project files
RUN yarn install --check-files

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]