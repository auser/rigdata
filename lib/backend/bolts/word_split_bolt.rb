module RigData
  class WordSplitBolt < RedStorm::SimpleBolt
    output_fields :word

    on_init do
      @redis = Redis.new(RigData.config('redis'))
    end

    on_receive do |tuple|
      tweet = tuple['tweet']
      tweet[:body].split(" ").map {|w| [w.downcase] }
    end

    on_close do
    end

  end
end

