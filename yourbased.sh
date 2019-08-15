#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive
export CI=true
export TRAVIS=true
export CONTINUOUS_INTEGRATION=true
export USER=travis
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RAILS_ENV=test
export RACK_ENV=test
export MERB_ENV=test
export JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"

apt-get update && apt-get install -y tzdata unzip
gem install bundler -v 2.0.1
# before_install
# mysql -u root -e "GRANT ALL ON *.* TO 'travis'@'%';"
wget -N https://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip -P ~/
unzip ~/chromedriver_linux64.zip -d ~/
rm ~/chromedriver_linux64.zip
mv -f ~/chromedriver /usr/local/share/
chmod +x /usr/local/share/chromedriver
ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
# install
bundle install --jobs=3 --retry=3
# script
bundle exec rake test_app
bundle exec rake spec
