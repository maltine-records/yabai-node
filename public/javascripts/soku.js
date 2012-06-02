$(function() {

  /**
   * @class
   */
  var Soku = function($el) {
    this.$el = $el;
    this.val = 0;
  };

  Soku.prototype.update = function(val) {
    if (this.val == val) {
      return;
    }
    var isKasoku = this.val < val;
    console.log(val);
    this.val = val;
    this.render();
  };

  Soku.prototype.render = function() {
    $('span', this.$el).remove();
    if (this.val > 5.000) {
      this.$el.addClass('yabai-now');
    } else {
      this.$el.removeClass('yabai-now');
    }
    var strVal = String(this.val).substr(0, 10);
    Array.prototype.forEach.call(strVal, function(c, idx){
      var $c = $('<span class="soku-char">').text(c);
      setTimeout(function() {
        $c.addClass('move');
      }, idx*20);
      this.$el.append($c);
    }, this);
  };

  window.soku = new Soku($('#currentSoku'));
});

