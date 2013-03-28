### Ruby and Big Data

<div id="author">Ari Lerner, <a href="http://fullstack.io">fullstack.io</a></div>

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

<small>This one is not as easy</small>

!

## What is it

!

* Buzzword

!

The amount of data that is flowing through the `pipes` of the internet is
enormous. Spend a lot of time gathering data, storing it, retrieving it...
databases, etc.

!

## My definition

`Big data` is about creating experiences that allow us to make sense of all of
it

!

### Big Data implementation

* Map-Reduce, batched
* Realtime, streaming

!

## Making sense of it

* Aggregates
* Counts
* Comparisons
* Relational
* Relevance

!

## Making sense of it

* When?
* At what scale?
* How much do we need?
* Why even bother?

!

## Why even bother?

!

* Recommendations
* Predictions
* Filtering
* Save the planet

!

## Business case

!

* Create `sticky` experiences for customers through recommendations
* Create systems to provide high-level view of your infrastructure
* Generate data-driven business models
* ...

!

### Enough of the pie-in-the-sky

!

## Demo

!

## Architecture

* [Jruby](http://jruby.org/)
* [Storm](http://storm-project.net/)
* [Redis](http://redis.io/)
* [jQuery](http://jQuery.com/)

!

### JRuby

Java is the language of the data-scientist and the JVM has countless smart
brains making it fast and providing many many libraries

!

### Storm

A distributed realtime computation system written by Nathan Marz at Twitter
written in [Clojure](http://clojure.org/) (I also really like clojure)

!

### Redis

A lightning-fase advanced key-value store (with both in-memory and persistent
data)

!

### jQuery

A client-side javascript library written by [Google](http://google.com).

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

* `Streams` emit data (can be any number of data sources, like twitter firehose, kestrel queue, redis, etc).
* `Bolts` process data and pass the data on

!

# Storm topology

![Topology](images/topology.png)

!

# Demo topology

![DemoTopology](images/demo_topology.png)

!

## Frontend

Our demo pulls tweets from the firehose and pumps them through our topology. At
the very end, the topology will store the processed message in Redis. The
front-end subscribes to the redis queue and reacts when the queue changes.

!

## Screenshots

!

![Backend](images/terminal.png)

!

![Frontend](images/frontend.png)

!

## Keyboard time