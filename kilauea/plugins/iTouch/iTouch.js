Kilauea.addPlugin('http://sharpeleven.net/kilauea/iTouch', 'iTouch', function(inst, params) {
	/**
	 * Class: http://sharpeleven.net/kilauea/iTouch
	 *
	 * Provides support for iPhone / iPad touch gestures such as swipe
	 *
	 * Parameters:
	 *   iTouch doesn't need any parameters so far.
	 */
	this.revision = "$Id:$";
	this.id = inst.id;
	
	this.swipeThreshold = 300;
	
	// make events extensible
	this.events = {
		'swipeRight': {
			check: function(obj) {
				return obj.dir == 'x' && obj.sign == 1 && (obj.last.x - obj.start.x) > obj.swipeThreshold;
			},
			fn: function(inst) {
				inst.previous();
			}
		},
		'swipeLeft': {
			check: function(obj) {
			return obj.dir == 'x' && obj.sign == -1 && (obj.start.x - obj.last.x) > obj.swipeThreshold;
			},
			fn: function(inst) {
				inst.next();
			}
		}
	};
	
	
	// see the manual (page 68) and cf Dave Dunkin's http://rabblerule.blogspot.com/2009/08/detecting-swipe-in-webkit.html
	
	this.start = {};
	this.diff = {};
	this.last = {};
	this.sign = null;
	this.dir = null;
	this.isAct = false;
	
	// we need to make use of javascript closures in order to have access to the plugin's instantiated object
	var t = this;
	
	this.touchStart = function(ev) {
		if (ev.touches.length == 1 && !t.isAct) {
			// record the starting value
			t.start = {
				x: ev.touches[0].pageX,
				y: ev.touches[0].pageY
			};
			// set the value of the most recent position
			t.last = {
				x: t.start.x,
				y: t.start.y
			};
			// enable tracking
			t.isAct = true;
		}
	};
	this.touchCancel = function() {
		// reset some values
		t.isAct = false;
		t.sign = null;
		t.dir = null;
	};
	this.touchMove = function(ev) {
		if (t.isAct) {
			// quit if we have multiple touches
			// todo: handle special gesture for help panel / menu / toc and so on
			if (ev.touches.length > 1) {
				t.touchCancel();
			} else {
				// calculate the difference between the most recent touch coordinates and the previous ones
				t.diff = {
					x: ev.touches[0].pageX - t.last.x,
					y: ev.touches[0].pageY - t.last.y
				};
				t.last = {
					x: ev.touches[0].pageX,
					y: ev.touches[0].pageY
				};
				// set the dir ection value if needed
				if (t.dir === null) {
					t.dir = Math.abs(t.diff.x) > Math.abs(t.diff.y) ? 'x' : 'y';
				} else if (t.sign === null) {
					// set the sign value if needed
					t.sign = (t.diff[t.dir] < 0) ? -1 : 1;
				} else if (t.sign * t.diff[t.dir] < -20 || Math.abs(t.diff[t.dir == 'x' ? 'y' : 'x']) > 15) {
					// we do not want to catch rapid moves forth and back || shaky movements
					t.touchCancel();
				}
			}
		}
	};
	this.touchEnd = function(ev) {
		if (t.isAct) {
			var i;
			for (i in t.events) {
				if (t.events[i].check(t)) {
					t.events[i].fn(Kilauea.instances[t.id]);
				}
			}
			t.touchCancel();
		}
	};
	
	inst.container.addEventListener("touchstart", this.touchStart, false);
	inst.container.addEventListener("touchmove", this.touchMove, false);
	inst.container.addEventListener("touchend", this.touchEnd, false);
	inst.container.addEventListener("touchcancel", this.touchCancel, false);
	
});

Kilauea.plugins['http://sharpeleven.net/kilauea/iTouch'].prototype = {
	// add methods to the prototype...
}
