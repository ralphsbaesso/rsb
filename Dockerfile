FROM ruby:2.5.1

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        postgresql-client \
        libpq-dev \
        openjdk-8-jdk \
        vim \
        nano \
        htop \
        cron \
        less \
    && apt-get clean

# remove horario de verao
RUN apt-get --only-upgrade install tzdata

# Set the root of your Rails application
ENV RAILS_ROOT /app
RUN mkdir -p $RAILS_ROOT

# Set working directory to the root path of the Rails app
WORKDIR $RAILS_ROOT

# disable spring
ENV DISABLE_SPRING true

# Do not install gem documentation
RUN echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

# If we copy the whole app directory, the bundle would install
# everytime an application file changed. Copying the Gemfiles first
# avoids this and installs the bundle only when the Gemfile changed.
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler -v 2.1.4
RUN bundler -v
ENV BUNDLER_VERSION 2.1.4
RUN gem install bundler && \
    bundle install --jobs 20 --retry 5

# Now copy the application code to the application directory
COPY . /app
RUN rm -Rf /app/log
RUN rm -Rf /app/tmp

EXPOSE 3000

CMD bin/rails db:create db:migrate && bin/rails s -b 0.0.0.0
