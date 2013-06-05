@app.directive "fsBar", ['$rootScope', ($rootScope) ->
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
    
    index = d3.range(attrs.range || 14)
    klass = attrs.class || ''
    
    # D3
    x = d3.scale.linear()
        .range([1, width])
        
    y = d3.scale.ordinal()
        .rangeBands([0, height], .1)
        
    color = d3.scale.linear()
        .domain([0, width])
        .range(["green", "yellow", "red"])
        
    textcolor = d3.scale.linear()
        .domain([0, width])
        .range(["white", "black", "white"])
        
    svg = d3.select(element[0])
          .append('svg')
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
            
    scope.$watch 'data', (data) ->      
      index = d3.range(data.length)
      
      duration = parseInt(attrs.duration) || 0
      delay = parseInt(attrs.delay) || 0
      
      if data
        ranks = []
        for word in data
          ranks.push parseInt(word.rank)
        
        # console.log data, d3.max(data, (d) -> d.rank)
        x.domain([0, d3.max(ranks)])
        y.domain(d3.range(data.length))
        color.domain([d3.min(ranks), d3.mean(ranks), d3.max(ranks)])
        textcolor.domain([d3.min(ranks), d3.mean(ranks), d3.max(ranks)])
        
        index.sort (a, b) -> data[a].rank - data[b].rank
        
        bars = svg.selectAll('.bar')
              .data(data)
        bars.enter()
            .append('g')
              .attr('class', 'bar')
              .attr("transform", (d, i) -> "translate(0," + y(i) + ")")
        bars.append('rect')
                .attr('cursor', 'pointer')
                .attr('height', y.rangeBand())
                .attr("width", (d) -> x(d.rank))
                .style('fill', (d) -> color(d.rank))
        bars.append('text')
                .attr('text-anchor', 'end')
                .attr('x', (d, i) -> x(d.rank) - 6)
                .attr('y', (d) -> y.rangeBand() / 2)
                .attr('dy', '.35em')
                .style('fill', (d) -> textcolor(d.rank))
                .text((d) -> d.word + " (" + d.rank + ")")
                
        y.domain(index)
        bars.transition()
              .duration(duration)
              .delay((d, i) -> delay)
              .ease('linear')
              .attr('width', (d,i) -> x(d.rank))
              .attr('transform', (d,i) -> 'translate(0,' + y(i) + ')')
        
        bars.exit().remove()
  ]