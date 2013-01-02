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
    restartEvent = options.restartEvent
    cancelEvent  = options.cancelEvent
    wait         = options.wait

    # A trigger event is always required
    unless triggerEvent == restartEvent
      @.bind triggerEvent, (e) -> wrapCallback(callback, triggerEvent, wait, e)

    # The cancel event is optional
    if cancelEvent
      @.bind cancelEvent, (e) -> cancelCallback(triggerEvent)

    # The restart event is optional. It simply combines the cancel and trigger events
    if restartEvent
      @.bind restartEvent, (e) ->
        cancelCallback(triggerEvent)
        wrapCallback(callback, triggerEvent, wait, e)

    # Return the jQuery instance
    @

)(jQuery, window)
