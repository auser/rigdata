d3.custom = {}
d3.custom.barChart = module = ->
  exports = (_selection) ->
    _selection.each (_data) ->
      chartW = width - margin.left - margin.right
      chartH = height - margin.top - margin.bottom
      x1 = d3.scale.ordinal().domain(_data.map((d, i) ->
        i
      )).rangeRoundBands([0, chartW], .1)
      y1 = d3.scale.linear().domain([0, d3.max(_data, (d, i) ->
        d
      )]).range([chartH, 0])
      xAxis = d3.svg.axis().scale(x1).orient("bottom")
      yAxis = d3.svg.axis().scale(y1).orient("left")
      barW = chartW / _data.length
      unless svg
        svg = d3.select(this).append("svg").classed("chart", true)
        container = svg.append("g").classed("container-group", true)
        container.append("g").classed "chart-group", true
        container.append("g").classed "x-axis-group axis", true
        container.append("g").classed "y-axis-group axis", true
      svg.transition().duration(duration).attr
        width: width
        height: height

      svg.select(".container-group").attr transform: "translate(" + margin.left + "," + margin.top + ")"
      svg.select(".x-axis-group.axis").transition().duration(duration).ease(ease).attr(transform: "translate(0," + (chartH) + ")").call xAxis
      svg.select(".y-axis-group.axis").transition().duration(duration).ease(ease).call yAxis
      gapSize = x1.rangeBand() / 100 * gap
      barW = x1.rangeBand() - gapSize
      bars = svg.select(".chart-group").selectAll(".bar").data(_data)
      bars.enter().append("rect").classed("bar", true).attr(
        x: chartW
        width: barW
        y: (d, i) ->
          y1 d

        height: (d, i) ->
          chartH - y1(d)
      ).on "mouseover", dispatch.customHover
      bars.transition().duration(duration).ease(ease).attr
        width: barW
        x: (d, i) ->
          x1(i) + gapSize / 2

        y: (d, i) ->
          y1 d

        height: (d, i) ->
          chartH - y1(d)

      bars.exit().transition().style(opacity: 0).remove()
      duration = 500

  margin =
    top: 20
    right: 20
    bottom: 40
    left: 40

  width = 500
  height = 500
  gap = 0
  ease = "cubic-in-out"
  svg = undefined
  duration = 500
  dispatch = d3.dispatch("customHover")
  exports.width = (_x) ->
    return width  unless arguments_.length
    width = parseInt(_x)
    this

  exports.height = (_x) ->
    return height  unless arguments_.length
    height = parseInt(_x)
    duration = 0
    this

  exports.gap = (_x) ->
    return gap  unless arguments_.length
    gap = _x
    this

  exports.ease = (_x) ->
    return ease  unless arguments_.length
    ease = _x
    this

  d3.rebind exports, dispatch, "on"
  exports