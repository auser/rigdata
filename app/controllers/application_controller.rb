require 'json'
require 'redis'
require 'sinatra/base'
require "sinatra/streaming"

class App < Sinatra::Base
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
  
  get '/' do
    erb :index
  end
end
