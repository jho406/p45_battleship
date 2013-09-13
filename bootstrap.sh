#!/bin/bash
apt-get update --fix-missing

apt-get -y install curl postgresql libpq-dev libxml2-dev libxslt-dev nodejs

curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3

source ~/.profile;
source /usr/local/rvm/scripts/rvm;
rvm reload
rvm use 1.9.3 --default
cd /vagrant
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rails s