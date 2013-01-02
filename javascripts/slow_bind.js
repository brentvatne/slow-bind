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
      var cancelEvent, restartEvent, triggerEvent, wait;
      triggerEvent = options.triggerEvent;
      restartEvent = options.restartEvent;
      cancelEvent = options.cancelEvent;
      wait = options.wait;
      this.bind(triggerEvent, function(e) {
        return wrapCallback(callback, triggerEvent, wait, e);
      });
      if (cancelEvent) {
        this.bind(cancelEvent, function(e) {
          return cancelCallback(triggerEvent);
        });
      }
      if (restartEvent) {
        this.bind(restartEvent, function(e) {
          cancelCallback(triggerEvent);
          return wrapCallback(callback, triggerEvent, wait, e);
        });
      }
      return this;
    };
  })(jQuery, window);

}).call(this);
