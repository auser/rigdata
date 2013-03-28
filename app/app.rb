$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'json'
require 'sinatra/base'
require "sinatra/streaming"
require 'haml'
require 'redis'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  helpers Sinatra::Streaming
  helpers do
    def connections
      @connections ||= []
    end
  end

  get '/subscribe' do
    headers "Content-Type" => "text/event-stream", "Cache-Control" => "no-cache"
    stream do |out|
      redis.psubscribe('rigdata.*') do |on|
        on.psubscribe do |evt, total|
          puts "Subscribed to ##{evt} (#{total} subscriptions)"
        end
        on.pmessage do |pattern, evt, msg|
          out << "data: {"
          out << "\"eventName\": \"#{evt.split(".")[-1]}\", "
          out << "\"words\": {"
          out << JSON.parse(msg).map {|k,v| "\"#{k}\":\"#{v}\"" }.join(", ")
          out << "}"
          out << "}\n\n"
        end
        on.punsubscribe do |evt,total|
          puts "Unsubscribed #{evt} (#{total} subscriptions)"
        end
      end
    end
  end
end

## Require inits
require "app/initializers/assets"
require "app/initializers/redis"
require "app/initializers/config/#{ENV["RACK_ENV"]}"

Dir["#{File.dirname(__FILE__)}/routes/**/*.rb"].each {|f| require f }


