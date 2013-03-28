require "sinatra/reloader" if development?

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    enable :logging
  end
end
