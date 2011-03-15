Kilauea.addPlugin('http://sharpeleven.net/kilauea/draw', 'draw', function(inst, params) {
	/**
	 * Class: http://sharpeleven.net/kilauea/draw
	 *
     * http://www.permadi.com/blog/2009/05/using-html-5-canvas-to-draw
     * 
	 * Provides the possibility to draw onto a slide
	 *
	 * Parameters:
	 *   draw doesn't need any parameters.
	 */
	this.revision = "";
	this.id = inst.id;
	this.canvasContainer;
	this.superContainer;

	// insert submenu and its entries
	inst.menus.toolbar.addSubmenu('http://sharpeleven.net/kilauea/draw', inst.getLink('draw', "Control drawing", function(){}));
	inst.menus.toolbar.submenus['http://sharpeleven.net/kilauea/draw'].addEntry(inst.getLink('overlay', "Toggle overlay drawing", this.createCanvases0, this));
	inst.menus.toolbar.submenus['http://sharpeleven.net/kilauea/draw'].addEntry(inst.getLink('scratch', "Toggle drawing scratchpad",this.createCanvases1, this));

	// get the toolbar from CSS
	this.drawToolbar = new Kilauea.Panel(Kilauea.getField(inst.container, 'kilaueaDrawingPanel'), 'hidden', inst.embeddedMode, false);

	// register kilauea events
	inst.registerEvent('slideChange', this.slideChange, this);

	// register key command
	if (inst.id == Kilauea.keyBound) {
		// unfortunately, 0 triggers zooming in in opera
		Kilauea.registerKey(68, this.toggleOverlay, this, "D", "Turn on/off drawing");
		Kilauea.registerKey(88, this.toggleScratch, this, "X", "Turn on/off scratchpad");
	}
});

Kilauea.plugins['http://sharpeleven.net/kilauea/draw'].prototype = {

	createCanvases0: function ()
	{
		createCanvases(0);
	},
	
	createCanvases1: function ()
	{
		createCanvases(1);
	},
	
	createCanvases: function (a)
	{
		if (!this.myCanvas)
		{
			if (!this.canvasContainer)
			{
				this.canvasContainer = document.createElement('div');
                this.canvasContainer.id = 'drawingCanvasContainerID';
				document.body.appendChild(this.canvasContainer);
				this.canvasContainer.style.position="absolute";
				this.canvasContainer.style.left="0px";
				this.canvasContainer.style.top="0px";
				this.canvasContainer.style.width="100%";
				this.canvasContainer.style.height="100%";
				this.canvasContainer.style.zIndex="1000";
                this.canvasContainer.style.visibility='visible';
				this.superContainer=document.body;
			}
			else
				this.superContainer=this.canvasContainer;
		
			// Part of block below is inspired by code from Google excanvas.js
			{
			this.overlayCanvas = document.createElement('canvas');
			this.overlayCanvas.id = 'overlayCanvasID';
			this.overlayCanvas.style.width = this.superContainer.scrollWidth+"px";
			this.overlayCanvas.style.height = this.superContainer.scrollHeight+"px";
			// You must set this otherwise the canvas will be streethed to fit the container
			this.overlayCanvas.width = this.superContainer.scrollWidth;
			this.overlayCanvas.height = this.superContainer.scrollHeight;
			//surfaceElement.style.width=window.innerWidth;
			this.overlayCanvas.style.overflow = 'visible';
			this.overlayCanvas.style.position = 'absolute';
			}

			{
			this.scratchCanvas = document.createElement('canvas');
			this.scratchCanvas.id = 'scratchCanvasID';
			this.scratchCanvas.style.width = this.superContainer.scrollWidth+"px";
			this.scratchCanvas.style.height = this.superContainer.scrollHeight+"px";
			// You must set this otherwise the canvas will be streethed to fit the container
			this.scratchCanvas.width = this.superContainer.scrollWidth;
			this.scratchCanvas.height = this.superContainer.scrollHeight;
			//surfaceElement.style.width=window.innerWidth;
			this.scratchCanvas.style.overflow = 'visible';
			this.scratchCanvas.style.position = 'absolute';
			}

			this.canvasContainer.addEventListener('mousemove', this.onMouseMoveOnMyCanvas, false);
			this.canvasContainer.addEventListener('mousedown', this.onMouseDownOnMyCanvas, false);
			this.canvasContainer.addEventListener('mouseup', this.onMouseUpOnMyCanvas, false);

			// set background and line style/color
			var overlayContext=this.overlayCanvas.getContext('2d');
			overlayContext.fillStyle = 'rgba(0,0,0,0)'; // transparent
			overlayContext.fillRect(0,0, this.overlayCanvas.width, this.overlayCanvas.height);
			this.canvasContainer.appendChild(this.overlayCanvas);
			overlayContext.lineWidth = 3;
			overlayContext.strokeStyle = 'rgb(255,0,0,255)';

			// set background and line style/color
			var scratchContext=this.scratchCanvas.getContext('2d');
            scratchContext.fillStyle = 'rgba(255,255,255,255)'; // white, non-transparent
            scratchContext.fillRect(0,0, this.scratchCanvas.width, this.scratchCanvas.height);
            this.canvasContainer.appendChild(this.scratchCanvas);
            scratchContext.lineWidth = 3;
            scratchContext.strokeStyle = 'rgb(255,0,0,255)';

			// which one of the canvases is visible?
			if(a==0) {
				this.overlayCanvas.style.visibility='visible';
				this.scratchCanvas.style.visibility='hidden';
                this.canvasContainer.whatIsShown = 0;
			}
			else {
				this.overlayCanvas.style.visibility='hidden';
				this.scratchCanvas.style.visibility='visible';
                this.canvasContainer.whatIsShown = 1;
			}

			this.drawToolbar.ref.style.visibility='visible';
			this.drawToolbar.ref.onclick = this.handleToolbar;
 			this.canvasContainer.appendChild(this.drawToolbar.ref);
		}
		else
		{
			this.myCanvas.parentNode.style.visibility='visible';
			this.drawToolbar.ref.style.visibility='visible';
		}
	},
    
	toggleOverlay: function()
	{
		if (!this.canvasContainer)
		{
			this.createCanvases(0);
			container.whatIsShown=0;
		}
		else
		{
            var container = document.getElementById('drawingCanvasContainerID');
            if (container.style.visibility=='visible') {
                container.style.visibility = 'hidden';
                container.children[0].style.visibility = 'hidden'; // hide canvas
                container.children[2].style.visibility = 'hidden'; // hide toolbar
            } else {
                container.style.visibility = 'visible';
                container.children[0].style.visibility = 'visible';
                container.children[2].style.visibility = 'visible';
				container.whatIsShown=0;
            }
		}
	},
	
	toggleScratch: function()
	{
        if (!this.canvasContainer)
        {
            this.createCanvases(1);
			container.whatIsShown=1;
        }
        else
        {
            var container = document.getElementById('drawingCanvasContainerID');
            if (container.style.visibility=='visible') {
                container.style.visibility = 'hidden';
                container.children[1].style.visibility = 'hidden'; // hide scratchpad
                container.children[2].style.visibility = 'hidden'; // hide toolbar
            } else {
                container.style.visibility = 'visible';
                container.children[1].style.visibility = 'visible'; // hide scratchpad
                container.children[2].style.visibility = 'visible'; // hide toolbar
				container.whatIsShown=1;
            }
        }
	},
	
	onMouseMoveOnMyCanvas: function (event)
	{
		if (this.drawing)
		{
			var mouseX=event.layerX;  
			var mouseY=event.layerY;

			
			var context = this.childNodes[this.whatIsShown].getContext("2d");
			if (this.pathBegun==false)
			{
				context.beginPath();
				this.pathBegun=true;
			}
			else
			{
				context.lineTo(mouseX, mouseY);
				context.stroke();
			}
		}
	},

	onMouseDownOnMyCanvas: function (event)
	{
		this.drawing = true;
		// reset the path when starting over
		this.pathBegun=false;
	},

	onMouseUpOnMyCanvas: function (event)
	{
		this.drawing = false;
	},
	
	hideCanvas: function ()
	{
		this.parentNode.style.visibility='hidden';
	},
	
	slideChange: function ()
	{
        var container = document.getElementById('drawingCanvasContainerID');
        container.style.visibility = 'hidden';
        container.children[0].style.visibility = 'hidden'; // hide overlay
        container.children[1].style.visibility = 'hidden'; // hide scratchpad
        container.children[2].style.visibility = 'hidden'; // hide toolbar
	},
	
	handleToolbar: function(event)
	{
		var sel = Math.floor(event.layerX/16)+4*Math.floor(event.layerY/16);
        var container = document.getElementById('drawingCanvasContainerID');

        if(container.whatIsShown == 0)
            var canvas = document.getElementById('overlayCanvasID');
        else
			var canvas = document.getElementById('scratchCanvasID');

        var context = canvas.getContext("2d");
		
		switch(sel)
		{
			case 0: // smaller
                context.lineWidth = context.lineWidth-1;
                if(context.lineWidth == 0)
                {
                    context.lineWidth = 1;
                }
				break;
			case 1: // wider
				context.lineWidth = context.lineWidth+1;
				break;
			case 2: // eraser
				break;
			case 3: // exit
                container.style.visibility = 'hidden';
                container.children[0].style.visibility = 'hidden'; // hide canvas
                container.children[1].style.visibility = 'hidden'; // hide scratchpad
                container.children[2].style.visibility = 'hidden'; // hide toolbar
				break;
			case 4: // freehand
				this.drawingType = 1;
				break;
			case 5: // line
				this.drawingType = 2;
				break;
			case 6: // circle
				this.drawingType = 3;
				break;
			case 7: // clear canvas
				if (container.whatIsShown == 0)
				{
                    context.clearRect(0,0,canvas.width,canvas.height);
				}
				else
				{
                    context.fillStyle = 'rgba(255,255,255,255)'; // white, non-transparent
                    context.fillRect(0,0, canvas.width, canvas.height);
				}
				break;
			case 8: // white
				context.strokeStyle = 'rgb(255,255,255)';
				break;
			case 9: // yellow
				context.strokeStyle = 'rgb(255,255,0)';
				break;
			case 10: // orange
				context.strokeStyle = 'rgb(255,124,0)';
				break;
			case 11: // red
				context.strokeStyle = 'rgb(255,0,0)';
				break;
			case 12: // green
				context.strokeStyle = 'rgb(0,255,0)';
				break;
			case 13: // blue
				context.strokeStyle = 'rgb(0,0,255)';
				break;
			case 14: // gray
				context.strokeStyle = 'rgb(224,224,224)';
				break;
			case 15: // black
				context.strokeStyle = 'rgb(0,0,0)';
				break;
		}
		
	}
    
};
