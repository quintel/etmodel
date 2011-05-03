Raphael.fn.connection = function (obj1, obj2, line, bg) {
  // call connection(line) to update link
  if (obj1.line && obj1.from && obj1.to) {
    line = obj1;
    obj1 = line.from;
    obj2 = line.to;
  }
  var bb1 = obj1.getBBox();
  var bb2 = obj2.getBBox();
  var p = [
    {x: bb1.x + bb1.width / 2, y: bb1.y - 1},
    {x: bb1.x + bb1.width / 2, y: bb1.y + bb1.height + 1},
    {x: bb1.x - 1, y: bb1.y + bb1.height / 2},
    {x: bb1.x + bb1.width + 1, y: bb1.y + bb1.height / 2},
    {x: bb2.x + bb2.width / 2, y: bb2.y - 1},
    {x: bb2.x + bb2.width / 2, y: bb2.y + bb2.height + 1},
    {x: bb2.x - 1, y: bb2.y + bb2.height / 2},
    {x: bb2.x + bb2.width + 1, y: bb2.y + bb2.height / 2}
  ];

  var d = {};
  var dis = [];
  
  for (var i = 0; i < 4; i++) {
    for (var j = 4; j < 8; j++) {
      var dx = Math.abs(p[i].x - p[j].x);
      var dy = Math.abs(p[i].y - p[j].y);
      if ((i == j - 4) || (((i != 3 && j != 6) || p[i].x < p[j].x) && ((i != 2 && j != 7) || p[i].x > p[j].x) && ((i != 0 && j != 5) || p[i].y > p[j].y) && ((i != 1 && j != 4) || p[i].y < p[j].y))) {
        dis.push(dx + dy);
        d[dis[dis.length - 1]] = [i, j];
      }
    }
  }
  
  if (dis.length == 0) {
    var res = [0, 4];
  } else {
    res = d[Math.min.apply(Math, dis)];
  }
  
  var x1 = p[res[0]].x;
  var y1 = p[res[0]].y;
  var x4 = p[res[1]].x;
  var y4 = p[res[1]].y;

  dx = Math.max(Math.abs(x1 - x4) / 2, 10);
  dy = Math.max(Math.abs(y1 - y4) / 2, 10);

  var x2 = [x1, x1, x1 - dx, x1 + dx][res[0]].toFixed(3);
  var y2 = [y1 - dy, y1 + dy, y1, y1][res[0]].toFixed(3);
  var x3 = [0, 0, 0, 0, x4, x4, x4 - dx, x4 + dx][res[1]].toFixed(3);
  var y3 = [0, 0, 0, 0, y1 + dy, y1 - dy, y4, y4][res[1]].toFixed(3);
  var path = ["M", x1.toFixed(3), y1.toFixed(3), "C", x2, y2, x3, y3, x4.toFixed(3), y4.toFixed(3)].join(",");

  if (line && line.line) {
    line.bg && line.bg.attr({path: path});
    line.line.attr({path: path});
  } else {
    var color = typeof line == "string" ? line : "#000";
    return {
//      bg: bg && bg.split && this.path(path).attr({stroke: bg.split("|")[0], fill: "none", "stroke-width": bg.split("|")[1] || 3}),
//      line: this.path(path).attr({stroke: color, fill: "none", "stroke-dasharray" : bg.split("|")[2]}),
        bg: bg && bg.split && this.path(path).attr({stroke: bg.split("|")[0], fill: "none", "stroke-width": bg.split("|")[1] || 3}),
        line: this.path(path).attr({stroke: color, fill: "none", "stroke-linecap" : 'butt'}),
        from: obj1,
        to: obj2
    };
  }
};








/*
 * raphael.zoom 0.0.4
 *
 * Copyright (c) 2010 Wout Fierens - http://boysabroad.com
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
 */

// get all elements in the paper
Raphael.fn.elements = function() {
  var b = this.bottom,
      r = []; 
  while (b) { 
    r.push(b); 
    b = b.next; 
  }
  return r;
}

// initialize zoom of paper
Raphael.fn.initZoom = function(zoom) {
  var elements = this.elements();
  this.zoom = zoom || 1;
  
  for (var i = 0; i < elements.length; i++) {
    elements[i].initZoom();
  }
  
  return this;
}

// set the zoom of all elements
Raphael.fn.setZoom = function(zoom) {
  if (!zoom) return;
  
  var elements = this.elements();
  if (!this.zoom)
    this.initZoom();
  
  for (var i = 0; i < elements.length; i++) {
    elements[i].setZoom(zoom);
  }
  this.zoom = zoom;
  
  return this;
}

// initialize zoom of element
Raphael.el.initZoom = function(zoom) {
  var sw = parseFloat(this.attr("stroke-width")) || 0;
  zoom = zoom || this.paper.zoom;
  
  if (this.type != "text") sw /= zoom;
  this.zoom = zoom;
  this.zoom_memory = {
    "stroke-width": sw,
    rotation:       360
  };
  
  this.setStrokeWidth(sw / zoom);
  
  if (this.type == "text") {
    var fs = parseFloat(this.attr("font-size")) || 0
    this.zoom_memory["font-size"] = fs;
    this.zoom_memory["x"] = (parseFloat(this.attrs["x"]) || 0) / zoom;
    this.zoom_memory["y"] = (parseFloat(this.attrs["y"]) || 0) / zoom;
  }
  return this;
}

// zoom element preserving some original values
Raphael.el.setZoom = function(zoom) {
  if (!zoom) return;
  if (!this.zoom_memory)
    this.initZoom();
  
  // scale to zoom
  var new_zoom = zoom / this.zoom;
  this.scale(new_zoom, new_zoom, 0, 0);
  this.applyScale();
  
  // save new zoom
  this.zoom = zoom;
  this.setStrokeWidth(this.zoom_memory["stroke-width"]);
  
  if (this.type == "text")
    this.attr({
      "font-size":  this.zoom_memory["font-size"] * zoom,
      "x":          this.zoom_memory["x"] * zoom,
      "y":          this.zoom_memory["y"] * zoom
    });
  
  return this;
}

// set element zoomed attributes
Raphael.el.setAttr = function() {
  if (typeof arguments[0] == "string") {
    attr = {};
    attr[arguments[0]] = arguments[1];
  } else {
    attr = arguments[0];
  }
  
  for (var key in attr) {
    switch(key) {
      case "stroke-width":
        this.setStrokeWidth(attr[key]);
      break;
      case "font-size":
        this.setFontSize(attr[key]);
      break;
      case "x":
      case "y":
        if (this.type == "text")
          this.zoom_memory[key] = attr[key] / this.zoom;
        this.attr(key, attr[key]);
      break;
      default:
        this.attr(key, attr[key]);
      break;
    }
  }
  return this;
}

// set element translation
Raphael.el.setTranslation = function(x, y) {
  if (this.type == "text")
    this.setAttr({
      x: this.attrs["x"] + x,
      y: this.attrs["y"] + y
    });
  else
    this.translate(x,y);
  
  return this;
}

// set element rotation
Raphael.el.setRotation = function(angle, x, y) {
  if (!this.zoom_memory) this.initZoom();
  if (angle == 0)
    angle = 360;
  this.rotate(angle, x, y);
  this.zoom_memory.rotation = angle;
  this.transformations = [];
  this._.rt = { cx: null, cy: undefined, deg: 360 };
  
  return this;
}

// set element zoomed stroke width
Raphael.el.setStrokeWidth = function(value) {
  if (value == 0 || (value = parseFloat(value))) {
    this.attr({ "stroke-width": value * this.zoom });
    this.zoom_memory["stroke-width"] = value;
  }
  
  return this;
}

// set element font size
Raphael.el.setFontSize = function(value) {
  if (value == 0 || (value = parseFloat(value))) {
    this.attr({ "font-size": value * this.zoom });
    this.zoom_memory["font-size"] = value;
  }
  
  return this;
}

// apply the current scale and reset it to 1
Raphael.el.applyScale = function() {
  this._.sx = 1;
  this._.sy = 1;
  this.scale(1, 1);
  
  return this;
}

