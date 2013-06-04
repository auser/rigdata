require "rubygems"
require "bundler"
require "yaml"
require 'zurb-foundation'
require 'sinatra/asset_pipeline'

# require "bundle gems"
ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

class App < Sinatra::Base
  # init sinatra
  set :sessions, true
  set :session_secret, "889aa0f75ea09f3682bbe5f23325c3f1"
  set :root, File.expand_path(".")
  set :views, settings.root + "/app/views"

  set :assets_precompile, %w(*.js *.css *.html *.png *.jpg *.ttf)

  register Sinatra::AssetPipeline
  set :assets_prefix, '/assets'
  set :assets_digest, true
  set :assets_js_compressor, :uglifier
  sprockets.append_path File.join(root, 'app', 'assets', 'css')
  sprockets.append_path File.join(root, 'app', 'assets', 'js')
  sprockets.append_path File.join(root, 'app', 'assets', 'img')
  sprockets.append_path File.join(root, 'app', 'assets', 'templates')

  # sinatra reloader
  configure :development do
  require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload "app/{controllers,models,helpers}/**/*.rb"
  end
end

# require project files
Dir.glob "./app/initializers/*.rb" do |f|
  require f
end
require "app/initializers/config/#{ENV["RACK_ENV"]}"

Dir.glob "./{app/models,app/helpers,app/controllers}/**/*.rb" do |f|
  require f
end
