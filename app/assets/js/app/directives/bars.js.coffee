@app.directive "fsBar", ['$rootScope', ($rootScope) ->
  restrict: 'E'
  scope:
    width: '='
    height: '='
    data: '='
    color: '='
    
  link: (scope, element, attrs) ->
    margin =
      top: 10
      right: 10
      bottom: 10
      left: 10
    
    width = scope.width || 400
    height = scope.height || 300
    
    width = width - margin.left - margin.right
    height = height - margin.top - margin.bottom
    
    klass = attrs.class || ''
    
    # D3
    x = d3.scale.linear()
        .range([0, width])
        
    y = d3.scale.ordinal()
        .rangeBands([0, height], .1)
        
    svg = d3.select(element[0])
          .append('svg')
          .attr('viewBox', '0 0 ' + (width + margin.left + margin.right) + ' ' + (height + margin.top + margin.bottom))
          .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
            
    scope.$watch 'data', (data) ->
      duration = scope.duration || 10
      delay = scope.delay || 10
      
      if data
        x.domain([0, d3.max(data, (d) -> d.rank) * 2])
        y.domain(data.map (d) -> d.rank)
        
        bars = svg.selectAll('rect')
                .data(data, (d) -> d.rank)
                
        bars.enter()
            .append('rect')
              .attr('class', 'bar rect ' + klass)
              .attr('cursor', 'pointer')
              .attr('y', (d) -> y(d.rank))
              .attr('height', y.rangeBand())
              .attr('x', (d) -> 0)
            .transition()
              .duration(duration)
              .attr('width', (d) -> width - x(d.rank))
              .attr('x', (d) -> 0)
                  
        bars.on 'mousedown', (d) ->
          scope.$apply ->
            (scope.onClick || angular.noop)(d.word)
        
        bars.exit().remove()
        
        labels = svg.selectAll("text")
            .data(data, (d) -> d.word )
            
        labels.enter()
              .append('text')
                .attr('class', 'bar text' + klass)
                .attr('cursor', 'pointer')
                .attr('x', (d) -> x(d.rank) + 3)
                .attr('y', (d) -> y(d.rank) + y.rangeBand() / 2)
                .attr('dy', '.35em')
                .attr('text-anchor', (d) -> 'start')
                .attr('fill', '#FFF')
                .text((d) -> d.word + "(" + d.rank + ")")
                
        labels.on 'mousedown', (d) ->
          scope.$apply ->
            (scope.onClick || angular.noop)(d.word)
            
        labels.exit().remove()
  ]