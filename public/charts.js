function showAnswer(target, answer, scale) {
    var w = 175 * scale, //width
        h = 175 * scale; //height

    var vis = d3.select(target);

    vis.selectAll("#chart")
        .append("text")
        .text(answer + "%")
        .attr("x", -w)
        .attr("y", -h + 12);
}

function drawChart(target, innerRadius, data, rotate, scale) //types: "baselinePie", "baselineDonut", "anglePie", "angleDonut", "arc"
{
    var w = 354 * scale, //width
        h = 354 * scale, //height
        outer = 155 * scale, //radius
        pad = 2 * scale, //svg padding
        donutR = 75 * scale, //radius for donut
        dotSize = 8 * scale, //radius for red dot
        dotOrbit = 170 * scale, //radius for red dot placement
        lineWeight = 3 * scale, //lineweight
        radialLineWeight = 2 * scale,
        sliceLineWeight = 5 * scale,
        maskLineWeight = 13 * scale,
        blue = "#1f78b4",
        gray = "#dddddd",
        darkGray = "#888888";

    var vis = d3.select(target)
        .data([data])
        .attr("width", w + 2 * pad)
        .attr("height", h + 2 * pad)
        .append("g")
        .attr("transform", "translate(" + (w / 2 + pad) + "," + (h / 2 + pad) + ")")
        .attr("id", "chart");

    var pieData = d3.layout.pie()
        .value(function(d) {
            return d.value;
        });

    var background = vis.append("rect")
        .attr("width", 2 * w / 2 + pad)
        .attr("height", 2 * h / 2 + pad)
        .attr("fill", "#ffffff")
        .attr("transform", "translate(" + (-w / 2 - pad) + "," + (-h / 2 - pad) + ")");

    // -------------------------- Draw Chart --------------------------
    var arc = d3.svg.arc()
        .innerRadius(innerRadius)
        .outerRadius(outer);

    var arcs = vis.selectAll("g.slice")
        .data(pieData)
        .enter()
        .append("g")
        .attr("class", "slice")
        .attr("transform", "rotate(" + rotate + ")");

    arcs.append("path")
        .attr("d", arc)
    // .attr("stroke", "#777777")
    // .attr("stroke-width", lineWeight)
    .attr("fill", function(d) {
        if (d.data.focus)
            return blue;
        else
            return gray;
    });
}

function makeData(count, dataOptions) {
    var data = [{
        "focus": true,
        "value": dataOptions[count]
    }, {
        "focus": false,
        "value": 100 - dataOptions[count]
    }]

    return data;
}