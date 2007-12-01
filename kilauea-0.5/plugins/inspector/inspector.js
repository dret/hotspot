Kilauea.addPlugin('http://sharpeleven.net/kilauea/inspector', 'inspector', function(inst, params) {
		
	/**
	 * Class: http://sharpeleven.net/kilauea/inspector
	 * 
	 * A customizable inspector
	 * 
	 * Provides a customizable inspector which lets one inspect different JS / DOM properties of the loaded page, and of Kilauea itself.
	 * 
	 * Parameters:
	 * 
	 *   inst - The <Kilauea.Instance> for which the inspector instance is instantiated
	 *   params - a parameter object {updateOnSlideChange: <boolean:false>, withMethods: <boolean:false>, suspects: []}
	 * 
	 * The parameter object has the following possible properties
	 *   updateOnSlideChange - specifies whether the inspector's dlist shall be update on each slide change
	 *   withMethods - specifies whether object methods shall be listed as well
	 *   suspects - an array of elements to be included into the dlist. either an object reference or a string to be evaluated at runtime
	 */
	this.revision = "$Id: Url Author Rev Date Id Header $";
	
	this.id = inst.id;
	this.params = params || {};
	
	// build the panel
	this.panel = new Kilauea.Panel(this.build(inst), 'hidden', inst.embeddedMode, true);

	if (Kilauea.keyBound == inst.id) {
		// register a key handler for toggling the inspector panel
		Kilauea.registerKey('x', this.keyHandler, this, "X", "Toggle inspector (press shift for inspector refresh)");
	}
	// register a onSlideChange handler, if desired
	if (params.updateOnSlideChange) {
		inst.registerEvent('slideChange', this.rebuild, this);
	}
	// insert a toolbar entry
	inst.addToToolbarMenu(inst.getLink('inspector?', "Toggle inspector panel", this.panel.toggle, this.panel));
});

Kilauea.plugins['http://sharpeleven.net/kilauea/inspector'].prototype = {
	
	/* Method: keyHandler
	 * Parameters:
	 *   e - the event object
	 *   i - the instance that triggered the event
	 */
	keyHandler: function(e, i) {
		// if shift is pressed, a rebuild is initiated
		if (e.shiftKey) {
			this.build(i);
		} else {
			this.panel.toggle();
		}
	},
	
	rebuild: function(type, inst) {
		this.build(inst);
	},
	
	build: function(inst) {
		var inner, isp;
		if (this.panel) {
			isp = this.panel.ref;
			isp.removeChild(isp.firstChild);
		} else {
			isp = document.createElement('div');
			isp.className = "inspector";
			document.body.appendChild(isp);
			var dim = Kilauea.windowDimensions();
			// we have to show the panel for a second in order to trigger its rendering, otherwise the position is right = top = 0px.
			isp.style.visibility = 'visible';
			isp.style.display = 'block';
			isp.style.right = Kilauea.toInteger(Kilauea.getStyle(isp, 'right'), 100, dim.width) - (inst.id * 20) + "px";
			isp.style.top = Kilauea.toInteger(Kilauea.getStyle(isp, 'top'), 100, dim.height) + (inst.id * 20) + "px";
			isp.style.visibility = 'hidden';
			isp.style.display = 'none';
		}
		var inner = document.createElement('div');
		// build the title
		inner.appendChild(document.createElement('h3'));
		inner.lastChild.appendChild(document.createTextNode("Kilauea Inspector" + ((inst.isFullWindow) ? "" : " (" + (inst.id + 1) + ")")));
		// dlist Kilauea itself
		inner.appendChild(this.dlist(Kilauea, this.params.withMethods));
		// dlist all other suspects
		for (var i in this.params.suspects) {
			inner.appendChild(document.createElement('h3'));
			inner.lastChild.appendChild(document.createTextNode(i));
			if (typeof this.params.suspects[i] == 'string') {
				inner.appendChild(this.dlist(eval(this.params.suspects[i]), this.params.withMethods));
			} else {
				inner.appendChild(this.dlist(this.params.suspects[i], this.params.withMethods));
			}
		}
		isp.appendChild(inner);
		return isp;
	},
	
	dlist: function(obj, withMethods, j) {
		// some mimimal safety
		if (!j) j = 0;
		if (j == 50) return;
		
		var dl = document.createElement('dl');
		for (var i in obj) {
			dl.appendChild(document.createElement('dt'));
			dl.lastChild.innerHTML = i;
			dl.lastChild.onclick = new Function("this.nextSibling.style.display = (this.nextSibling.offsetHeight < 5 || this.nextSibling.style.display == 'none') ? 'block' : 'none';");
			var dd = document.createElement('dd');
			switch (typeof obj[i]) {
				case 'undefined':
					dd.innerHTML = '<em>undefined</em>';
					break;
				case 'object':
					if (obj[i] === null) {
						// yes, null is an object.
						dd.innerHTML = '<strong>null</strong>';
					} else if (obj[i].nodeType) {
						dd.innerHTML = '<span>' + obj[i].nodeName + ((obj[i].id) ? '#' + obj[i].id : (obj[i].className) ? '.' + obj[i].className : '') + '</span>';
					} else {
						dd.appendChild(this.dlist(obj[i], withMethods, j + 1));
						// (this doesn't work in IE: dd.setAttribute('class', 'collapsed'); )
						dd.className = 'collapsed';
					}
					break;
				case 'function':
					if (withMethods) {
						dd.innerHTML = '<a href="#">function</a>';
						try {
							dd.onclick = new Function("var popup = window.open('','printFunc','resize=yes,scrollbars=yes'); popup.document.write('<html><head></head><body><pre>' + '" + obj[i].toString().replace(/\'/g, '"').replace(/\r?\n/g, "'+\"\\n\"+'") + "' + '</pre></body></html>'); return false;");
						} catch(e) {}
					} else {
						// remove the dt node
						dl.removeChild(dl.lastChild);
					}
					break;
				case 'boolean':
					dd.innerHTML = (!obj[i]) ? '<strong>false</strong>' : '<strong>true</strong>';
					break;
				case 'string':
					dd.innerHTML = '<q>' + obj[i] + '</q>';
					break;
				default:
					dd.innerHTML = obj[i];
			}
			dl.appendChild(dd);
		}
		return dl;
	}
};