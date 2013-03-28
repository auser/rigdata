require 'rubygems'
require 'red_storm'
require 'thread'

require 'redis'
require 'twitter4j4r'
require 'yaml'

require 'java'

module RigData
  class TwitterQueue
    attr_reader :queue

    def initialize
      @queue = Queue.new
      @config = RigData.config('twitter')
      @mutex = Mutex.new
      @client = Twitter4j4r::Client.new(@config[:twitter])
    end

    def pop
      @mutex.synchronize do
        @queue.pop if @queue.size > 0
      end
    end

    def new_topic(topic)
      @mutex.synchronize do
        shutdown
        @queue.clear
        run!(topic)
      end
    end

    def shutdown
      @client.stop
      @run_thread.exit
      @run_thread.terminate
    end

    def run!(name)
      @run_thread = Thread.new do
        Thread.current.abort_on_exception = true

        @client.track(name) do |tweet|
          theTweet = {body: tweet.text,
                       user:tweet.user.screen_name,
                       created_at: Time.at(tweet.created_at.getTime/1000),
                       geo: tweet.geo_location,
                       hashtags: tweet.hashtag_entities.to_a.map {|ht| ht.getText },
                       links: tweet.getURLEntities.to_a.map {|href| href.getDisplayUrl },
                       in_reply_to_user_id: tweet.in_reply_to_user_id,
                       is_retweet: tweet.is_retweet,
                       favorited: tweet.favorited,
                       id: tweet.id}
          if tweet.geo_location
            theTweet[:geo] = {:lat => tweet.geo_location.latitude, :long => tweet.geo_location.longitude}
          end
          @queue.push(theTweet)
        end
      end
    end
  end
  class TwitterSpout < RedStorm::SimpleSpout
    attr_reader :queue, :redis
    output_fields :tweet

    # Gets called when the Java spout `open` is called
    on_init do
      @queue = TwitterQueue.new
      @redis = Redis.new(RigData.config('redis'))

      @topic = @redis.get('rigdata.topic') || 'SF'
      RigData.log "Running with #{@topic}"

      @queue.run!(@topic)
    end

    # Is called when the Java spout `nextTuple` is called
    on_send do
      @queue.pop
    end

    on_close do
      @queue.shutdown
    end
  end
end

