Kilauea.addPlugin('http://sharpeleven.net/kilauea/splitheader', 'splitheader', function(inst, params){
	
	/**
	 * Class: http://sharpeleven.net/kilauea/splitheader
	 * 
	 * Constructor Parameters:
	 *   inst - the <Kilauea.Instance> for which the plugin is instantiated
	 *   params - a parameter object {}
	 */
	this.revision = "$Id$";
	
	this.lists = {
		part: document.createElement('ul'),
		subpart: document.createElement('ul')
	};
	
	this.links = {};
	
	
	
	this.fields = {};
	
	this.active = {
		part: null,
		subpart: null
	};
	
	this.build(inst);
	
	inst.registerUpdater('partInfo', this.update, this);
	
	this.update('init', inst);
	
});

Kilauea.plugins['http://sharpeleven.net/kilauea/splitheader'].prototype = {
	
	build: function(inst) {
		// remove existing part info list
		var uls = inst.fields.partInfo.getElementsByTagName('ul');
		if (uls.length) {
			inst.fields.partInfo.removeChild(uls[0]);
			uls[0] = null;
		}
		
		inst.fields.partInfo.appendChild(document.createElement('table'));
		inst.fields.partInfo.lastChild.appendChild(document.createElement('tbody'));
		inst.fields.partInfo.lastChild.lastChild.appendChild(document.createElement('tr'));
		this.fields.right = document.createElement('td');
		this.fields.right.className = 'rightHeader';
		this.fields.right.appendChild(this.lists.subpart);
		this.fields.left = document.createElement('td');
		this.fields.left.className = 'leftHeader';
		this.fields.left.appendChild(this.lists.part);
		inst.fields.partInfo.lastChild.lastChild.lastChild.appendChild(this.fields.left);
		inst.fields.partInfo.lastChild.lastChild.lastChild.appendChild(this.fields.right);
		
		this.getPartList(this.lists.part, inst, 0, true);
	},
	
	
	getPartList: function(list, inst, partID, partsOnly) {
		var cur;
		for (var i = 0; i < inst.parts[partID].children.length; i++) {
			cur = inst.parts[partID].children[i];
			if (inst.parts[cur].children) {
				this.links[cur] = this.getPartItemLink(inst, cur);
				list.appendChild(document.createElement('li'));
				list.lastChild.appendChild(this.links[cur]);
			} else if (!partsOnly) {
				if (!Kilauea.hasClass(inst.slides[inst.parts[cur].slide].ref, 'outline')) {
					this.links["sl_" + inst.parts[cur].slide] = this.getPartItemLink(inst, cur);
					list.appendChild(document.createElement('li'));
					list.lastChild.appendChild(this.links["sl_" + inst.parts[cur].slide]);
				}
			}
		}
	},
	
	getPartItemLink: function(inst, partID) {
		var curPart = inst.parts[partID];
		if (curPart.children) {
			return inst.getLink(curPart.title, '', Kilauea.pageAddress() + '#' + curPart.href);
		} else {
			return inst.getLink(inst.slides[curPart.slide].title, '', Kilauea.pageAddress() + '#' + inst.slides[curPart.slide].anchor);
		}
	},
	
	update: function(t, inst) {
		var i, part, subpart;
		
		if (inst.current().partInfo.length == 2) {
			part = inst.current().partInfo[1];
			subpart = "sl_" + inst.current().id
		} else if (inst.current().partInfo.length > 2) {
			part = inst.current().partInfo[1];
			subpart = inst.current().partInfo[2];
		} else {
			part = 0;
			subpart = 0;
		}
		
		Kilauea.removeClass(this.active.part, 'active');
		Kilauea.removeClass(this.active.subpart, 'active');
		
		if (part) {
			Kilauea.addClass((this.active.part = this.links[part]), 'active');
		}
		
		// remove existing subpart information
		while (this.lists.subpart.childNodes.length) {
			this.lists.subpart.removeChild(this.lists.subpart.lastChild);
		}
		
		if (part) {
			this.getPartList(this.lists.subpart, inst, part, false);
		}
		
		if (subpart) {
			Kilauea.addClass((this.active.subpart = this.links[subpart]), 'active');
		}
		
		var pad = 0, h1s = inst.current().ref.getElementsByTagName('h1');
		if (h1s.length) {
//			pad = Kilauea.toInteger(Kilauea.getStyle(h1s[0], 'padding-top'), 40);
			h1s[0].style.paddingTop = inst.fields.partInfo.offsetHeight + pad + "px";
		} else {
//			pad = Kilauea.toInteger(Kilauea.getStyle(inst.current().ref, 'padding-top'), 40);
			inst.current().ref.style.paddingTop = inst.fields.partInfo.offsetHeight + pad + "px";
		}
		
	}
	
};
