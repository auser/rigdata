class App < Sinatra::Base

  helpers do
    def redis
      return @redis if @redis
      config = YAML.load_file(File.expand_path("../../../config/redis.yml", __FILE__))
      redis_url = ENV["REDISTOGO_URL"] || config["redis_uri"]
      uri = URI.parse(redis_url)

      @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end
  end

end
