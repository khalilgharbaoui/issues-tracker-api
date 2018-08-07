# Dockerfile
FROM ruby:2.5.1-alpine3.7

# Install system dependencies and remove the cache to free up space afterwards

RUN apk --update add --virtual build-dependencies build-base ruby-dev postgresql-dev postgresql-client libc-dev linux-headers nodejs yarn tzdata bash && rm -rf /var/cache/lists/*_*

# Add the Gemfile and Gemfile.lock from our app
ADD Gemfile /app/
ADD Gemfile.lock /app/
# Add the rest of the app
ADD . /app

# Install bundler and run bundle install to install the gems from
# the Gemfile
RUN gem install bundler --no-rdoc --no-ri
RUN cd /app \
&& bundle install --jobs 16

# Precompile assets
# RUN cd app ; bundle exec rake assets:precompile

# change the owner to nobody instead of the default: root
# RUN chown -R nobody:nogroup /app
# Switch to the nobody user from here on down
# USER nobody

# Set environment variables and their default values
# These can be overridden when we run the container
ENV LANG C.UTF-8
ENV PORT=3000
ENV DOCKENV=true
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true

# Set the working directory for the commands that we run inside containers
# from this image
WORKDIR /app

MAINTAINER Khalil Gharbaoui <kaygeee@gmail.com>

# Set the default command to run, if we don't provide a command when we run
# a container from this Images
CMD ["puma","-e","development"]
