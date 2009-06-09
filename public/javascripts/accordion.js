// $Id$
//
// Accordion class from tutorial @ 
// http://net.tutsplus.com/javascript-ajax/create-a-simple-intelligent-accordion-effect-using-prototype-and-scriptaculous/

var Accordion = Class.create({
    initialize: function(id, defaultExpandedCount) {
		    if(!$(id)) throw("Attempted to initalize accordion with id: "+ id + " which was not found.");
		    this.accordion = $(id);
		    this.options = {
		        toggleClass: "accordion-toggle",
		        toggleActive: "accordion-toggle-active",
		        contentClass: "accordion-content"
		    }
		    this.contents = this.accordion.select('div.'+this.options.contentClass);
		    this.isAnimating = false;
		    this.maxHeight = 0;
		    this.current = defaultExpandedCount ? this.contents[defaultExpandedCount-1] : this.contents[0];
		    this.toExpand = null;

		    this.checkMaxHeight();
		    this.initialHide();
				if (defaultExpandedCount) {
		    	this.attachInitialMaxHeight();
				}
		    var clickHandler =  this.clickHandler.bindAsEventListener(this);
		    this.accordion.observe('click', clickHandler);
		},

    /* Determines the height of the tallest content pane */
		checkMaxHeight: function() {
		    for(var i=0; i<this.contents.length; i++) {
		        if(this.contents[i].getHeight() > this.maxHeight) {
		            this.maxHeight = this.contents[i].getHeight();
		        }
		    }
		},
    /* Hides the panes which are not displayed by default */
		initialHide: function(){
		    for(var i=0; i<this.contents.length; i++){
		        if(this.contents[i] != this.current) {
		            this.contents[i].hide();
		            this.contents[i].setStyle({height: 0});
		        }
		    }
		},
    /* Ensures that the height of the first content pane matches the tallest */
		attachInitialMaxHeight: function() {
		    this.current.previous('div.'+this.options.toggleClass).addClassName(this.options.toggleActive);
		    if(this.current.getHeight() != this.maxHeight) this.current.setStyle({height: this.maxHeight+"px"});
		},
		clickHandler: function(e) {
		    var el = e.element();
		    if(el.hasClassName(this.options.toggleClass) && !this.isAnimating) {
		        this.expand(el);
		    }
		},
   	/* Tells the animation function which elements to animate */
		expand: function(el) {
		    this.toExpand = el.next('div.'+this.options.contentClass);
		    if(this.current != this.toExpand){
			    this.toExpand.show();
		      this.animate();
		    }
		},
    /* Performs the actual animation of the accordion effect */
		animate: function() {
		    var effects = new Array();
		    var options = {
		        sync: true,
		        scaleFrom: 0,
		        scaleContent: false,
		        transition: Effect.Transitions.sinoidal,
		        scaleMode: {
		            originalHeight: this.maxHeight,
		            originalWidth: this.accordion.getWidth()
		        },
		        scaleX: false,
		        scaleY: true
		    };

		    effects.push(new Effect.Scale(this.toExpand, 100, options));

		    options = {
		        sync: true,
		        scaleContent: false,
		        transition: Effect.Transitions.sinoidal,
		        scaleX: false,
		        scaleY: true
		    };

		    effects.push(new Effect.Scale(this.current, 0, options));

		    new Effect.Parallel(effects, {
		        duration: 0.5,
		        fps: 35,
		        queue: {
		            position: 'end',
		            scope: 'accordion'
		        },
		        beforeStart: function() {
		            this.isAnimating = true;
		            this.current.previous('div.'+this.options.toggleClass).removeClassName(this.options.toggleActive);
		            this.toExpand.previous('div.'+this.options.toggleClass).addClassName(this.options.toggleActive);
		        }.bind(this),
		        afterFinish: function() {
		            this.current.hide();
		            this.toExpand.setStyle({ height: this.maxHeight+"px" });
		            this.current = this.toExpand;
		            this.isAnimating = false;
		        }.bind(this)
		    });
		},
    handleClick: function(e){}            /* Determine where a user has clicked and act based on that click */

});