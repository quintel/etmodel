/*
 * On drawing boxes and links:
 * SVG determines z-index of elements by its creation order. 
 * 
 *
 *
 */

var updated_coordinates = {};
var SNAPPABLE_GRID_SIZE = 10;

var link_styles = {
  'constant'  : '',
  'share'     : '-',
  'flexible'  : '. ',
  'dependent' : '--..'  
};

var Graph = Model.extend({
  GRID_STEP_SIZE : 800,

  init:function(width, height) {
    this.width = width;
    this.height = height;
    this.drawGrid(width, height);
    this.selected = [];
    this.converters = {};
    this.links = [];
  },

  /*
   * Draws the graph
   */
  draw:function() {    
    this.drawGrid(8000, 10000);

    _.each(this.links, function(link) { link.draw();} );
    _.each(this.converters, function(converter) { converter.draw();} );
    _.each(this.links, function(link) { link.adjust_to_converter();} );
  },

  enableDragging:function() {
    _.each(this.converters, function(converter) { converter.addDragEventListeners(); } );
  },

  /*
   * Draw the grid.
   */
  drawGrid:function(width, height) {
    for (var i = 1; i < width; i = i + this.GRID_STEP_SIZE) {
      //      M0   1 L10000   1
      //      M0 801 L10000 801
      r.path("M0 "+i+"L"+height+" "+i).attr({stroke : '#ccc'});;
    }
    for (var i = 1; i < height; i = i + this.GRID_STEP_SIZE) {
      //      M1   0 L1   8000
      //      M801 0 L801 8000
      r.path("M"+i+" 0 L"+i+" "+width).attr({stroke : '#ccc'});
    }
  },


  show_attribute_values:function() {
    _.each(this.converters, function(c) {
      var period = $('#period').val();
      var attr = $('#attribute').val();
      if (data[period] != undefined
          && data[period][''+c.id] != undefined
          && data[period][''+c.id][attr] != undefined) {            
        var value = data[period][''+c.id][attr];
        c.box.value_node.setAttr('text', ''+value);
      }
    });
  },

  show_selected:function() {
    var selected_group = $('#selected').val();
    _.each(this.converters, function(converter){
      if (selected_group == 'all' || converter.sector == selected_group) {
        converter.show();
      }
    });
  },

  hide_selected:function() {
    var selected_group = $('#selected').val();
    _.each(this.converters, function(converter){
      if (selected_group == 'all' || converter.sector == selected_group) {
        converter.hide();
      }
    });
  },

  deselect_all:function() {
    _.each(this.selected, function(converter) {converter.converter.unselect();});
    return false;
  }

})


var Link = Model.extend({
  init:function(converter_input_id, converter_output_id, color, style) {
    this.color = color;
    this.style = style;
    this.output_converter = GRAPH.converters[converter_output_id];
    this.input_converter = GRAPH.converters[converter_input_id];

    this.output_converter.links.push(this);
    this.input_converter.links.push(this);
    GRAPH.links.push(this);
  },

  /*
   * Draw the Link. 
   * *Warning*: The order of the elements being drawed defines their z-index.
   *            We want the links to appear behind the converter boxes, therefore
   *            call draw() on links first.
   *
   */  
  draw:function() {
    this.shape = r.connection(this.input_converter.input_slot(), this.output_converter.output_slot(), this.color, this.color+'|'+this.style);
  },

  output_converter:function() { return this.output_converter; },

  input_converter:function() { return this.input_converter; },

  highlight_on: function() {
    this.shape.bg.attr({stroke : '#f00'});
    this.shape.line.attr({stroke : '#f00'});
  },

  highlight_off: function() {
    this.shape.bg.attr({stroke : '#666'});
    this.shape.line.attr({stroke : '#666'});
  },

  /*
   * (Re-)connects a link to the converter slots.
   * Needs to be called everytime we move/drag a Converter. 
   * Also has to be called after drawing the converters.
   */
  adjust_to_converter:function() {
    r.connection(this.shape);
  }
});

var Converter = EventDispatcher.extend({
  STYLE_SELECTED : {fill : '#cff', 'stroke' : '#f00' },
  STYLE_HIGHLIGHT : {'stroke' : '#f00'},

  init:function(id, key, pos_x, pos_y, sector, use, label, hidden, fill_color, stroke_color) {
    this.id = id;
    this.key = key;
    this.pos_x = pos_x;
    this.pos_y = pos_y;
    this.use = use;
    this.sector = sector;
    this.label = label;
    this.links = [];
    this.highlighted = false;
    this.dirty = false;
    this.hidden = hidden;
    this.fill_color = fill_color;
    this.stroke_color = stroke_color;

    GRAPH.converters[id] = this;
  },

  /*
   * Draws the Converter on the raphael space. 
   * *Warning*: The order of the elements being drawed defines their z-index.
   *            We want the links to appear behind the converter boxes, therefore
   *            call draw() on converters after the links.
   *
   */
  draw:function() {
    this.drawConverterBox();

    if (this.isHidden()) { this.hide(); }

    this.addEventListeners();
  },

  drawConverterBox:function() {
    var txt_attributes = {'text-anchor' : 'start', 'font-family' : 'arial', 'font-weight' : 400, "font-size" : 11};
    var pos_x = this.pos_x;
    var pos_y = this.pos_y;
    var text_label = this.label;

    var box = r.rect(pos_x, pos_y, 80, 50);
    box.attr(this.getBoxAttributes());
    box.converter_id = this.id;
    box.converter = this;

    // Creating text nodes of converter
    box.id_node = r.text(0, 0, "#"+this.id+".");
    box.sector_node = r.text(0, 0, this.getSectorUseShortcut());
    box.text_node = r.text(0, 0, text_label).attr({'text-anchor': 'start'});
    box.value_node = r.text(0,0, '').attr({'text-anchor': 'start'});

    // Default styles for text nodes
    box.id_node.attr(txt_attributes);
    box.text_node.attr(txt_attributes);
    box.value_node.attr(txt_attributes);

    this.box = box;
    this.position_subnodes();
  },


  addEventListeners:function() {
    var that = this;
    this.box.node.onclick = function(evt) {
      if (evt.altKey && evt.shiftKey) { 
        that.toggle_visibility();
      } else if (evt.altKey) { 
        that.toggle_selection();
      } else if (evt.shiftKey) {
        that.highlight_toggle();
      }
      return false;
    }

    this.box.node.ondblclick = function(evt) {
      if (!evt.altKey || !evt.shiftKey) {
        var url = converter_url_prefix +"/" + that.id;
        window.open(url, '_blank');
      }
      return false;
    }
  },

  addDragEventListeners:function() {
    this.box.attr({cursor: "move"});

    this.box.dragger = function() {
      elements_drag($.merge([this], GRAPH.selected));
    }
    this.box.move = function(dx, dy) {
      elements_move($.merge([this],GRAPH.selected), dx,dy);
    }
    this.box.up = function() { 
      elements_up($.merge([this],GRAPH.selected));
    }
    this.box.drag(this.box.move, this.box.dragger, this.box.up);
  },

  /*
   * Has Converter changed attribute values?
   */
  isDirty:function() { return (this.dirty == true); },
  
  /*
   * Mark Converter changed.
   */
  markDirty:function() { this.dirty = true; },

  /*
   * Highlight converters and their links.
   */
  highlight_toggle: function() {
    (this.highlighted) ? this.highlight_off() : this.highlight_on();
  },

  highlight_on: function() {
    this.highlighted = true;
    this.box.attr(this.STYLE_HIGHLIGHT);
    _.each(this.links, function(link) { link.highlight_on(); } );
  },

  highlight_off: function() {
    this.highlighted = false;
    this.box.attr({'stroke' : '#000'});
    _.each(this.links, function(link) { link.highlight_off(); } );
  },


  /*
   * Select multiple converters to drag them at the same time.
   */
  toggle_selection:function() {
    (_.indexOf(GRAPH.selected, this.box) >= 0) ? this.unselect() : this.select();
  },

  unselect:function() {
    GRAPH.selected = _.without(GRAPH.selected, this.box);
    this.box.attr(this.getBoxAttributes());  
  },

  select:function() {
    GRAPH.selected.push(this.box);
    this.box.attr(this.STYLE_SELECTED);
  },

  getBox:function() {
    return this.box;
  },

  /*
   * Apply the passed raphael parameters to all the shapes of a converter.
   * Including links, Slots, Text nodes.
   * This is mostly useful for assigning opacity.
   */
  apply_to_all:function(attrs) {
    this.box.attr(attrs);
    this.box.text_node.attr(attrs);
    this.box.value_node.attr(attrs);
    this.input_slot().attr(attrs);
    this.output_slot().attr(attrs);
    _.each(this.links, function(link) {
      link.shape.bg.attr(attrs);
      link.shape.line.attr(attrs);
    });
  },

  toggle_visibility:function() {
    (this.isHidden()) ? this.show() : this.hide();
  },

  isHidden:function() { return this.hidden == true;},
  getHidden:function() { return this.hidden; },
  setHidden:function(value) {
    if (this.hidden != value) { this.markDirty(); }
    this.hidden = value;
  },

  hide:function() {
    this.setHidden(true);
    this.apply_to_all({opacity : 0.1});
  },

  show:function() {
    this.setHidden(false);
    this.apply_to_all({opacity : 1.0});
  },

  /*
   *
   */
  update_result:function(text) {
    this.box.value_node.text = text;
  },

  input_slot:function() {
    if (this.input_slot_element == undefined) { this.input_slot_element = r.circle(0,0, 5); }
    return this.input_slot_element;
  },

  output_slot:function() {
    if (this.output_slot_element == undefined) { this.output_slot_element = r.circle(0,0, 5); }
    return this.output_slot_element;
  },

  getSectorUseShortcut:function() {
    var sector_shortcut = this.sector.charAt(0).toUpperCase();
    var use_shortcut = this.use.charAt(0).toUpperCase();

    var shortcut = sector_shortcut;
    if (use_shortcut != 'U') { shortcut = shortcut + " " + use_shortcut; }

    return shortcut;
  },

  getBoxAttributes:function() {
    return {
      fill: this.fill_color, 
      "fill-opacity": 1, 
      'stroke-width' : 2, 
      'stroke' : this.stroke_color
    };
  },

  getAttributes:function() {
    return {
      'x' : this.pos_x, 
      'y' : this.pos_y, 
      'hidden' : this.getHidden()
    };
  },

  update_position:function(pos_x, pos_y) {
    pos_x = pos_x - (pos_x % 20);
    pos_y = pos_y - (pos_y % 20);

    this.pos_x = pos_x;
    this.pos_y = pos_y;
    this.markDirty();

    updated_coordinates[this.id] = [pos_x, pos_y];
  },

  /*
   * Position the child-shapes according to the converter shape.
   */
  position_subnodes:function() {
    var pos_x = this.box.attr('x');
    var pos_y = this.box.attr('y');

    this.box.id_node.attr(     {x : pos_x - 30, y : pos_y + 7 });
    this.box.sector_node.attr( {x : pos_x - 10, y : pos_y + 35});
    this.box.text_node.attr(   {x : pos_x + 5,  y : pos_y + 10});
    this.box.value_node.attr(  {x : pos_x + 5,  y : pos_y + 40});

    this.input_slot().attr( {cx : pos_x - 5 , cy : pos_y + 20 });
    this.output_slot().attr({cx : pos_x + 85, cy : pos_y + 20 });
  },

  /*
   * Relative move to.
   * Snaps converter to an (invisible) grid. 
   */ 
  moveTo:function(dx,dy) {
    var b = this.box;

    var x = b.ox + dx;
    var y = b.oy + dy;
    x = x - (x % SNAPPABLE_GRID_SIZE);
    y = y - (y % SNAPPABLE_GRID_SIZE);

    var att = b.type == "rect" ? {x: x, y: y} : {cx: x, cy: y};
    b.attr(att);

    this.position_subnodes();

    $.each(this.links, function(i, link) { link.adjust_to_converter(); })
  }

});


function elements_drag(elements) {
  $.each(elements, function(i, converter_box){
    $.each(converter_box.converter.links, function(i, link) {
      // Highlights in/output converter slots
      link.input_converter.input_slot().attr({fill : '#cc0'});
      link.output_converter.output_slot().attr({fill : '#cc0'});
    })
    var b = converter_box; // "b" just to make it more readable
    b.ox = b.type == "rect" ? b.attr("x") : b.attr("cx");
    b.oy = b.type == "rect" ? b.attr("y") : b.attr("cy");
  })
}

function elements_move(elements,dx,dy) {
  $.each(elements, function(i, converter_box){
    converter_box.converter.moveTo(dx,dy);
  })
  r.safari();
}

function elements_up(elements){
  $.each(elements, function(i, converter_box){
    $.each(converter_box.converter.links, function(i, link) {
      link.input_converter.input_slot().attr({fill : '#fff'});
      link.output_converter.output_slot().attr({fill : '#fff'});
    })
    converter_box.converter.update_position(converter_box.attr('x'), converter_box.attr('y'));    
  })
}

/*
 * { converter_id : {x : 12, y : 23, hidden : true} }
 */
function getUpdatedValues() {
  var converter_position_attrs = {};
  $.each(GRAPH.converters, function(i, converter) {
    if (converter.isDirty()) {
      converter_position_attrs[converter.id] = converter.getAttributes();
    }
  })
  return converter_position_attrs;
}

