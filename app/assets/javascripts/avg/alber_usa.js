function albersUsa() {
  var lower48 = d3.geo.albers().rotate([96, 0]).center([0, 38]).parallels([29.5, 45.5]),
      alaska = d3.geo.albers().rotate([160, 0, -35]).center([45, 44]).parallels([55, 65]),
      hawaii = d3.geo.albers().rotate([160, 0]).center([0, 20]).parallels([8, 18]);

  function albersUsa(coordinates) {
    return projection(coordinates)(coordinates);
  }

  function projection(point) {
    var lon = point[0], lat = point[1];
    return lat > 50 ? alaska : lon < -140 ? hawaii : lower48;
  }

  albersUsa.point = function(coordinates, context) {
    return projection(coordinates).point(coordinates, context);
  };

  albersUsa.line = function(coordinates, context) {
    return projection(coordinates[0]).line(coordinates, context);
  };

  albersUsa.polygon = function(coordinates, context) {
    return projection(coordinates[0][0]).polygon(coordinates, context);
  };

  albersUsa.scale = function(x) {
    if (!arguments.length) return lower48.scale();
    lower48.scale(x);
    alaska.scale(x * .35);
    hawaii.scale(x);
    return albersUsa.translate(lower48.translate());
  };

  albersUsa.translate = function(x) {
    var k = lower48.scale();
    if (!arguments.length) {
      x = lower48.translate();
      return [x[0] - .007 * k, x[1] - .007 * k];
    }
    lower48.translate([x[0] + .0075 * k, x[1] + .0065 * k]);
    alaska.translate([x[0] - .307 * k, x[1] + .187 * k]);
    hawaii.translate([x[0] - .206 * k, x[1] + .196 * k]);
    return albersUsa;
  };

  return albersUsa.scale(1056).translate([400, 250]);
}
