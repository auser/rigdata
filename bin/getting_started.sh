#!/bin/bash -ex

jruby -S bundle install
jruby -S bundle exec redstorm install
jruby -S bundle exec redstorm bundle
