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
        triggerEvent: 'x',
        cancelEvent: 'y',
        wait: 300
      });
      return afterEach(function() {
        return this.clock.restore();
      });
    });
    it('triggers the the callback after x seconds', function() {
      this.$dropdown.trigger('x');
      this.clock.tick(100);
      expect(this.callback.called).toBe(false);
      this.clock.tick(200);
      return expect(this.callback.called).toBe(true);
    });
    it('does not fire a callback when the cancelEvent is triggered\
      within the time period', function() {
      this.$dropdown.trigger('x');
      this.clock.tick(100);
      this.$dropdown.trigger('y');
      this.clock.tick(500);
      return expect(this.callback.called).toBe(false);
    });
    it('calls the callback with the original event', function() {
      this.$dropdown.trigger('x');
      return this.clock.tick(300);
    });
    it('returns the jQuery object for the element', function() {
      return expect(this.returnValue.attr('class')).toBe(this.$dropdown.attr('class'));
    });
    it('calls the callback with this set as the jquery object', function() {});
    return it('can have multiple cancelling events', function() {});
  });

}).call(this);
