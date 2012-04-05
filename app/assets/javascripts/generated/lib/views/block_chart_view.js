/* DO NOT MODIFY. This file was compiled Thu, 05 Apr 2012 12:14:52 GMT from
 * /Users/paozac/Sites/etmodel/app/assets/coffeescripts/lib/views/block_chart_view.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.BlockChartView = (function(_super) {

    __extends(BlockChartView, _super);

    function BlockChartView() {
      this.update_block_charts = __bind(this.update_block_charts, this);
      this.hide_block = __bind(this.hide_block, this);
      this.show_block = __bind(this.show_block, this);
      this.setup_callbacks = __bind(this.setup_callbacks, this);
      this.results = __bind(this.results, this);
      this.html = __bind(this.html, this);
      this.already_on_screen = __bind(this.already_on_screen, this);
      this.render = __bind(this.render, this);
      BlockChartView.__super__.constructor.apply(this, arguments);
    }

    BlockChartView.prototype.initialize = function() {
      this.initialize_defaults();
      return this.current_z_index = 5;
    };

    BlockChartView.prototype.render = function() {
      if (!this.already_on_screen()) {
        this.clear_container();
        this.container_node().html(this.html());
        this.setup_checkboxes();
        this.setup_callbacks();
        this.hide_format_toggler();
      }
      return this.update_block_charts();
    };

    BlockChartView.prototype.already_on_screen = function() {
      return this.container_node().find("#blockchart").length === 1;
    };

    BlockChartView.prototype.html = function() {
      return charts.html[this.model.get('id')];
    };

    BlockChartView.prototype.results = function() {
      return this.model.series.map(function(serie) {
        return serie.result();
      });
    };

    BlockChartView.prototype.can_be_shown_as_table = function() {
      return false;
    };

    BlockChartView.prototype.setup_callbacks = function() {
      var _this = this;
      this.bind_hovers();
      $('#block_list li').hover(function() {
        return $(this).find("ul").show(1);
      }, function() {
        return $(this).find("ul").hide(1);
      });
      $('.show_hide_block').click(function(e) {
        var block_id;
        block_id = $(e.target).attr('data-block_id');
        _this.toggle_block(block_id);
        _this.align_checkbox(block_id);
        return false;
      });
      return $('.block_list_checkbox').click(function(e) {
        var block_id, item, _i, _j, _len, _len2, _ref, _ref2, _results, _results2;
        if ($(e.target).is(':checked')) {
          _ref = $(e.target).parent().find('.show_hide_block');
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            item = _ref[_i];
            block_id = $(item).attr('data-block_id');
            _results.push(_this.show_block(block_id));
          }
          return _results;
        } else {
          _ref2 = $(e.target).parent().find('.show_hide_block');
          _results2 = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            item = _ref2[_j];
            block_id = $(item).attr('data-block_id');
            _results2.push(_this.hide_block(block_id));
          }
          return _results2;
        }
      });
    };

    BlockChartView.prototype.setup_checkboxes = function() {
      var item, _i, _len, _ref, _results;
      _ref = $(".block_list_checkbox");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if ($(item).parent().find('.visible').length > 0) {
          _results.push($(item).attr('checked', true));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    BlockChartView.prototype.toggle_block = function(block_id) {
      if ($('#canvas').find('#block_container_' + block_id).hasClass('visible')) {
        return this.hide_block(block_id);
      } else {
        return this.show_block(block_id);
      }
    };

    BlockChartView.prototype.align_checkbox = function(block_id) {
      var checkbox, list_blocks;
      checkbox = $('#show_hide_block_' + block_id).parent().parent().parent().find('.block_list_checkbox');
      list_blocks = $('#block_list #show_hide_block_' + block_id).parent().parent();
      if (list_blocks.find('.visible').length > 0) {
        return checkbox.attr('checked', true);
      } else {
        $(this).parent().find(':checkbox').attr('checked', false);
        return checkbox.attr('checked', false);
      }
    };

    BlockChartView.prototype.bind_hovers = function() {
      return $('.block_container').hover(function(e) {
        $(e.target).addClass("hover").css({
          "z-index": this.current_z_index
        }).find(".content").stop().animate({
          width: '150px',
          height: '100px'
        });
        $(e.target).find(".header").stop().animate({
          width: '150px'
        });
        $(".block_container").stop().not(".hover");
        $("#tooltip").stop();
        return this.current_z_index++;
      }, function() {
        $(this).removeClass("hover").find('.content').stop().animate({
          width: '75px',
          height: '0px'
        });
        $(this).find('.header').stop().animate({
          width: '75px'
        });
        $(".block_container").stop();
        return $("#tooltip").stop();
      });
    };

    BlockChartView.prototype.show_block = function(block_id) {
      $('#canvas').find('#block_container_' + block_id).removeClass('invisible').addClass('visible').css({
        'z-index': this.current_z_index
      });
      $('#block_list #show_hide_block_' + block_id).addClass('visible').removeClass('invisible');
      $.ajax({
        url: "/output_elements/visible/block_" + block_id,
        method: 'post'
      });
      this.current_z_index++;
      return this.update_block_charts();
    };

    BlockChartView.prototype.hide_block = function(block_id) {
      $('#canvas').find('#block_container_' + block_id).removeClass('visible').addClass('invisible');
      $('#block_list #show_hide_block_' + block_id).addClass('invisible').removeClass('visible');
      $.ajax({
        url: "/output_elements/invisible/block_" + block_id,
        method: 'post'
      });
      return this.update_block_charts();
    };

    BlockChartView.prototype.update_block_charts = function() {
      var data_array, max_cost, max_invest, ticks, value;
      data_array = this.results();
      max_cost = 0;
      max_invest = 0;
      $.each(data_array, function(index, block) {
        if ($('#block_container_' + block[0]).hasClass('visible')) {
          if (max_cost < block[1]) max_cost = block[1];
          if (max_invest < block[2]) return max_invest = block[2];
        }
      });
      if (max_cost < 200) max_cost = 200;
      if (max_invest < 5) max_invest = 5;
      ticks = $('#x-axis li');
      value = null;
      ticks.each(function(index, tick) {
        value = (max_invest / 5) * (index + 1);
        return $('#' + tick.id).text(Math.round(value));
      });
      ticks = $('#y-axis li');
      ticks.each(function(index, tick) {
        value = (max_cost / 5) * (5 - index);
        return $('#' + tick.id).text(Math.round(value));
      });
      return $.each(data_array, function(index, block) {
        var block_bottom, block_left;
        block_bottom = block[1] * 100 / max_cost;
        block_left = block[2] * 100 / max_invest;
        return $('#block_container_' + block[0]).animate({
          'bottom': block_bottom + "%",
          'left': block_left + "%"
        });
      });
    };

    return BlockChartView;

  })(BaseChartView);

}).call(this);
