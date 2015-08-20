(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module unless amdModuleId is set
    define('simple-tooltip', ["jquery","simple-module","simple-util"], function (a0,b1,c2) {
      return (root['tooltip'] = factory(a0,b1,c2));
    });
  } else if (typeof exports === 'object') {
    // Node. Does not work with strict CommonJS, but
    // only CommonJS-like environments that support module.exports,
    // like Node.
    module.exports = factory(require("jquery"),require("simple-module"),require("simple-util"));
  } else {
    root.simple = root.simple || {};
    root.simple['tooltip'] = factory(jQuery,SimpleModule,simple.util);
  }
}(this, function ($, SimpleModule, simpleUtil) {

var Tooltip, tooltip,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Tooltip = (function(superClass) {
  extend(Tooltip, superClass);

  function Tooltip() {
    return Tooltip.__super__.constructor.apply(this, arguments);
  }

  Tooltip.prototype.opts = {
    el: "",
    content: "",
    position: "auto"
  };

  Tooltip.prototype.tpl = "<div class=\"simple-tooltip\">\n  <div class=\"arrow\"></div>\n  <div class=\"content\"></div>\n</div>";

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
    this.position = null;
    this.top = 0;
    this.left = 0;
    return this._render();
  };

  Tooltip.prototype._render = function() {
    this.el = $(this.tpl);
    this.el.find('.content').html(this.opts.content);
    this.arrow = this.el.find('.arrow');
    return this.target.data("simple-tooltip", this);
  };

  Tooltip.prototype.setPosition = function() {
    var scrollLeft, scrollTop, viewportHeigth, viewportWidth;
    viewportWidth = $(window).width();
    scrollTop = $(window).scrollTop();
    viewportHeigth = $(window).height();
    scrollLeft = $(window).scrollLeft();
    this.targetOffset = this.target.offset();
    this.targetWidth = this.target.outerWidth();
    this.targetHeight = this.target.outerHeight();
    this.tooltipWidth = this.el.outerWidth();
    this.tooltipHeight = this.el.outerHeight();
    this.position = this.opts.position;
    if (this.position === "auto") {
      if (this.targetOffset.top + this.targetHeight + this.tooltipHeight + this.arrowHeight + this.offset < viewportHeigth + scrollTop) {
        this.position = 'bottom';
      } else if (this.targetOffset.top - this.tooltipHeight - this.arrowHeight - this.offset > 0) {
        this.position = 'top';
      } else if (this.targetOffset.left - this.tooltipWidth - this.arrowHeight - this.offset > 0) {
        this.position = 'left';
      } else if (this.targetOffset.left + this.targetWidth + this.tooltipWidth + this.arrowHeight + this.offset < viewportWidth + scrollLeft) {
        this.position = 'right';
      }
    }
    switch (this.position) {
      case 'bottom':
        this.left = this.targetOffset.left + (this.targetWidth - this.tooltipWidth) * 0.5;
        this.top = this.targetOffset.top + this.targetHeight + this.arrowHeight;
        return this.setArrow('up');
      case 'top':
        this.left = this.targetOffset.left + (this.targetWidth - this.tooltipWidth) * 0.5;
        this.top = this.targetOffset.top - this.tooltipHeight - this.arrowHeight;
        return this.setArrow('down');
      case 'left':
        this.left = this.targetOffset.left - this.tooltipWidth - this.arrowHeight;
        this.top = this.targetOffset.top + (this.targetHeight - this.tooltipHeight) * 0.5;
        return this.setArrow("right");
      case 'right':
        this.left = this.targetOffset.left + this.targetWidth + this.arrowHeight;
        this.top = this.targetOffset.top + (this.targetHeight - this.tooltipHeight) * 0.5;
        return this.setArrow("left");
    }
  };

  Tooltip.prototype.setArrow = function(orientation) {
    this.arrow.removeClass('up down left right').addClass(orientation);
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
    var left, top;
    this.el.appendTo('body');
    this.setPosition();
    this.el.css({
      left: this.left,
      top: this.top,
      opacity: 0
    });
    this.el.show();
    this.el[0].offsetHeight;
    top = this.top;
    left = this.left;
    switch (this.position) {
      case 'top':
        top -= this.offset;
        break;
      case 'bottom':
        top += this.offset;
        break;
      case 'left':
        left -= this.offset;
        break;
      case 'right':
        left += this.offset;
    }
    if (this._hiding) {
      this.el.off('.tooltip-hiding');
      this._hiding = false;
    }
    return this.el.css({
      top: top,
      left: left,
      opacity: 1
    });
  };

  Tooltip.prototype.hide = function() {
    if (this._hiding) {
      this.el.off('.tooltip-hiding');
    }
    this.el.css({
      opacity: 0,
      left: this.left,
      top: this.top
    });
    this._hiding = true;
    return this.el.one((simple.util.transitionEnd()) + ".tooltip-hiding", (function(_this) {
      return function() {
        _this.el.hide().remove();
        _this.position = null;
        return _this._hiding = false;
      };
    })(this));
  };

  Tooltip.prototype.destroy = function() {
    this.el.remove();
    return this.target.removeData('tooltip');
  };

  return Tooltip;

})(SimpleModule);

tooltip = function(opts) {
  return new Tooltip(opts);
};

return tooltip;

}));
