Kilauea.addPlugin('http://sharpeleven.net/kilauea/video', 'video', function(inst, params) {
	/**
	 * Class: http://sharpeleven.net/kilauea/video
	 *
	 * Utilities for HTML5 video objects.
	 *
	 * Parameters:
	 *   Currently, the video plugin doesn't need any parameters.
	 */
	this.revision = "$Id:$";
	this.id = inst.id;
	
	// register kilauea events
	inst.registerEvent('slideChange', this.slideChange, this);
	
});

Kilauea.plugins['http://sharpeleven.net/kilauea/video'].prototype = {
/*	prepare: function(t, inst) {
		var vs = Kilauea.getByClass(inst.container, 'playOnSlideEnter');
		console.debug(vs.length)
		for (i = 0; i < vs.length; i++) {
			vs[i].pause();
			vs[i].currentTime = 0;
			console.debug(vs[i]);
		}
	}, */
	slideChange: function(t, inst) {
		var i, vs = Kilauea.getByClass(inst.slides[inst.status.currentSlide].ref, 'playOnSlideEnter');
		for (i = 0; i < vs.length; i++) {
			vs[i].play();
		}
	}
};