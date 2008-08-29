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
	this.revision = "$Id$";
	
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
		// if there is a link to the next presentation, insert a hyperlink
		var ll = document.getElementsByTagName("head")[0].getElementsByTagName('link');
		for (i = 0; i < ll.length; i++) {
			if (ll[i].rel == 'next') {
				var p = document.createElement('p');
				p.appendChild(document.createTextNode('Proceed to presentation '));
				var next = document.createElement('a');
				next.appendChild(document.createTextNode(ll[i].title));
				next.href = ll[i].href;
				p.appendChild(document.createElement('q'));
				p.lastChild.appendChild(next);
				endSlide.appendChild(p);
				break;
			}
		}
		// make the endslide a slide
		Kilauea.addClass(endSlide, "slide");
		inst.slides.push(new Kilauea.Slide(endSlide, inst.slides.length, inst.id, []));
		inst.redraw();
	}
	
};