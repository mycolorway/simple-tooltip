(function() {
  var Tooltip,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Tooltip = (function(_super) {
    __extends(Tooltip, _super);

    function Tooltip() {
      return Tooltip.__super__.constructor.apply(this, arguments);
    }

    Tooltip.prototype.opts = {
      el: "",
      content: "",
      position: "auto"
    };

    Tooltip.prototype.tpl = "<div class=\"simple-tooltip\">\n  <div class=\"arrow\"></div>\n  <div class=\"content\"></div>\n<div>";

    Tooltip.prototype.arrowHeight = 5;

    Tooltip.prototype.arrowBase = 10;

    Tooltip.prototype.offset = 10;

    Tooltip.prototype._init = function() {
      this.target = $(this.opts.el).first();
      if (this.target.length === 0) {
        throw "Must provide a valid selector";
      }
      if (this.opts.content === "") {
        throw "Tooltip's content can't  be empty";
      }
      if (this.target.data('simple-tooltip')) {
        this.target.data('simple-tooltip').destroy();
      }
      this.position = this.opts.position;
      this.top = 0;
      this.left = 0;
      this._render();
      return this._bind();
    };

    Tooltip.prototype._render = function() {
      var scrollLeft, scrollTop, viewportHeigth, viewportWidth;
      this.el = $(this.tpl);
      $(".content", this.el).text(this.opts.content);
      this.arrow = $('.arrow', this.el);
      this.el.appendTo('body');
      this.target.data("simple-tooltip", this);
      viewportWidth = $(window).width();
      scrollTop = $(window).scrollTop();
      viewportHeigth = $(window).height();
      scrollLeft = $(window).scrollLeft();
      this.targetOffset = this.target.offset();
      this.targetWidth = this.target.outerWidth();
      this.targetHeight = this.target.outerHeight();
      this.tooltipWidth = this.el.outerWidth();
      this.tooltipHeight = this.el.outerHeight();
      if (this.position === "auto") {
        if (this.targetOffset.top + this.targetHeight + this.tooltipHeight + this.arrowHeight + this.offset < viewportHeigth + scrollTop) {
          return this.setPosition("bottom");
        }
        if (this.targetOffset.top - this.tooltipHeight - this.arrowHeight - this.offset > 0) {
          return this.setPosition("top");
        }
        if (this.targetOffset.left - this.tooltipWidth - this.arrowHeight - this.offset > 0) {
          return this.setPosition("left");
        }
        if (this.targetOffset.left + this.targetWidth + this.tooltipWidth + this.arrowHeight + this.offset < viewportWidth + scrollLeft) {
          return this.setPosition("right");
        }
      } else {
        return this.setPosition(this.opts.position);
      }
    };

    Tooltip.prototype.setPosition = function(pos) {
      switch (pos) {
        case 'bottom':
          this.position = "bottom";
          this.left = this.targetOffset.left + (this.targetWidth - this.tooltipWidth) * 0.5;
          this.top = this.targetOffset.top + this.targetHeight + this.arrowHeight;
          return this.setArrow('up');
        case 'top':
          this.position = "top";
          this.left = this.targetOffset.left + (this.targetWidth - this.tooltipWidth) * 0.5;
          this.top = this.targetOffset.top - this.tooltipHeight - this.arrowHeight;
          return this.setArrow('down');
        case 'left':
          this.position = "left";
          this.left = this.targetOffset.left - this.tooltipWidth - this.arrowHeight;
          this.top = this.targetOffset.top + (this.targetHeight - this.tooltipHeight) * 0.5;
          return this.setArrow("right");
        case 'right':
          this.position = "right";
          this.left = this.targetOffset.left + this.targetWidth + this.arrowHeight;
          this.top = this.targetOffset.top + (this.targetHeight - this.tooltipHeight) * 0.5;
          return this.setArrow("left");
      }
    };

    Tooltip.prototype.setArrow = function(orientation) {
      this.arrow.addClass(orientation);
      switch (orientation) {
        case 'up':
          return this.arrow.css({
            left: this.tooltipWidth / 2 - this.arrowBase / 2,
            top: -this.arrowHeight
          });
        case 'down':
          return this.arrow.css({
            left: this.tooltipWidth / 2 - this.arrowBase / 2,
            top: this.tooltipHeight
          });
        case 'left':
          return this.arrow.css({
            left: -this.arrowHeight,
            top: this.tooltipHeight / 2 - this.arrowBase / 2
          });
        case 'right':
          return this.arrow.css({
            left: this.tooltipWidth,
            top: this.tooltipHeight / 2 - this.arrowBase / 2
          });
      }
    };

    Tooltip.prototype.show = function() {
      this.el.css({
        left: this.left,
        top: this.top,
        opacity: 0
      });
      this.el.show();
      this.el.addClass('transition');
      this.el[0].offsetHeight;
      switch (this.position) {
        case 'top':
          this.el.css({
            top: this.top - this.offset
          });
          break;
        case 'bottom':
          this.el.css({
            top: this.top + this.offset
          });
          break;
        case 'left':
          this.el.css({
            left: this.left - this.offset
          });
          break;
        case 'right':
          this.el.css({
            left: this.left + this.offset
          });
      }
      return this.el.css({
        opacity: 1
      });
    };

    Tooltip.prototype.hide = function() {
      return this.el.css({
        opacity: 0,
        left: this.left,
        top: this.top
      });
    };

    Tooltip.prototype._bind = function() {
      return this.el.on('transitionend webkitTransitionEnd', (function(_this) {
        return function() {
          if (_this.el.css('opacity') === "0") {
            _this.el.removeClass('transition');
            return _this.el.hide();
          }
        };
      })(this));
    };

    Tooltip.prototype.destroy = function() {
      this.el.remove();
      return this.target.removeData('tooltip');
    };

    return Tooltip;

  })(Widget);

  window.simple || (window.simple = {});

  simple.tooltip = function(opts) {
    return new Tooltip(opts);
  };

}).call(this);
