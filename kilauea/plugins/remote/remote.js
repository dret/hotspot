Kilauea.addPlugin('http://sharpeleven.net/kilauea/remote', 'remote', function(inst, params) {
	
	/**
	 * Class: http://sharpeleven.net/kilauea/remote
	 *
	 * Remote presentations
	 *
	 * Requires kilaueaRemote.php to be installed on the server side. 
	 *
	 * Constructor Parameters:
	 *   serverURL - the URL of kilaueaRemote.php on the server side. By default, the plugin assumes the PHP to be residing in the same directory. Note that due to security constraints on XMLHttpRequest, the PHP cannot be in a different domain than the HTML. 
	 */
	this.revision = "$Id$";
	
	this.id = inst.id;
		
	this.initXHR();
	if (params.serverURL) {
		this.setAddress(params.serverURL)
	} else {
		this.setAddress('KilaueaRemote.php')
	}
	this.setupPanels(inst);
		
	// insert toolbar entry

	inst.menus.toolbar.addSubmenu('http://sharpeleven.net/kilauea/remote', inst.getLink('remote', "Control remote sessions", function(){}));
	inst.menus.toolbar.submenus['http://sharpeleven.net/kilauea/remote'].addEntry(inst.getLink('remote?', "Toggle remote panel", this.panel.toggle, this.panel));

	inst.registerEvent('slideChange', this.reportShowSlide, this);
	inst.registerEvent('incrementalChange', this.reportShowSlide, this);
	
	Kilauea.addEvent(this.pointer.ref, 'mouseup', this.onDrop);
	
	if (inst.id == Kilauea.keyBound) {
		Kilauea.registerKey('R', this.panel.toggle, this.panel, "R", "Toggle remote panel");
		Kilauea.registerKey('X', this.togglePointer, this, "X", "Toggle pointer arrow");
	}
});

Kilauea.plugins['http://sharpeleven.net/kilauea/remote'].prototype = {
	http: null,
	address: '',
	role: '',
	active: false,
	sessionID: '',
	sessions: null,
	panel: null,
	fields: {start: null, stop: null, select: null, list: null, status: null, tools: null},
	pointer: null,
	
	initXHR: function() {
		this.http = Kilauea.getXHR();
		if (this.http === null) {
			alert('no HTTP object');
			return false;
		} else {
			return true;
		}
	},
	
	setupPanels: function(inst) {
		var h = document.createElement('h3');
		h.appendChild(document.createTextNode('Remote Panel'.localize(inst.lang)));
		Kilauea.localization.parts.add(inst.id, h, inst.lang);
		h.className = "handle";
		// the remote panel itself
		this.panel = new Kilauea.Panel(Kilauea.getField(inst.container, 'kilaueaRemotePanel', h), 'hidden', inst.embeddedMode, true);
		// the start section
		var createLink = inst.getLink("create session", "Create a new remote session", this.switchOn, this, ['master']);
		var joinLink = inst.getLink("join session", "Join an existing remote session", this.switchOn, this, ['slave']);
		this.fields.start = Kilauea.getField(this.panel.ref, 'kilaueaRemoteStart', createLink, joinLink);
		// the stop section
		this.fields.stop = Kilauea.getField(this.panel.ref, 'kilaueaRemoteStop');
		this.fields.status = Kilauea.getField(this.fields.stop, 'text', "");
		Kilauea.localization.parts.add(inst.id, this.fields.status, inst.lang);
		this.fields.stop.appendChild(inst.getLink("quit session", "Quit the current remote session", this.switchOff, this));
		// the session list
		h = document.createElement('h3');
		h.appendChild(document.createTextNode('Available Sessions'.localize(inst.lang)));
		Kilauea.localization.parts.add(inst.id, h, inst.lang);
		this.fields.select = Kilauea.getField(this.panel.ref, 'kilaueaRemoteSelect', h);
		this.fields.list = Kilauea.getField(this.fields.select, '');
		// setup the pointer panel
		this.pointer = new Kilauea.Panel(Kilauea.getField(inst.container, 'kilaueaRemotePointer'), 'hidden', inst.embeddedMode, true);
		Kilauea.addClass(this.pointer.ref, 'kilaueaRemoteID:' + inst.id);
	},
	
	setAddress: function(addr) {
		this.address = addr;
	},
	
	send: function(arg) {
		this.http.open('GET', this.address + '?' + arg, true);
		this.http.onreadystatechange = new Function("e", this.thisString + ".receive()");
		try {
			this.http.send(null);
		} catch(e) {}
	},
	
	receive: function(e) {
		try {
			if (this.http.readyState == 4) {
				switch(this.http.status) {
					case 200:
					case 201:
						var r = null;
						try {
							if (!this.http.responseText) {
								throw new Error("empty response");
							}
							r = eval('(' + this.http.responseText + ')');
						} catch(e) {
							this.resume(e);
						}
						this.dispatchResponse(r);
						break;
					case 204:
						break;
					case 304:
						this.poll();
						break;
					case 408:
					default:
						alert('Error: ' + this.http.status + ' (' + this.http.responseText + ')');
						this.reset();
						return false;
				}
			}
		} catch(e) {
			alert('The receive function threw an error: ' + e.toString());
		}
	},
	
	resume: function(e) {
		if (this.role == 'slave') {
			this.poll();
		} else {
			if (!this.active) {
				alert("Could not create a new session.");
			}
		}
	},
	
	dispatchResponse: function(response) {
		if (this.active) {
			if (this.role == 'slave') {
				this.showSlide(response);
				this.poll();
			} else {
				// maybe a client list someday?
			}
		} else {
			this.sessions = response;
			if (this.role == 'master') {
				for(var i in this.sessions) {
					this.select(i, 'master');
				}
			} else if (this.role == 'slave') {
				this.printSelection();
			} else if (this.role == 'zombie') {
				this.unselect();
			}
		}
	},
	
	showSlide: function(status) {
		if (this.role == 'slave' && this.active) {
			Kilauea.instances[this.id].showSlide(status.pos, status.inc);
			if (status.pointer) {
				var coords = this.pointerCoords(status);
				this.pointer.ref.style.left = coords[0];
				this.pointer.ref.style.top = coords[1];
				this.pointer.show();
			} else {
				this.pointer.hide();
			}
		}
	},
	
	poll: function() {
		if (this.role == 'slave' && this.active) {
			this.send('m=0&' + this.buildQuery() + '&x=' + Math.random().toString().substring(2, 7));
		} else if (this.role == 'zombie') {
			this.unselect();
		}
	},
	
	reportShowSlide: function() {
		if (this.role == 'master' && this.active) {
			this.send('m=1&' + this.buildQuery());
		}
	},
	
	buildQuery: function() {
		var q = 'p=' + Kilauea.instances[this.id].status.currentSlide + '&v=' + Kilauea.instances[this.id].status.currentIncremental + '&i=' + this.sessionID;
		if (this.pointer.status != 'hidden') {
			var coords = this.pointerCoords();
			q = q + '&c=' + coords[0] + ',' + coords[1];
		}
		return q;
	},
	
	switchOn: function(role) {
		if (this.active) {
			alert(this.sessionID);
		} else {
			if (role == 'master') {
				this.role = 'master';
				var name = window.prompt("Enter a session name:".localize(this.getInstance().lang));
				if (name == null) {
					return;
				} else if (name == '') {
					alert("Please specify a name.".localize(this.getInstance().lang));
				} else {
					this.send('m=1&a=new&n=' + name + '&p=' + Kilauea.instances[this.id].status.currentSlide + '&v=' + Kilauea.instances[this.id].status.currentIncremental);
				}
			} else {
				this.role = 'slave';
				this.send('m=0&a=list');
			}
		}
	},
	
	switchOff: function() {
		this.active = false;
		this.fields.status.firstChild.nodeValue = "Disconnecting...";
		if (this.role == 'master') {
			this.send('m=1&a=shutdown&i=' + this.sessionID);
//		} else {
//			this.unselect()
		}
		this.role = "zombie";
	},
	
	select: function(s, m) {
		this.active = true;
		this.sessionID = s;
		if (m == 'master') {
			this.role = 'master';
			this.fields.status.firstChild.nodeValue = "You are leading session".localize(this.getInstance().lang) + " '" + this.sessions[s].name + "' (" + s + ")";
			this.reportShowSlide();
		} else {
			this.role = 'slave';
			this.fields.status.firstChild.nodeValue = "You are connected to".localize(this.getInstance().lang) + " '" + this.sessions[s].name + "' (" + s + ")";
			Kilauea.removeClass(this.pointer.ref, 'draggable');
			this.poll();
		}
		this.fields.start.style.display = 'none';
		this.fields.stop.style.display = 'block';
		this.fields.select.style.display = 'none';
	},
	
	unselect: function() {
		this.sessionID = '';
		this.role = '';
		this.fields.status.firstChild.nodeValue = "Disconnected";
		this.fields.start.style.display = 'block';
		this.fields.stop.style.display = 'none';
		Kilauea.addClass(this.pointer.ref, 'draggable');
	},
	
	reset: function() {
		this.active = false;
		this.sessions = null;
		this.unselect();
	},
	
	printSelection: function() {
		var i, tmpnode, tmptext;
		this.fields.list.innerHTML = "";
		for(i in this.sessions) {
			Kilauea.getField(this.fields.list, '', Kilauea.instances[this.id].getLink(this.sessions[i].name + " (" + i + ")", "currently at position " + (this.sessions[i].pos + 1), this.select, this, [i]));
		}
		this.fields.select.style.display = 'block';
	},
	
	pointerCoords: function(status) {
		if (status) {
			return new Array(status.pointer.x / 100 * this.getInstance().canvas.width + 'px', status.pointer.y / 100 * this.getInstance().canvas.height + 'px');
		} else {
			return new Array(Math.round(Kilauea.toInteger(Kilauea.getStyle(this.pointer.ref, 'left'), 0) / this.getInstance().canvas.width * 100), Math.round(Kilauea.toInteger(Kilauea.getStyle(this.pointer.ref, 'top'), 0) / this.getInstance().canvas.height * 100));
		}
	},
	
	togglePointer: function() {
		if (this.role != 'slave') {
			if (this.pointer.status == 'hidden') {
				this.showPointer();
			} else {
				this.hidePointer();
			}
		}
	},
	
	hidePointer: function() {
		this.pointer.hide();
		this.reportShowSlide();
	},
	
	showPointer: function() {
		this.pointer.show();
		this.reportShowSlide();
	},

	onDrop: function(e) {
		if (this.className) {
			var res = (new RegExp("\\bkilaueaRemoteID:(\\d+)\\b")).exec(this.className);
			if (res.length > 1) {
				Kilauea.instances[res[1]].plugins['http://sharpeleven.net/kilauea/remote'].reportShowSlide();
			}
		}
	}
};