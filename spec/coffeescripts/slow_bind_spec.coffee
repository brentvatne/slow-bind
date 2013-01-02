describe '$.slowBind', ->
  beforeEach ->
    # Fixtures
    $fixture   = $('<div id="fixture"></div>')
    @$dropdown = $('<div class="dropdown-menu"></div>')
    $fixture.append(@$dropdown)
    $('body').append($fixture)

    @callback = sinon.spy()
    @clock    = sinon.useFakeTimers()

    afterEach ->
      @clock.restore()

  describe 'with cancel event', ->
    beforeEach ->
      @returnValue = @$dropdown.slowBind @callback,
        triggerEvent: 'trigger-event'
        cancelEvent:  'cancel-event'
        wait:          300

    it 'triggers the the callback after x seconds', ->
      @$dropdown.trigger('trigger-event')
      # Full wait time not yet elapsed
      @clock.tick(100)
      expect(@callback.called).toBe(false)

      # Time is up!
      @clock.tick(200)
      expect(@callback.called).toBe(true)

    it 'does not fire a callback when the cancelEvent is triggered
        within the time period', ->
      # Initial trigger
      @$dropdown.trigger('trigger-event')
      @clock.tick(100)

      # Cancel it within the allowed time
      @$dropdown.trigger('cancel-event')
      @clock.tick(500)

      expect(@callback.called).toBe(false)

    it 'returns the jQuery object for the element', ->
      # jQuery 1.5 does not support $a.is($b)
      expect(@returnValue.attr('class')).toBe(@$dropdown.attr('class'))

  describe 'with restart event', ->
    describe 'when trigger and restart event are different', ->
      beforeEach ->
        @returnValue = @$dropdown.slowBind @callback,
          triggerEvent: 'trigger-event'
          restartEvent: 'restart-event'
          wait:          300

      it 'resets the wait on triggering the restart event', ->
        # Full wait time not yet elapsed
        @$dropdown.trigger('trigger-event')
        @clock.tick(100)
        @$dropdown.trigger('restart-event')

        # This is when it would normally fire
        @clock.tick(250)
        expect(@callback.called).toBe(false)

        # Instead it will fire a bit later
        @clock.tick(100)
        expect(@callback.called).toBe(true)

    describe 'when trigger and restart event are the same', ->
      beforeEach ->
        @returnValue = @$dropdown.slowBind @callback,
          triggerEvent: 'trigger-and-restart-event'
          restartEvent: 'trigger-and-restart-event'
          wait:          300

      it 'resets the wait on triggering the restart event', ->
        # Full wait time not yet elapsed
        @$dropdown.trigger('trigger-and-restart-event')
        @clock.tick(100)
        @$dropdown.trigger('trigger-and-restart-event')

        # This is when it would normally fire
        @clock.tick(250)
        expect(@callback.called).toBe(false)

        # Instead it will fire a bit later
        @clock.tick(100)
        expect(@callback.called).toBe(true)

  it 'can have multiple cancelling events', ->
    # not yet
