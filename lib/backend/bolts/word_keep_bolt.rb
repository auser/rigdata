require 'json'

module RigData
  class WordKeepBolt < RedStorm::SimpleBolt
    output_fields :word, :count

    on_init do
      @redis = Redis.new(RigData.config('redis'))
      @topic = @redis.get('rigdata.topic') || 'SF'
      @uninteresting_words = %w(
        in I RT the you when are was from they like get have this and for the time
      )
    end

    on_receive do |tuple|
      word, count = tuple['word'], tuple['count']

      if word.length > 2 && !word.index(@topic) && !@uninteresting_words.include?(word)
        [word, count]
      end
    end

    on_close do
    end

  end
end

