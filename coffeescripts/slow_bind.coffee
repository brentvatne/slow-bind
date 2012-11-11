(($, window) ->
  # Wraps the callback in a function that delays execution with a timer
  wrapCallback = (callback, triggerEvent, wait, e) ->
    $(@).data(triggerEvent, setTimeout(( ->
      callback.call(@, e)
    ), wait))

  # Clears any timers that might exist for the given event
  cancelCallback = (triggerEvent) ->
    clearTimeout $(@).data(triggerEvent)

  $.fn.slowBind = (callback, options) ->
    triggerEvent = options.triggerEvent
    cancelEvent  = options.cancelEvent
    wait         = options.wait

    @.bind triggerEvent, (e) -> wrapCallback(callback, triggerEvent, wait, e)
    @.bind cancelEvent,  (e) -> cancelCallback(triggerEvent)
    @

)(jQuery, window)
