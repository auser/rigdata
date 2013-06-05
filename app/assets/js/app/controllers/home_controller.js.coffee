app.controller "HomeController", ['$scope', '$http', 'eventSourceService', ($scope, $http, eventSourceService) ->

  $scope.isConnected = false;
  $scope.words = []
  $scope.hashtags = []
  $scope.rankings = []
  $scope.search = "sf"
      
  eventSourceService.onConnected -> 
    $scope.$apply -> $scope.isConnected = true
  eventSourceService.onDisconnected ->
    $scope.$apply -> $scope.isConnected = false

  eventSourceService.subscribe 'retweetrate', (msg) ->
    console.log("rate", msg.rate)
    
  eventSourceService.subscribe 'hashtag_rankings', (msg) ->
    new_words = []
    for word, rank of msg.words
      new_words.push {word: word, rank: parseInt(rank)}
      
    $scope.$apply ->
      $scope.hashtags = new_words
    
  eventSourceService.subscribe 'word_rankings', (msg) ->
    new_words = []
    for word, rank of msg.words
      new_words.push {word:word, rank: parseInt(rank)}
      
    new_words = new_words.sort (a,b) ->
      (a.rank < b.rank) ? -1 : ((a.rank > b.rank) ? 0 : 1)
            
    $scope.$apply ->
      $scope.words = new_words
      
  $scope.newTerm = () ->
    console.log "newTerm", $scope.search
    postData =
      'search': $scope.search
    $http({
      method: 'POST',
      url: '/search', 
      data: postData,
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
      })
    .success((data) ->
      console.log("updated")
    )
]
