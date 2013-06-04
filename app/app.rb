$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'json'
require 'sinatra/base'
require 'sinatra/namespace'
require "sinatra/streaming"
require 'haml'
require 'redis'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
end

## Require inits
require "app/initializers/assets"
require "app/initializers/redis"
require "app/initializers/config/#{ENV["RACK_ENV"]}"

Dir["#{File.dirname(__FILE__)}/routes/**/*.rb"].each {|f| require f }


