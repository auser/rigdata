app.factory "eventSourceService", ["$q", '$rootScope', "$location", ($q, $rootScope, $location) ->
  connected = false
  subscribers = {}
  
  source = new EventSource('/subscribe')
  
  source.onmessage = (e) ->
    msg = JSON.parse(e.data)
    name = msg.eventName
    callback(name, msg)

  source.onopen = () ->
    connected = true
    callback('on_connect', connected)
  source.onerror = () ->
    connected = false
    callback('on_close', connected)
      
  callback = (name, msg) ->
    cb(msg) for cb in subscribers[name] if subscribers[name]

    # if name == "retweetrate"
    #   console.log("rate", msg.rate)
    #   $("#retweet_rate").html("<h4>" + msg.words.rate + "</h4>")
    # else if name == "word_rankings"
    #   list = $("<ul></ul>")
    #   $.each msg.words, (k,v) ->
    #     list.append("<li>" + k + " (" + v + ")</li>")
    #   $("#top_words").html(list)
    # else
    #   console.log(name)

  source.addEventListener 'error', (e) ->
    console.error e
    if (e.readyState = EventSource.CLOSED)
      console.log("Closed...")

  {
    onConnected: (f) -> this.subscribe('on_connected', f)
    onDisconnected: (f) -> this.subscribe('on_disconnected', f)

    subscribe: (event, cb) ->
      if !subscribers[event] 
        subscribers[event] = []
      subscribers[event].push cb
  }]