require 'json'

module RigData
  class WordsRankingBolt < RedStorm::SimpleBolt
    output_fields :rankings

    on_init do
      @redis = Redis.new(RigData.config('redis'))
      @ranks = {}
      @keep = 20
    end

    on_receive do |tuple|
      word, count = tuple['word'], tuple['count']
      @ranks[word] ||= 0
      @ranks[word] += count
      sorted = @ranks.sort {|a,b| b[1] <=> a[1] }
      while sorted.size > @keep
        @ranks.delete(sorted.pop[0])
      end

      json = sorted.to_json
      key = "rigdata.word_rankings"
      @redis.publish key, json
      {"words" => [json]}.to_json
    end

    on_close do
    end

  end
end


