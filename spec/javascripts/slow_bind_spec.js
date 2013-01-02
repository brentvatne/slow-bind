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
      return afterEach(function() {
        return this.clock.restore();
      });
    });
    describe('with cancel event', function() {
      beforeEach(function() {
        return this.returnValue = this.$dropdown.slowBind(this.callback, {
          triggerEvent: 'trigger-event',
          cancelEvent: 'cancel-event',
          wait: 300
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
      return it('returns the jQuery object for the element', function() {
        return expect(this.returnValue.attr('class')).toBe(this.$dropdown.attr('class'));
      });
    });
    describe('with restart event', function() {
      describe('when trigger and restart event are different', function() {
        beforeEach(function() {
          return this.returnValue = this.$dropdown.slowBind(this.callback, {
            triggerEvent: 'trigger-event',
            restartEvent: 'restart-event',
            wait: 300
          });
        });
        return it('resets the wait on triggering the restart event', function() {
          this.$dropdown.trigger('trigger-event');
          this.clock.tick(100);
          this.$dropdown.trigger('restart-event');
          this.clock.tick(250);
          expect(this.callback.called).toBe(false);
          this.clock.tick(100);
          return expect(this.callback.called).toBe(true);
        });
      });
      return describe('when trigger and restart event are the same', function() {
        beforeEach(function() {
          return this.returnValue = this.$dropdown.slowBind(this.callback, {
            triggerEvent: 'trigger-and-restart-event',
            restartEvent: 'trigger-and-restart-event',
            wait: 300
          });
        });
        return it('resets the wait on triggering the restart event', function() {
          this.$dropdown.trigger('trigger-and-restart-event');
          this.clock.tick(100);
          this.$dropdown.trigger('trigger-and-restart-event');
          this.clock.tick(250);
          expect(this.callback.called).toBe(false);
          this.clock.tick(100);
          return expect(this.callback.called).toBe(true);
        });
      });
    });
    return it('can have multiple cancelling events', function() {});
  });

}).call(this);
