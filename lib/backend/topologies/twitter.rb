require 'red_storm'
require 'rig_data'

module RigData
  class TwitterTopology < RedStorm::SimpleTopology

    ## Create a spout from twitter
    ## This is where all the data comes from
    spout RigData::TwitterSpout

    ## First path
    #
    ## We are counting every tweet we come across
    # and passing it on
    bolt RigData::CountTweetBolt do
      source RigData::TwitterSpout, :shuffle
    end

    ## Calculate Retweet Rate
    bolt RigData::RetweetBolt do
      source RigData::CountTweetBolt, :shuffle
    end

    ## Calculate Recommendations
    bolt RigData::WordSplitBolt do
      source RigData::TwitterSpout, :shuffle
    end

    bolt RigData::WordKeepBolt do
      source RigData::WordSplitBolt, :fields => ["word"]
    end

    bolt RigData::WordSumBolt do
      source RigData::WordKeepBolt, :fields => ["word"]
    end
    
    bolt RigData::HashtagBolt do
      source RigData::WordKeepBolt, :fields => ["word"]
    end
    
    bolt RigData::HashtagSumBolt do
      source RigData::HashtagBolt, :fields => ["word"]
    end

    bolt RigData::WordsRankingBolt do
      source RigData::WordSumBolt, :global
    end
    
    bolt RigData::HashtagRankingBolt do
      source RigData::HashtagSumBolt, :global
    end

    configure do |env|
      debug false
      case env
      when :local
        max_task_parallelism 20
      end
    end

  end
end
