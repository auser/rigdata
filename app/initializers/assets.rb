require 'sinatra/assetpack'
require 'coffee_script'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/css',     from: 'assets/css'
    serve '/images',  from: 'assets/img'
    serve '/js',      from: 'assets/js'

    js :application, '/js/app.js', [
      '/js/vendor/*.js',
      '/js/app/services/*.js',
      '/js/app/directives/*.js',
      '/js/app/controllers/*.js',
      '/js/app/application.js'
    ]

    css :application, '/css/application.css', [
      '/css/normalize.css',
      '/css/foundation.min.css',
      '/css/screen.css'
    ]

    js_compression  :jsmin
    css_compression :sass
  }
end
