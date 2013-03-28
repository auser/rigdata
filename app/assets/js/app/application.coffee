#dashboardApp = angular.module('dashboardApp', [
  #'dashboardApp.controllers'
  #'dashboardApp.directives'
  #'dashboardApp.services'
#])

if (!!window.EventSource)
  source = new EventSource('/subscribe')

  source.onmessage = (e) ->
    msg = JSON.parse(e.data)
    name = msg.eventName
    console.log(msg)

    if name == "retweetrate"
      console.log("rate", msg.rate)
      $("#retweet_rate").html("<h4>" + msg.words.rate + "</h4>")
    else if name == "word_rankings"
      list = $("<ul></ul>")
      $.each msg.words, (k,v) ->
        list.append("<li>" + k + " (" + v + ")</li>")
      $("#top_words").html(list)
    else
      console.log(name)

  source.addEventListener 'error', (e) ->
    if (e.readyState = EventSource.CLOSED)
      console.log("Closed...")

  console.log("Ready to go", source)
else
  alert("Uh oh")
