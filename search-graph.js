var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;
    
    
var parseDate = d3.time.format("%Y-%m-%d").parse;
var x = d3.time.scale().range([0, width]);
var y = d3.scale.linear().range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");
    
var yAxis = d3.svg.axis()
	.scale(y)
	.orient("left");

var line = d3.svg.line()
    .x(function(d) { return x(d.date); })
    .y(function(d) { return y(d.count); });

var svg = d3.select("body").append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
var colors = {
	skorulis : "bluesteele",
	askoruli : "orange",
	"alex-skorulis" : "purple"
}; 
    
drawMainGraph();

function drawMainGraph() {
	d3.json("search-results.json", function(data) {
	
		var yExtant = [0,0]
		var xExtant = [parseDate("2015-12-25"),0]
	
		for (var key in data) {
			var counts = data[key]
			counts.forEach(function(d) {
				d.date = parseDate(d.date);
			});
			console.log(counts)
			tempY = d3.extent(counts, function(d) {return d.count;});
			tempX = d3.extent(counts, function(d) {return d.date;});
			yExtant[0] = Math.min(yExtant[0],tempY[0])
			yExtant[1] = Math.max(yExtant[1],tempY[1])
			
			xExtant[0] = Math.min(xExtant[0],tempX[0])
			xExtant[1] = Math.max(xExtant[1],tempX[1])
		}
		
		y.domain(yExtant)
		x.domain(xExtant)
		
		svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
			.call(xAxis);
	
		svg.append("g")
			.attr("class", "y axis")
			.call(yAxis)
		
		for (var key in data) {
			var color = colors[key]
			console.log(color)
		
			var counts = data[key]
			svg.append("path")
      .datum(counts)
      .attr("class", "line")
      .attr("d", line)
      .style({
      	stroke:color
      })
      
      svg.append("text")
			.attr("transform", "translate(" + (width-50) + "," + y(counts[counts.length-1].count) + ")")
			.attr("dy", ".35em")
			.attr("text-anchor", "start")
			.style("fill", color)
			.text(key);
		}
		
		
	});
}