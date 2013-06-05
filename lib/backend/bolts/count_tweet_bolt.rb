module RigData
  class CountTweetBolt < RedStorm::SimpleBolt
    output_fields :tweet, :total_count_per_minute, :timestamp

    on_init do
      @redis = Redis.new(RigData.config('redis'))
    end

    on_receive do |tuple|
      p [:count, tuple]
      timestamp = Time.now.strftime("%m-%d-%y.%M")
      key = "rigdata.#{timestamp}"
      count = @redis.incr key
      [tuple['tweet'], count, timestamp]
    end

    on_close do
    end

  end
end

