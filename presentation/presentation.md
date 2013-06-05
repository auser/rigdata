### Ruby and Big Data

<div id="author">Ari Lerner, <a href="http://fullstack.io">fullstack.io</a> <a href="http://twitter.com/auser">@auser</a></div>

!

## TOC

1. Ruby
2. Big Data
3. Demo

!

## Ruby

A beautifully expressive language written by Yukihiro Matsumoto (aka Matz)
that we all appreciate, _presumably why we are all here_

!

## Big Data


!

## What is it

!

<em>Buzzword</em>

!
### Hadoop

That's big data, right?

!

### Amazon EC2

That's big data, right?

!

![puppy](http://placepuppy.it/200/300)

!

The amount of data that is flowing through the `pipes` of the internet is
enormous. Spend a lot of time gathering data, storing it, retrieving it...
databases, etc. We are so inundated and intertwined with technology, that the
amount of data generated often goes untapped.

!

## My definition

`Big data` (v) is the act of extracting meaning from large amounts of data
that could not otherwise be found in small sample sets.

!

## Value

* Time (trends, abnormalities)
* How much (at what point will we have meaningful data)
* How to react (Netflix, banks, etc.)

!

## Why even bother?

!

* Recommendations
* Predictions
* Trends
* Save the planet

!

### Big Data implementations

* Map-Reduce, batched
* Realtime, streaming

!

### Batched

Run computations on large amounts of data. `Map-Reduce`
is the most popular examples of batched big data

### Batched steps

Steps:

1) Collect data
2) Do a bunch of things with that data
3) Repeat

!

### Streaming

Run computations on small amounts of data at a time.


Steps:

1) Collect data
2) Do a bunch of things with that data
3) Repeat

!

## Demo

`git clone git://github.com/auser/rigdata.git`

!

## Architecture

`git clone git://github.com/auser/rigdata.git`

* [Jruby](http://jruby.org/)
* [Storm](http://storm-project.net/)
* [Redis](http://redis.io/)

!

### JRuby

Java is the language of the data-scientist and the JVM has countless smart
brains making it fast and providing many many libraries

!

### Storm

A distributed realtime computation system written by Nathan Marz at Twitter
written in [Clojure](http://clojure.org/) (I also really like clojure -- and 
it plays really nice with us rubyist's desire for clean code)

!

### Redis

A lightning fast advanced key-value store (with both in-memory and persistent
data)

!

### Demo?

!

#### Realtime twitter firehose data-wrangler

!

### Incredibly quick 2-slide Storm overview

!

Topologies in Storm are like Map-Reduce jobs in Hadoop. Instead of scheduling
and processing large-scale datasets, it continuously processes them.

!

## Primitives

* `Spouts` emit data (can be any number of data sources, like twitter firehose, kestrel queue, redis, etc).
* `Bolts` process data and pass the data on

!

# Storm topology

![Topology](images/topology.png)

!

## Frontend

Our demo pulls tweets from the firehose and pumps them through our topology. At
the very end, the topology will store the processed message in Redis. The
front-end subscribes to the redis queue and reacts when the queue changes.

!

## Keyboard time

!

## Questions?

!

## The extra

All code is available at:

[github.com/auser/rigdata](https://github.com/auser/rigdata)

## Thanks

<a href="http://twitter.com/auser">@auser</a>
