require 'redis'
require 'json'

module RigData
  class RetweetBolt < RedStorm::SimpleBolt
    output_fields :tweet

    on_init do
      @redis = Redis.new(RigData.config('redis'))
    end

    on_receive do |tuple|
      tweet = tuple['tweet']
      total_count = tuple['total_count_per_minute']
      timestamp = tuple['timestamp']

      if tweet[:is_favorite]
        key = "rigdata.retweet_count.#{timestamp}"
        begin
          @incr = @redis.incr(key)
        rescue
          @redis.set(key, 1.0)
          @incr = 1.0
        end

        # Now set the rate
        rate = (@incr.to_f / total_count.to_f).to_f
        @redis.publish "rigdata.retweet_rate", {"rate"=>rate}.to_json
      end
    end
  end
end
