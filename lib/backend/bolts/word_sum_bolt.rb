module RigData
  class WordSumBolt < RedStorm::SimpleBolt
    output_fields :word, :count

    on_init do
      @redis = Redis.new(RigData.config('redis'))
    end

    on_receive do |tuple|
      word = tuple['word']
      key = "rigdata.word_count.#{word}"
      count = @redis.incr key
      [word, count]
    end

    on_close do
    end

  end
end

