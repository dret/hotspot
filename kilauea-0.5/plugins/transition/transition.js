Kilauea.addPlugin('http://sharpeleven.net/kilauea/transition', 'transition', function(inst, params) {

	/**
	 * Class: http://sharpeleven.net/kilauea/transition
	 *
	 * Slide transitions
	 * 
	 * Provides some basic support for slide transitions, including the possibility to extend the functionality by adding custom transitions via <addTransition>. Besides providing some fancy trasitions, this plugin may serve as a template and starting point for further transition plugins, which might want to build upon an advanced Javascript library such as mochikit or script.aculo.us. 
	 *
	 * Constructor Parameters:
	 *   defaultTransition - the default slide transition. This parameter defaults to <flip>. 
	 */
	this.revision = "$Id: Url Author Rev Date Id Header $";
	
	inst.registerEvent('slideChange', this.change, this);
	inst.isExternalTransition = true;
	
	this.defaultTransition = params.defaultTransition || 'flip';
	
	// fill built-in transitions
	this.addTransition('flip', this.flip);
	this.addTransition('fade', this.fade, this.defade);
	
});

Kilauea.plugins['http://sharpeleven.net/kilauea/transition'].prototype = {
	
	// Property: transitions
	// Stores all available transitions. Contains pairs of transition name and function pointer. Used by <getTransition>, and filled by <addTransition>. 
	transitions: {},
	
	restorers: {},
	
	/**
	 * Method: getTransition
	 * 
	 * Takes a transition name and returns the associated transition function, or the default transition. 
	 * 
	 * Parameters:
	 *   tr - the transition name
	 * 
	 * Returns:
	 *   The matching transition function, or the <defaultTransition> otherwise. 
	 */
	getTransition: function(tr) {
		if (typeof this.transitions[tr] == 'function') {
			return this.transitions[tr];
		} else {
			return this.flip;
		}
	},
	
	restoreTransition: function() {
		if (typeof this.restorers[this.currentTransition] == 'function') {
			this.restorers[this.currentTransition].call(this);
		}
	},
	
	/**
	 * Method: addTransition
	 * 
	 * Adds a transition to <transitions>. 
	 * 
	 * Parameters:
	 *   name - the transition's name, e.g. 'mosaic'
	 *   fun - the transition function
	 *   rest - a restore function
	 * 
	 * Returns:
	 *   *True*, if the insertions was successful, *false* otherwise. 
	 */
	addTransition: function(name, fun, rest) {
		if (typeof rest == 'function') {
			this.restorers[name] = rest;
		}
		if (typeof fun == 'function') {
			this.transitions[name] = fun;
			return true;
		} else {
			return false;
		}
	},
	
	/**
	 * Method: determineTransition
	 * 
	 * Determines the desired transition for a given <Kilauea.Slide> by looking at the slide's class attributes. 
	 * 
	 * Parameters:
	 *   slide - a <Kilauea.Slide>
	 * 
	 * Returns:
	 *   The matching transition function, or the <defaultTransition> otherwise. 
	 */
	determineTransition: function(slide) {
		if (slide.ref.className) {
			var result = /\btransition:(\w+)\b/.exec(slide.ref.className);
			if (result && result.length > 1) {
				return result[1];
			}
		}
		return this.defaultTransition;
	},
	
	change: function() {
		var inst = this.getInstance();
		
		if (this.currentTransition) {
			this.clearTimer();
			this.restoreTransition();
		}
		
		this.outSlide = inst.slides[inst.history.last];
		this.inSlide = inst.current();
		
		if (this.outSlide && this.inSlide) {
			this.currentTransition = this.determineTransition(this.inSlide);
			this.getTransition(this.currentTransition).call(this);
		}
	},
	
	/* BUILT-IN TRANSITIONS */
	
	defade: function() {
		this.outSlide.ref.style.opacity = this.originalOpacity.outSlide;
		this.inSlide.ref.style.opacity = this.originalOpacity.inSlide;
		this.outSlide.hide();
	},
	
	// Method: flip
	// The most basic slide transition, which is hiding the old, and displaying the new slide. This mimics the behaviour of <Kilauea> without the tranition plugin. 
	flip: function() {
		this.outSlide.hide();
		this.inSlide.show();
	},
	
	// Method: fade
	// Transition by fading out the old, and fading in the new slide. Uses <dim> in order to change the opacity of the <Kilauea.Slide.ref>. 
	fade: function() {
		var inst = this.getInstance();
		
		this.originalOpacity = {};
		this.originalOpacity.inSlide = Kilauea.toFloat(Kilauea.getStyle(this.inSlide, 'opacity'), 1.0);
		this.originalOpacity.outSlide = Kilauea.toFloat(Kilauea.getStyle(this.outSlide, 'opacity'), 1.0);
		
		this.inSlide.ref.style.opacity = '0.0';
		this.inSlide.show();
		this.outSlide.ref.style.opacity = '1.0';
		this.setTimer('dim');
	},
	
	dim: function() {
		var op = parseFloat(this.outSlide.ref.style.opacity) - 0.08;
		if (op > 0) {
			this.outSlide.ref.style.opacity = op;
			this.inSlide.ref.style.opacity = (1.0 - op);
		} else {
			this.outSlide.ref.style.opacity = 0;
			this.inSlide.ref.style.opacity = 1.0;
			this.clearTimer();
			this.outSlide.hide();
		}
	},
	
	setTimer: function(fn, args) {
		args = args || [];
		this.clearTimer();
		this.timer = setInterval(this.thisString + "." + fn + "(" + args.join(',') + ")", 10);
	},
	
	clearTimer: function() {
		if (this.timer) {
			clearInterval(this.timer);
		}
	}
};