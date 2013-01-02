SlowBind
=============

Allows firing of a callback to be delayed, and if another cancelling event is
triggered during that delay, the callback will never be called. This
might be useful to slow down the response time of dropdown menus, where
often a user can briefly hover outside of the container accidentally
while moving their mouse towards their target.

```coffeescript
# Calls hideMenu on mouseleave unless the mouseenter event is fired
# within 500ms of mouseleave
$('.dropdown-menu').slowBind hideMenu,
  triggerEvent: 'mouseleave'
  cancelEvent:  'mouseenter'
  wait:          500
```

```coffeescript
# Calls stretchChartToFit on window resize unless the resize event is fired
# within 200ms of the previous resize
$(window).slowBind stretchChartToFit,
  triggerEvent: 'resize'
  restartEvent: 'resize'
  wait:          200
```

If you have Ruby and Bundler installed, you can run the specs with `bundle && rake jasmine` and navigate to http://localhost:8888/
