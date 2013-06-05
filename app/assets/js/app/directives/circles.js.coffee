@app.directive "fsCircle", ['$rootScope', ($rootScope) ->
  restrict: 'E'
  scope:
    width: '='
    height: '='
    data: '='
    color: '='
    
  link: (scope, element, attrs) ->
    margin =
      top: 0
      right: 10
      bottom: 20
      left: 10
    
    width = scope.width || 400
    height = scope.height || 300
    width = width - margin.left - margin.right
    height = height - margin.top - margin.bottom
    
    diameter = scope.diameter || width
    format = d3.format(",d")
    color = d3.scale.category20c()
    
    
    # D3
    x = d3.scale.linear()
        .range([0, width])
        
    y = d3.scale.ordinal()
        .rangeBands([0, height], .1)
    
    bubble = d3.layout.pack()
              .sort(null)
              .size([width, height])
              .padding(1.5)
              
    svg = d3.select(element[0])
          .append('svg')
          .attr("width", diameter)
          .attr("height", diameter)
          .attr('class', 'bubble')

    scope.$watch 'data', (data) ->
      index = d3.range(data.length)
      
      duration = scope.duration || 0
      delay = scope.delay || 0
      
      if data && data.length > 0
        bubbleData = []
        for d in data
          bubbleData.push({name: d.word, value: d.rank})
        
        bubbleData = {children: bubbleData}
        node = svg.selectAll('.node')
              .data(bubble.nodes(bubbleData))
              .enter().append('g')
                .attr('class', 'node')
                  .attr('transform', (d) -> 'translate('+d.x+','+d.y+')')
        
        node.append('circle')
            .attr('r', (d) -> d.r)
            .style("fill", (d) -> color(d.r))
            
        node.append('title')
            .text (d) -> d.word
            
        node.append('text')
            .attr('text-anchor', 'middle')
            .attr('dy', '.35em')
            .text((d) -> d.word)
            .style("fill", (d) -> "black")
                  
  ]