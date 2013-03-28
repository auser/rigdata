module RigData
  class BlankBolt < RedStorm::SimpleBolt

    on_init do
      @redis = Redis.new(RigData.config('redis'))
    end

    on_receive do |tuple|
    end

    on_close do
    end

  end
end
