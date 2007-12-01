Kilauea.addPlugin('http://sharpeleven.net/kilauea/logger', 'logger', function(inst, params){
	
	/**
	 * Class: http://sharpeleven.net/kilauea/logger
	 * 
	 * Constructor Parameters:
	 *   inst - the <Kilauea.Instance> for which the plugin is instantiated
	 *   params - a parameter object {resultDestination: <'panel','popup':'panel'>, resultFormat: <'html','csv':'html'>, discardFastFlips: <boolean:false>, discardThreshold: <milliseconds:1500>, autoStart: <boolean:false>}
	 */
	this.revision = "$Id: logger.js 423 2007-09-28 12:56:20Z femichel $";
	
	this.id = inst.id;
	// Property: logData
	// An array which contains <LogEntries>.
	this.logData = [];
	this.menuItem = [null, null, null];
	this.startLink = inst.getLink('measure?', "Start a new measurement with the logger", this.start, this);
	this.pauseLink = inst.getLink('pause?', "Pause logging", this.pause, this);
	this.resumeLink = inst.getLink('resume?', "Resume logging", this.resume, this);
	this.stopLink = inst.getLink('stop?', "Stop logging", this.stop, this);
	this.evalLink = inst.getLink('evaluate?', "Evaluate logging results", this.evaluate, this);
	this.closeLink = inst.getLink('close?', "Close evaluation results", this.close, this);
	this.menuItem[0] = inst.addToToolbarMenu(this.startLink);
	
	this.resultWindow = null;
	this.resultPanel = null;
	
	// process the parameters
	this.resultFormat = params.resultFormat || 'html';
	this.resultDestination = params.resultDestination || 'panel';
	
	if (this.resultDestination == 'panel') {
		this.resultPanel = new Kilauea.Panel(Kilauea.getField(inst.container, 'kilaueaLoggerPanel'));
	}
	
	this.discardFastFlips = !!params.discardFastFlips;
	this.discardThreshold = params.discardThreshold || 1500; // milliseconds
	
	if (params.autoStart) {
		this.start();
	}
});

Kilauea.plugins['http://sharpeleven.net/kilauea/logger'].prototype = {
	/**
	 * Method: start
	 * 
	 * Starts a new measurement.
	 */
	start: function() {
		var inst = Kilauea.instances[this.id];
		
		this.closeResultPanel();
		
		if (this.menuItem[1]) {
			inst.removeFromToolbarMenu(this.menuItem[1]);
		}
		if (this.menuItem[2]) {
			inst.removeFromToolbarMenu(this.menuItem[2]);
			this.menuItem[2] = null;
		}
		this.menuItem[0] = inst.replaceInToolbarMenu(this.menuItem[0], this.pauseLink);
		this.menuItem[1] = inst.addToToolbarMenu(this.stopLink);
		
		delete this.logData;
		this.logData = [];
		
		this.log('start', inst);
		inst.registerEvent('slideChange', this.log, this);
	},
	
	/**
	 * Method: pause
	 * 
	 * Pauses measuring. The measurement can be resumed without any loss of log data. Evaluation is not possible while pausing, though.
	 */
	pause: function() {
		this.closeLastLog();
		
		var inst = this.getInstance();
		this.menuItem[0] = inst.replaceInToolbarMenu(this.menuItem[0], this.resumeLink);
		
		inst.unregisterEvent('slideChange', this.log, this);
	},
	
	/**
	 * Method: resume
	 * 
	 * Resumes measuring. This method is called either after pausing or stopping a measurement by calling <pause> or <stop>, respectively. In either case, the current measurement is continued, and no data is lost.
	 */
	resume: function() {
		var inst = this.getInstance();
		this.menuItem[0] = inst.replaceInToolbarMenu(this.menuItem[0], this.pauseLink);
		
		if (this.menuItem[2]) {
			// if the above is true, we resumed after this.evaluate
			this.closeResultPanel();
			this.menuItem[1] = inst.replaceInToolbarMenu(this.menuItem[1], this.stopLink);
			inst.removeFromToolbarMenu(this.menuItem[2]);
			this.menuItem[2] = null;
		}
		
		this.log('resume', inst);
		inst.registerEvent('slideChange', this.log, this);
	},
	
	/**
	 * Method: stop
	 * 
	 * Stops measuring. Once the measurement is stopped, evaluation wicht <evaluate> is possible.
	 */
	stop: function() {
		this.closeLastLog();
		
		var inst = this.getInstance();
		this.menuItem[0] = inst.replaceInToolbarMenu(this.menuItem[0], this.startLink);
		this.menuItem[1] = inst.replaceInToolbarMenu(this.menuItem[1], this.resumeLink);
		this.menuItem[2] = inst.addToToolbarMenu(this.evalLink);
		
		inst.unregisterEvent('slideChange', this.log, this);
	},
	
	/**
	 * Method: evaluate
	 * 
	 * Evaluates the current measurement and displays the results. This method can be called multiple times, for instance after calling <close>.
	 */
	evaluate: function() {
		var inst = this.getInstance();
		this.menuItem[2] = inst.replaceInToolbarMenu(this.menuItem[2], this.closeLink);
		
		this.openResultPanel();
	},
	
	
	/**
	 * Method: close
	 * 
	 * Closes the result panel or window. After closing the results, one can either <evaluate> or <resume> the current measurement again, or one can <start> a new measurement.
	 */
	close: function() {
		var inst = this.getInstance();
		this.menuItem[2] = inst.replaceInToolbarMenu(this.menuItem[2], this.evalLink);
		
		this.closeResultPanel();
	},
	
	// logging functions
	
	log: function(t, inst) {
		if (t == 'slideChange') {
			this.closeLastLog();
		}
		this.logData.push(new this.LogEntry(inst.current()));
	},
	
	closeLastLog: function() {
		if (this.logData.length) {
			this.logData[this.logData.length - 1].stop = this.now();
			if (this.discardFastFlips && this.logData[this.logData.length - 1].getDuration() < this.discardThreshold) {
				this.logData.pop();
			}
		}
	},
	
	/**
	 * Class: LogEntry
	 * 
	 * A log entry. This class is used for the data entries in logData.
	 * 
	 * Parameters:
	 *   slide - a <Kilauea.Slide>
	 */
	LogEntry: function(slide) {
		// Property: slide
		// The <Kilauea.Slide.id> of the slide passed in the construcor.
		this.slide = slide.id;
		// Property: start
		// A UNIX timestamp keeping the start time of this slide in milliseconds since 1970/1/1.
		
		// Property: stop
		// Equivalent to <start>, <stop> keeps the timestamp of the end time of this slide.
		this.start = this.stop = (new Date()).getTime();
		// Method: getDuration
		// Computes the time spent for viewing this slide; in milliseconds.
		this.getDuration = function() { return this.stop - this.start; };
	},
	
	// time functions
	
	now: function() {
		return (new Date()).getTime();
	},
	
	nice: function(millis) {
		var time = new Date(millis);
		return this.pad(time.getHours() - 1) + ':' + this.pad(time.getMinutes()) + ':' + this.pad(time.getSeconds());
	},
	
	pad: function(t) {
		return t < 10 ? '0' + t.toString() : t.toString();
	},
	
	// result panel functions
	
	openResultPanel: function() {
		if (this.resultDestination == 'popup') {
			// the destination is a popup window
			var url = Kilauea.pluginLocations[this.uri] + ((this.resultFormat == 'html') ? 'result.html?' + this.id : 'result.csv');
			// open a new popup window
			try {
				this.resultWindow = window.open(url, 'resultWindow', 'scrollbars=yes,resizable=yes');
			} catch(e) {
				alert("Cannot open popup window! An error occurred: " + e.toString());
				return;
			}
			if (!this.resultWindow) {
				alert("Cannot open popup window! (Most likely, your browser is set to block popups.)");
			}
		} else {
			// the destination is a dhtml panel
			this.resultPanel.show();
		}
		this.buildResults();
	},
	
	closeResultPanel: function() {
		if (this.resultDestination == 'popup') {
			if (this.resultWindow) {
				this.resultWindow.close();
				this.resultWindow = null;
			}
		} else {
			this.resultPanel.hide();
		}
	},
	
	notify: function() {
		// primarily a debug function
		alert(this.resultWindow.location.href);
		this.buildHTMLResults(this.resultWindow.document.body);
	},
	
	
	// evaluation methods
	
	buildResults: function() {
		if (this.resultDestination == 'panel') {
			if (this.resultFormat == 'html') {
				this.buildHTMLResults(this.resultPanel.ref);
			} else {
				this.buildCSVResults(this.resultPanel.ref);
			}
		} else {
			if (this.resultFormat == 'html') {
				// onload handler in result.html takes care of this
			} else {
				this.buildCSVResults(this.resultWindow);
			}
		}
	},
	
	buildCSVResults: function(parent) {
		var isHTML = (parent.nodeType == 1) ? true : false;
		var i, inst = this.getInstance(), fields = [];
		
		if (isHTML) {
			// remove existing content
			if (parent.firstChild) {
				parent.removeChild(parent.firstChild);
			}
			// create new div
			var results = Kilauea.getField(parent, 'loggerResults');
			// add a heading
			var h3 = document.createElement('h3');
			h3.appendChild(document.createTextNode("CSV Data"));
			results.appendChild(h3);
			// add a help text
			var p = document.createElement('p');
			p.appendChild(document.createTextNode("Copy and paste the results below:".localize(inst.lang)));
			results.appendChild(p);
			Kilauea.localization.parts.add(inst.id, p, inst.lang);
			// create a preformatted section
			var pre = document.createElement('pre');
		} else {
			// unfortunately, the arguments aren't supported by most browsers (it is a proprietary netscape thing).
			// therefore, most of the time the browser suggests to save the popup document under the presentation's name.
			parent.document.open("text/cvs", "replace");
		}
		// print out the results
		for (i = 0; i < this.logData.length; i++) {
			fields = [];
			
			fields.push((this.logData[i].slide + 1));
			fields.push('"' + inst.slides[this.logData[i].slide].title.replace(/\"/, "'") + '"');
			fields.push(this.logData[i].start);
			fields.push(this.logData[i].stop);
			fields.push(this.logData[i].getDuration());
			
			if (isHTML) {
				pre.appendChild(document.createTextNode(fields.join(',') + "\n"));
			} else {
				parent.document.writeln(fields.join(','));
			}
		}
		if (isHTML) {
			// add the preformatted section
			results.appendChild(pre);
			parent.appendChild(results);
		} else {
			parent.document.close();
			parent.document.title = "Kilauea Logger Results";
		}
	},
	
	buildHTMLResults: function(parent) {
		var i, j, inst = this.getInstance();
		
		// remove existing content
		if (parent.firstChild) {
			parent.removeChild(parent.firstChild);
		}
		// create new div
		var results = Kilauea.getField(parent, 'loggerResults');
		// create, fill, and localize the heading
		results.appendChild(document.createElement('h3'));
		results.lastChild.appendChild(document.createTextNode("Kilauea Logger Results".localize(inst.lang)));
		Kilauea.localization.parts.add(this.id, results.lastChild, inst.lang);
		
		// create, fill, and localize the "by slides" heading
		results.appendChild(document.createElement('h4'));
		results.lastChild.appendChild(document.createTextNode("By Visited Slides".localize(inst.lang)));
		Kilauea.localization.parts.add(this.id, results.lastChild, inst.lang);
		
		// build the slide table
		var table = document.createElement('table');
		var tableHead = document.createElement('thead');
		var tableBody = document.createElement('tbody');
		// insert table headings
		tableHead.appendChild(document.createElement('tr'));
		tableHead.lastChild.appendChild(document.createElement('th'));
		tableHead.lastChild.lastChild.appendChild(document.createTextNode('No'.localize(inst.lang)));
		tableHead.lastChild.appendChild(document.createElement('th'));
		tableHead.lastChild.lastChild.appendChild(document.createTextNode('Title'.localize(inst.lang)));
		tableHead.lastChild.appendChild(document.createElement('th'));
		tableHead.lastChild.lastChild.appendChild(document.createTextNode('Time'.localize(inst.lang)));
		table.appendChild(tableHead);
		// print out the results
		for (i = 0; i < this.logData.length; i++) {
			tableBody.appendChild(document.createElement('tr'));
			tableBody.lastChild.appendChild(document.createElement('td'));
			tableBody.lastChild.lastChild.appendChild(document.createTextNode(this.logData[i].slide + 1));
			
			tableBody.lastChild.appendChild(document.createElement('td'));
			if (this.resultDestination == 'popup') {
				tableBody.lastChild.lastChild.appendChild(document.createTextNode(inst.slides[this.logData[i].slide].title));
			} else {
				tableBody.lastChild.lastChild.appendChild(inst.getLink(inst.slides[this.logData[i].slide].title, '', Kilauea.pageAddress() + '#' + inst.slides[this.logData[i].slide].anchor));
			}
			
			tableBody.lastChild.appendChild(document.createElement('td'));
			tableBody.lastChild.lastChild.appendChild(document.createTextNode(this.nice(this.logData[i].getDuration())));
		}
		table.appendChild(tableBody);
		results.appendChild(table);
		
		
		// create, fill, and localize the "by parts" heading
		results.appendChild(document.createElement('h4'));
		results.lastChild.appendChild(document.createTextNode("By Parts".localize(inst.lang)));
		Kilauea.localization.parts.add(this.id, results.lastChild, inst.lang);
		
		// build the part table
		table = document.createElement('table');
		tableHead = document.createElement('thead');
		tableBody = document.createElement('tbody');
		// insert table headings
		tableHead.appendChild(document.createElement('tr'));
		tableHead.lastChild.appendChild(document.createElement('th'));
		tableHead.lastChild.lastChild.appendChild(document.createTextNode('Part'.localize(inst.lang)));
		tableHead.lastChild.appendChild(document.createElement('th'));
		tableHead.lastChild.lastChild.appendChild(document.createTextNode('Time'.localize(inst.lang)));
		table.appendChild(tableHead);
		// print out the parts
		var parts = this.getPart(0, 0);
		for (i = 0; i < parts.length; i++) {
			tableBody.appendChild(parts[i]);
		}
		table.appendChild(tableBody);
		results.appendChild(table);
		
		// register an unload handler for the popup
		if (this.resultDestination == "popup" && this.resultWindow) {
			Kilauea.addEvent(this.resultWindow, 'unload', new Function("e", this.thisString + ".close()"));
		}
	},
	
	getPart: function(partID, indent) {
		var i, j, inst = this.getInstance();
		
		var trs = [document.createElement('tr')];
		
		trs[0].appendChild(document.createElement('td'));
		for (j = 0; j < indent; j++) {
			trs[0].lastChild.appendChild(document.createElement('span'));
			if (Kilauea.browser.webkit) {
				trs[0].lastChild.lastChild.appendChild(document.createTextNode('.'));
			}
		}
		
		if (inst.parts[partID].children) {
			trs[0].lastChild.appendChild(document.createTextNode(inst.parts[partID].title));
			trs[0].className = "part";
			trs[0].lastChild.setAttribute("colspan", "2");
			
			for (i = 0; i < inst.parts[partID].children.length; i++) {
				trs = trs.concat(this.getPart(inst.parts[partID].children[i], indent + 1));
			}
			
			var total = document.createElement('tr');
			if (partID == 0) {
				total.className = "totaltotal";
			} else {
				total.className = "total";
			}
			total.appendChild(document.createElement('td'));
			total.lastChild.className = "total";
			total.lastChild.appendChild(document.createTextNode("Total for ".localize(inst.lang) + inst.parts[partID].title));
			total.appendChild(document.createElement('td'));
			total.lastChild.appendChild(document.createTextNode(this.nice(this.sumDurations(inst.parts[partID].children))));
			trs.push(total);
		} else {
			if (this.resultDestination == 'popup') {
				trs[0].lastChild.appendChild(document.createTextNode(inst.slides[inst.parts[partID].slide].title));
			} else {
				trs[0].lastChild.appendChild(inst.getLink(inst.slides[inst.parts[partID].slide].title, '', Kilauea.pageAddress() + '#' + inst.slides[inst.parts[partID].slide].anchor));
			}
			trs[0].appendChild(document.createElement('td'));
			trs[0].lastChild.appendChild(document.createTextNode(this.nice(this.sumDurations([partID]))));
		}
		return trs;
	},
	
	getSlides: function(partID) {},
	
	sumDurations: function(IDs) {
		var i, j, sum = 0;
		var inst = this.getInstance();
		
		for (i = 0; i < IDs.length; i++) {
			if (inst.parts[IDs[i]].children) {
				sum += this.sumDurations(inst.parts[IDs[i]].children);
			} else {
				for (j = 0; j < this.logData.length; j++) {
					if (inst.parts[IDs[i]].slide == this.logData[j].slide) {
						sum += this.logData[j].getDuration();
					}
				}
			}
		}
		return sum;
	}
	
};