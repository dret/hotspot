Kilauea.addPlugin('http://sharpeleven.net/kilauea/endslide', 'endslide', function(inst, params) {
	
	/**
	 * Class: http://sharpeleven.net/kilauea/endslide
	 *
	 * Adds an end slide
	 * 
	 *  
	 *
	 * Constructor Parameters:
	 *   Endslide does not take any parameters
	 */
	this.revision = "$Id: endslide.js 410 2007-09-26 23:43:35Z femichel $";
	
	this.build(inst);
	inst.registerEvent('slideChange', this.check, this);
	
});

Kilauea.plugins['http://sharpeleven.net/kilauea/endslide'].prototype = {
	check: function(t, inst) {
		if (inst.status.eos) {
			this.show(inst);
		} else if (inst.history.last == inst.slides.length - 1) {
			this.hide(inst);
		}
	},
	
	show: function(inst) {
		inst.slides[inst.slides.length - 2].show();
		inst.slides[inst.slides.length - 1].show();
	},
	
	hide: function(inst) {
		if (inst.status.currentSlide != inst.slides.length - 2) {
			inst.slides[inst.slides.length - 2].hide();
		}
		inst.slides[inst.slides.length - 1].hide();
	},
	
	build: function(inst) {
		var h1 = document.createElement('h1');
		h1.appendChild(document.createTextNode('Last Slide of the Presentation'));
		var endSlide = Kilauea.getField(inst.container, 'kilaueaEndSlide', h1);
		Kilauea.addClass(endSlide, "slide");
		inst.slides.push(new Kilauea.Slide(endSlide, inst.slides.length, inst.id, []));
		inst.redraw();
	}
	
};