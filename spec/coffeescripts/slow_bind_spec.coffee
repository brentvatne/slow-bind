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
      triggerEvent: 'x'
      cancelEvent:  'y'
      wait:          300

    afterEach ->
      @clock.restore()

  it 'triggers the the callback after x seconds', ->
    @$dropdown.trigger('x')
    # Full wait time not yet elapsed
    @clock.tick(100)
    expect(@callback.called).toBe(false)

    # Time is up!
    @clock.tick(200)
    expect(@callback.called).toBe(true)

  it 'does not fire a callback when the cancelEvent is triggered
      within the time period', ->
    # Initial trigger
    @$dropdown.trigger('x')
    @clock.tick(100)

    # Cancel it within the allowed time
    @$dropdown.trigger('y')
    @clock.tick(500)

    expect(@callback.called).toBe(false)

  it 'calls the callback with the original event', ->
    @$dropdown.trigger('x')
    @clock.tick(300)

  it 'returns the jQuery object for the element', ->
    # jQuery 1.5 does not support $a.is($b)
    expect(@returnValue.attr('class')).toBe(@$dropdown.attr('class'))

  it 'calls the callback with this set as the jquery object', ->
    # not tested yet

  it 'can have multiple cancelling events', ->
    # not yet
