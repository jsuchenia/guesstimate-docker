# Base image, based on Ubuntu 21.10
FROM ubuntu:impish
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Warsaw

# Install git, nodejs and npm
RUN apt update && apt upgrade -y \
  && apt install -y build-essential vim nano npm nodejs git curl libpq-dev libssl-dev libreadline-dev zlib1g-dev locales locales-all \
  autoconf bison libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev postgresql-13 supervisor \
  && apt clean

# Download guesstimate-app from repo, then build and start it.
RUN update-locale en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN groupadd -g 200 guestimate
RUN useradd -d /home/guesstimate -m -u 200 -g 200 guesstimate

USER 200:200
WORKDIR /home/guesstimate
ENV HOME="/home/guesstimate"

RUN git clone https://github.com/getguesstimate/guesstimate-app/
RUN git clone https://github.com/getguesstimate/guesstimate-server/

## Now install depenedncies
## Backend rubby stuff
RUN git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
RUN mkdir -p $HOME/.rbenv/plugins
RUN git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
ENV PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
RUN cd guesstimate-server && rbenv install && bundler install

## Postgresql
COPY --chown=200:200 postgresql /home/guesstimate/postgresql
RUN $HOME/postgresql/init_pg.sh > $HOME/postgresql/init_pg.log

## Frontend app
RUN cd guesstimate-app && npm install --legacy-peer-deps yarn
ENV PATH="$HOME/guesstimate-app/node_modules/.bin:$PATH"

RUN cd guesstimate-app && npm install --legacy-peer-deps && yarn _copy_assets

# And final orchiestration
COPY supervisord.conf /home/guesstimate/supervisord.conf
CMD /usr/bin/supervisord
