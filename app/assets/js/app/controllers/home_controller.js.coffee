app.controller "HomeController", ['$scope', '$http', 'eventSourceService', ($scope, $http, eventSourceService) ->

  $scope.isConnected = false;
  $scope.words = []
  $scope.rankings = []
      
  eventSourceService.onConnected -> 
    console.log "CONNECTED"
    $scope.$apply -> $scope.isConnected = true
  eventSourceService.onDisconnected ->
    $scope.$apply -> $scope.isConnected = false

  eventSourceService.subscribe 'retweetrate', (msg) ->
    console.log("rate", msg.rate)
    
  eventSourceService.subscribe 'word_rankings', (msg) ->
    new_words = []
    for word, rank of msg.words
      new_words.push {word:word, rank: rank}
      
    new_words = new_words.sort (a,b) ->
      (a.rank < b.rank) ? -1 : ((a.rank > b.rank) ? 0 : 1)
      
    new_words = new_words.slice(0,14)
      
    $scope.$apply ->
      $scope.words = new_words
]
