require 'red_storm'
require 'rig_data'

module RigData
  class TwitterTopology < RedStorm::SimpleTopology

    ## Create a spout from twitter
    spout RigData::TwitterSpout

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

    bolt RigData::WordsRankingBolt do
      source RigData::WordSumBolt, :global
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
