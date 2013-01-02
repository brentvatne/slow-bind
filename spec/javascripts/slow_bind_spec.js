(function() {

  describe('$.slowBind', function() {
    beforeEach(function() {
      var $fixture;
      $fixture = $('<div id="fixture"></div>');
      this.$dropdown = $('<div class="dropdown-menu"></div>');
      $fixture.append(this.$dropdown);
      $('body').append($fixture);
      this.callback = sinon.spy();
      this.clock = sinon.useFakeTimers();
      this.returnValue = this.$dropdown.slowBind(this.callback, {
        triggerEvent: 'trigger-event',
        restartEvent: 'restart-event',
        cancelEvent: 'cancel-event',
        wait: 300
      });
      return afterEach(function() {
        return this.clock.restore();
      });
    });
    it('triggers the the callback after x seconds', function() {
      this.$dropdown.trigger('trigger-event');
      this.clock.tick(100);
      expect(this.callback.called).toBe(false);
      this.clock.tick(200);
      return expect(this.callback.called).toBe(true);
    });
    it('does not fire a callback when the cancelEvent is triggered\
      within the time period', function() {
      this.$dropdown.trigger('trigger-event');
      this.clock.tick(100);
      this.$dropdown.trigger('cancel-event');
      this.clock.tick(500);
      return expect(this.callback.called).toBe(false);
    });
    it('returns the jQuery object for the element', function() {
      return expect(this.returnValue.attr('class')).toBe(this.$dropdown.attr('class'));
    });
    it('resets the time if the restartEvent is set', function() {
      this.$dropdown.trigger('trigger-event');
      this.clock.tick(100);
      this.$dropdown.trigger('restart-event');
      this.clock.tick(200);
      expect(this.callback.called).toBe(false);
      this.clock.tick(100);
      return expect(this.callback.called).toBe(true);
    });
    return it('can have multiple cancelling events', function() {});
  });

}).call(this);
