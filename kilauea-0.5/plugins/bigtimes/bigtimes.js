Kilauea.addPlugin('http://sharpeleven.net/kilauea/bigtimes', 'bigtimes', function(inst, params) {
	/**
	 * Class: http://sharpeleven.net/kilauea/bigtimes
	 *
	 * Provides a stop watch panel which shows watches measuring the time past per slide and presentation
	 *
	 * Parameters:
	 *   Bigtimes doesn't need any parameters.
	 */
	this.revision = "$Id$";
	this.slideStart = this.presStart = (new Date()).getTime();
	this.timer = null;
	this.id = inst.id;
	
	this.panel = new Kilauea.Panel(Kilauea.getField(inst.container, 'bigtimesPanel'), 'hidden', inst.embeddedMode, true);
	this.presPanel = Kilauea.getField(this.panel.ref, 'bigtimesPresPanel', "00:00:00");
	this.countPanel = Kilauea.getField(this.panel.ref, 'bigtimesCountPanel', (inst.status.currentSlide + 1) + '/' + inst.slides.length);
	this.slidePanel = Kilauea.getField(this.panel.ref, 'bigtimesSlidePanel', "00:00:00");
	
	// insert toolbar entries
	inst.addToToolbarMenu(inst.getLink('stopwatch', "Toggle stop watch panel", this.toggle, this));
	inst.addToToolbarMenu(inst.getLink('(reset)?', "Reset stop watch", this.reset, this));
	
	// register kilauea events
	inst.registerEvent('slideChange', this.update, this);
	
	// register key command
	if (inst.id == Kilauea.keyBound) {
		// unfortunately, 0 triggers zooming in in opera
		Kilauea.registerKey(48, this.toggle, this, "0 (Zero)", "Toggle stop watch panel");
	}
});

Kilauea.plugins['http://sharpeleven.net/kilauea/bigtimes'].prototype = {
	display: function () {
		var now = (new Date()).getTime();
		var presTime = new Date(now - this.presStart);
		var slideTime = new Date(now - this.slideStart);
		this.presPanel.firstChild.nodeValue = this.format(presTime);
		this.slidePanel.firstChild.nodeValue = this.format(slideTime);
		// hack in order to trigger correct rendereing in IE
		if (Kilauea.browser.ie) {
			this.panel.hide();
			this.panel.show();
		}
	},
	
	update: function(t, inst) {
		this.countPanel.firstChild.nodeValue = (inst.status.currentSlide + 1) + '/' + inst.slides.length;
		this.slideStart = (new Date()).getTime();
	},
	
	start: function() {
		if (!this.timer) {
			this.timer = window.setInterval(this.thisString + ".display();", 200);
		}
	},
	
	stop: function() {
		if (this.timer) {
			window.clearInterval(this.timer);
			this.timer = null;
		}
	},
	
	reset: function() {
		this.stop();
		this.slideStart = this.presStart = (new Date()).getTime();
		this.start();
	},
	
	toggle: function() {
		if (this.timer) {
			this.stop();
			this.panel.hide();
		} else {
			this.start();
			this.panel.show();
		}
	},
	
	format: function(time) {
		return this.pad(time.getHours() - 1) + ':' + this.pad(time.getMinutes()) + ':' + this.pad(time.getSeconds());
	},
	
	pad: function(t) {
		return t < 10 ? '0' + t.toString() : t.toString();
	}
};