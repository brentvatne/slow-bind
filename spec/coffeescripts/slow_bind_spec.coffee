describe '$.slowBind', ->
  beforeEach ->
    # Fixtures
    $fixture   = $('<div id="fixture"></div>')
    @$dropdown = $('<div class="dropdown-menu"></div>')
    $fixture.append(@$dropdown)
    $('body').append($fixture)

    @callback = sinon.spy()
    @clock    = sinon.useFakeTimers()

    @returnValue = @$dropdown.slowBind @callback,
      triggerEvent: 'trigger-event'
      restartEvent: 'restart-event'
      cancelEvent:  'cancel-event'
      wait:          300

    afterEach ->
      @clock.restore()

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

  it 'resets the time if the restartEvent is set', ->
    @$dropdown.trigger('trigger-event')

    # Full wait time not yet elapsed
    @clock.tick(100)
    @$dropdown.trigger('restart-event')

    # This is when it would normally fire
    @clock.tick(200)
    expect(@callback.called).toBe(false)

    # Instead it will fire a bit later
    @clock.tick(100)
    expect(@callback.called).toBe(true)

  it 'can have multiple cancelling events', ->
    # not yet
