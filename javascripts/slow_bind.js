(function() {

  (function($, window) {
    var cancelCallback, wrapCallback;
    wrapCallback = function(callback, triggerEvent, wait, e) {
      return $(this).data(triggerEvent, setTimeout((function() {
        return callback.call(this, e);
      }), wait));
    };
    cancelCallback = function(triggerEvent) {
      return clearTimeout($(this).data(triggerEvent));
    };
    return $.fn.slowBind = function(callback, options) {
      var cancelEvent, triggerEvent, wait;
      triggerEvent = options.triggerEvent;
      cancelEvent = options.cancelEvent;
      wait = options.wait;
      this.bind(triggerEvent, function(e) {
        return wrapCallback(callback, triggerEvent, wait, e);
      });
      this.bind(cancelEvent, function(e) {
        return cancelCallback(triggerEvent);
      });
      return this;
    };
  })(jQuery, window);

}).call(this);
