# Use the barebones version of Ruby 2.4.
FROM ruby:2.3.4-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Victor Mier <victor@helloliquid.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 git-all --fix-missing --no-install-recommends

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

# ATTENTION: Commented this out in order to use host dir as a volume for development.
#            We'll have to do this in production (if we use Docker).
# Copy in the application code from your work station at the current directory
# over to the working directory.
# COPY . .

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$INSTALL_PATH/public"]

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec rackup -p 3000 -o '0.0.0.0'
