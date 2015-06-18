#!/bin/bash -xv
pwd


cd tmp/*dummy
export BUNDLE_GEMFILE=$PWD/Gemfile
bundle install --without system_tests development

# Not running metadata checks as module generate uses invalid license string
bundle exec rake test
