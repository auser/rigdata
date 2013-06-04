require "sinatra/streaming"

class App < Sinatra::Base
  helpers Sinatra::Streaming
  helpers do
    def connections
      @connections ||= []
    end
  end
end
