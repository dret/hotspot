Kilauea.addPlugin('http://sharpeleven.net/kilauea/doublescreen', 'doublescreen', function(inst, params) {
	
	// params: {autoOpen: <boolean:false>, menu: <boolean:true>, toolbar: <boolean:true>, disableDependent: <boolean:false>, coupleScroll: <boolean:false>}
	
	/**
	 * Class: http://sharpeleven.net/kilauea/doublescreen
	 *
	 * Presentator mode
	 * 
	 * 
	 *
	 * Constructor Parameters:
	 *   toolbar - whther the mirrored screen shows toolbars
	 */
	this.revision = "$Id$";
	
	this.id = inst.id;
	this.role = '';
	this.screen = null;
	this.timer = null;
	this.closeLink = null;
	this.openLink = null;
	this.menuItem = null;
	
	if (window.opener) {
		this.role = 'slave';
		// add an unlaod event handler
		Kilauea.addEvent(window, 'unload', new Function("e", "Kilauea.instances[" + inst.id + "].plugins['http://sharpeleven.net/kilauea/doublescreen'].reportClose()"));
		// set the slave presentation's status to the master presentation's status 
		inst.showSlide(window.opener.Kilauea.instances[this.id].status.currentSlide, window.opener.Kilauea.instances[this.id].status.currentIncremental);
		// process the parameters
		if (!params.toolbar) {
			inst.panels.toolbar.hide();
			inst.panels.partInfo.hide();
		}
		if (params.disableDependent || params.castrateSlave) {
			if (inst.id == Kilauea.keyBound) {
				Kilauea.removeEvent(document, 'keydown', Kilauea.handleKey);
			}
			if (inst.status.click) {
				inst.toggleClick();
			}
		}
		if (params.coupleScroll) {
			// it is more stable to do this by polling in the slave than to use onscroll events in the master (scrolling back to 0,0 doesn't trigger onscroll)
			if (inst.isFullWindow) {
				this.timer = setInterval(this.adaptScroll, 70);
			}
		}
	} else {
		this.role = 'master';
		if (typeof params.menu == 'undefined' || params.menu !== false) {
			this.closeLink = inst.getLink('close?', "Close mirror screen", this.closeScreen, this);
			this.openLink = inst.getLink('open?', "Open a mirror screen", this.openScreen, this);
			this.menuItem = inst.addToToolbarMenu(this.openLink);
		}
		if (params.autoOpen) {
			this.openScreen();
		}
	}
});

Kilauea.plugins['http://sharpeleven.net/kilauea/doublescreen'].prototype = {
	mirror: function(t, inst) {
		if (this.screen.Kilauea) {
			this.screen.Kilauea.instances[this.id].showSlide(inst.status.currentSlide, inst.status.currentIncremental);
		}
	},
	
	openScreen: function() {
		try {
			this.screen = window.open(Kilauea.pageAddress(), 'screen' + this.id, "dependent=yes,resizable=yes,scrollbars=yes");
		} catch (e) {
			alert("Cannot open popup window! An error occurred: " + e.toString());
			return;
		}
		if (!this.screen) {
			alert("Cannot open popup window! (Most likely, your browser is set to block popups.)");
			return;
		}
		if (Kilauea.browser.webkit) {
			setTimeout("Kilauea.instances[" + this.id + "].plugins['http://sharpeleven.net/kilauea/doublescreen'].screen.location.href='" + Kilauea.pageAddress() + "'", 100);
		}
		var inst = Kilauea.instances[this.id];
		inst.registerEvent('slideChange', this.mirror, this);
		inst.registerEvent('incrementalChange', this.mirror, this);
		if (this.menuItem) {
			this.menuItem = inst.replaceInToolbarMenu(this.menuItem, this.closeLink);
		}
	},
	
	closeScreen: function() {
		var inst = Kilauea.instances[this.id];
		if (this.screen) {
			inst.unregisterEvent('slideChange', this.mirror);
			inst.unregisterEvent('incrementalChange', this.mirror);
			try {
				this.screen.close();
			} catch (e) {}
			delete this.screen;
		}
		if (this.menuItem) {
			this.menuItem = inst.replaceInToolbarMenu(this.menuItem, this.openLink);
		}
	},
	
	reportClose: function() {
		if (window.opener && window.opener.Kilauea) {
			window.opener.Kilauea.instances[this.id].plugins['http://sharpeleven.net/kilauea/doublescreen'].closeScreen();
		}
	},
	
	adaptScroll: function() {
		var i = window.opener;
		if(i) {
			if (typeof window.pageYOffset != 'undefined') {
				window.scrollTo(i.pageXOffset, i.pageYOffset);
			} else {
				if (i.document.documentElement) {
					window.scrollTo(i.document.documentElement.scrollLeft, i.document.documentElement.scrollTop);
				} else {
					window.scrollTo(i.document.body.scrollLeft, i.document.body.scrollTop);
				}
			}
			// TODO: write code for embedded presentations using scrollLeft / scrollTop
		}
	}
};