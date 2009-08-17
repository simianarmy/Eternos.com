/* $Id$ */
//
// Behaviors for LowPro library

// For rails csrf protection - generates authenticity code token for 
// request uris

var AJ =
{
  encode_authenticity_token:function( token )
  {
      return encodeURIComponent( $F(token) )
  },
  authenticity_token_query_parameter_for_page:function()
  {
      return 'authenticity_token=' + AJ.encode_authenticity_token(
        $$( 'input[type=hidden][name=authenticity_token]' ).first()
			);
  },
	busy_options: function(id) {
		var options = {
			onLoading: function() {
				load_busy($(id));
			},
			onComplete: function() {
				unload_busy();
			}
		};
		return options;
	}
};

var ToggleEffects = {
	show_with_highlight: function(el) {
		$(el).removeClassName('hidden');
		$(el).show();
		new Effect.Highlight(el);
	},
	hide: function(el) {
		$(el).addClassName('hidden');
	}
};

var FCKCollection = function() {
	var instances = [];
	var that = {};
	
	var add_fck = function(fck) {
		console.log("Adding FCKeditor " + fck.Name);
		instances[instances.length] = fck;
	};
	that.add_fck = add_fck;
	
	that.get_fck = function(id) {
		return instances.find(function(fck) {
			return fck.Name === id;
		});
	};
	return that;
};
var fckCollection = FCKCollection();
// Global handler sucks - where to put it?
FCKeditor_OnComplete = fckCollection.add_fck;

// Form Behaviors 
//

Delete = Behavior.create({
	onclick: function( event ) {
		if ( confirm( 'Are you sure?' ) ) {
			return true;
		}
		else {
			event.stop();
			return false;
		}
	}
});

// For ajax delete links - can we extend Remote.Link to simplify?

Remote.Delete = Behavior.create( Remote.Base, {
  onclick: function( event ) {
    var element = Event.element( event );
		
    if ( element.hasClassName( 'remote_delete' ) ) {
			// Get parent link if we are an image
			if (!element.href) element = element.up('a');
			if (!element) return false;
			
      if ( confirm( 'Are you sure?' ) ) {
				var busy = element.readAttribute('busy_id');
        var options = Object.extend({
            url:        element.href.gsub( '/destroy$', '' ),
            method:     'delete',
            parameters: AJ.authenticity_token_query_parameter_for_page()
        }, AJ.busy_options(busy));

        options = Object.extend( options, this.options );
        this._makeRequest( options );
      }
      return false;
    }
    return true;
  }
});

RemoteForm = Behavior.create( Remote.Form, {
	initialize: function($super, options) {
		// Check for spinner element id option
		// Add ajax options to remote form submit if any
		var options = {};
		if (rel = this.element.readAttribute('rel')) {
			var opts = rel.evalJSON();
			if (opts.busy_id) {
				options = Object.extend(options, AJ.busy_options(opts.busy_id));
			}
		}
		// observe custom event that you fire elsewhere
		this.element.observe('form:data_changed',this.ajaxsubmit.bindAsEventListener(this));
		
		$super(options);
	},
	ajaxsubmit : function(event) {
		// without this line, you'll get an error 
		this._submitButton = this.element;

		// call the onsubmit 'function' of the Remote.Form behavior
		this.onsubmit();
	}
});

// For form text inputs - displays default value inside input
// using defaultValueActsAsHint function

var DefaultValueAsHint = Behavior.create({
	initialize: function() {
		def = this.element.readAttribute('defaultValue');
		if (def != '' && this.element.value == "") {
			this.element.value = def;
		}
		this.element.defaultValueActsAsHint();
	}
});

var TabbedForms = Behavior.create({
	// Hide form errors divs when switching tabs
	onclick: function() {
		$$('div#errorExplanation').each(function(err) {
			err.hide();
		});
		$$('div#flash_notice').each(function(err) {
			err.hide();
		});
	}
});

// Validate terms of service checkbox

var FormTermsValidation = Behavior.create({
	onsubmit: function(evt) {
		if (! $('terms_of_service').checked) {
			alert('Please accept the Terms of Use');
			evt.stop();
			return false;
		} else return true;
	}
});

// Allows form selects to:
// 	- assign event on single option that will 
// toggle show/hide of an element on select/change.
// 	- auto submit on change
//
// select must specify rel => {toggleValue: <value>, toggleElement: <element>}
// class => toggle_on_select
// 	and/or
// class => submit_on_change

var FormSelect = Behavior.create({
	initialize: function() {
		this.lastSelectedValue = this.element.selectedIndex;
		this.autoSubmit = this.element.hasClassName('submit_on_change');
	
		if (this.element.hasClassName('toggle_on_select') && 
			(opts = this.element.readAttribute('rel'))) {
			opts = opts.evalJSON();
			this.toggleVal = opts.toggleValue;
			this.toggleEl = opts.toggleElement;
	
			// Show if selected on load
			if (this.lastSelectedValue == this.toggleEl) {
				$(this.toggleEl).removeClassName('hidden');
			}
		}
	},
	onchange: function(evt) {
		var toggledOn = false;
		var target = evt.target;
		var opt = target.options[target.selectedIndex]
		
		if (this.toggleVal) {
			if (this.toggleVal == opt.value) {
				// Display element named as key value
				ToggleEffects.show_with_highlight(this.toggleEl);
				toggledOn = true;
			} else if (this.lastSelectedValue == this.toggleVal) {
				// Hide element when non-target option selected
				ToggleEffects.hide(this.toggleEl);
			}
		} 
		if (this.autoSubmit && !toggledOn) {
			target.fire('form:data_changed')
		}
		this.lastSelectedValue = opt.value;
	}
});

// Helper for jquery autocomplete - calls autocomplete method
// with input textfield id

AutoCompleteInput = Behavior.create({
	initialize: function() {
		id = this.element.id
		jQuery("input#"+id).autocomplete("auto_complete_for_" + id)
	}
});

// For form radio groups where each button is associated with an element 
// that is displayed on click.
// Only one element can be displayed at a time, just like a radio group button.

var RadioGroupToggle = Behavior.create({
	initialize: function() {
		var that = this;
		this.opts = {buttons: []};
		
		$A(this.element.select('input[type=radio]')).each(function(radio) {
			// If there exists a radio's associated element to toggle on click
			var id;
			if ((m = radio.id.match(/toggle_(\w+)/)) && (id = m[1])) {
				// Associate display function with the radio
				if ($(id) !== null) {
					that.opts.buttons.push({
						id: radio.id,
						on: function() { ToggleEffects.show_with_highlight(id); }, 
						off: function() { ToggleEffects.hide(id); }
					});
				}
				// and attach a click handler to the radio button
				Event.observe(radio, 'click', function() { 
					that.on_radio_click_toggle(radio);
				});
			}
		});
	},
	on_radio_click_toggle: function(el) {
		// Toggle on radio button's matching element, hide all others
		for (var i=0; i<this.opts.buttons.length; i++) {
			if (this.opts.buttons[i].id === el.id) {
				this.opts.buttons[i].on();
			} else {
				this.opts.buttons[i].off();
			}
		}
	}
});

// For address country & region selects
// Updates region select using Ajax query on a country selection change

var AjaxCountryRegionSelect = Behavior.create({
	initialize: function() {
		this.opts = {
			country_select_id: this.element.id,
			region_select_id: this.element.readAttribute('region_select_id'),
			regions_url: this.element.readAttribute('region_url')
		};
		if (this.element.readAttribute('region_id') === '') {
			$(this.opts.region_select_id).hide();
		}
	},
	onchange: function(evt) {
		var params = 'select_id=' + this.opts.region_select_id + '&country_id=' + this.element.value;
		new Ajax.Request(this.opts.regions_url, 
			Object.extend({asynchronous:true, evalScripts:true, parameters: params}, 
				AJ.busy_options(this.element.up('div').id)));
	}
});

// Helpers for Lightview library

var LightviewPopup = Behavior.create({
	initialize: function(rel) {
		this.rel = rel;
		this.opts = {
			autosize:true, 
			ajax: {
				evalScripts: true, 
				method: 'get'
			}
		};
	},
	onclick: function(evt) {
		if (rel = this.element.readAttribute('rel')) {
			this.opts = Object.extend(rel.evalJSON(), {});
		}
		Lightview.show({
			href: evt.currentTarget.href,
			rel: this.rel, 
			title: evt.currentTarget.title,
			options: this.opts
		});
		return false;
	}
});

var LightviewClose = Behavior.create({
	// This code is needed to prevent lightview:hidden event from bubbling 
	// up to document-wide event handler created for 'add media' lightview popup
	// (which cannot be caught any other way - b/c it is an iframe type?)
	initialize: function() {
		this.element.observe('lightview:hidden', function(evt) {
	    evt.stop();
	 	});
	}
});

// Helpers for Prototip library

var Prototip = Behavior.create({
	initialize: function() {
		// Parse json string of options from rel attribute
		opts = {}
		try {
			if (rel = this.element.readAttribute('rel')) {
				opts = rel.evalJSON();
			}
		} catch(err) {
			// log error
		}
		this.opts = opts;
		if (tooltip = this.element.next('.tooltip')) {
			$(tooltip).hide();
			new Tip(this.element, tooltip, opts);
		}
	},
	onclick: function(evt) {
		if (this.opts.showOn == 'click') evt.stop();
	}
});

var GalleryItem = Behavior.create({
	onclick: function(evt) {
		this.element.toggleClassName('gallery_item-selected');
	}
});

// Toggles display of div contents
// Usage:
// Make clickable element with any id (ie: show-me) and class: toggleable
// Make div to show/hide with id using prefix: toggle_ (ie: toggle_show-me)

var Toggle = Behavior.create({
	onclick: function(evt) {
		// Extract div to toggle from id
		if ((m = evt.target.id.match(/toggle_(\w+)/)) && (id = m[1])) {
			evt.stop();
			
			if ($(id).getStyle('display') == 'none') {
				ToggleEffects.show_with_highlight(id);
			} else {
				ToggleEffects.hide(id);
			}
		}
	}
});

// Sets up fckeditor widget as a drop taget for multimedia artifacts
// Creates drop handler that insert specially formatted code for 
// display of images, audio & video files
var WysiwygDropTarget = Behavior.create({
	initialize: function() {
		this.editor = undefined;
		this.editor_id = undefined;
		this.wysiwyg = wysiwyg();
		
		var ta = this.element.down('textarea');
		if (ta !== undefined) {
			this.editor_id = ta.id;
			
			Droppables.add(this.element.id, {
				hoverclass: 'hover',
				onDrop:function(element, dropon) {
					if (this.editor === undefined) {
						this.editor = fckCollection.get_fck(this.editor_id);
					}
					if (this.editor !== undefined) {
						var drop_text = this.wysiwyg.get_artifact_html(element);
			      this.editor.InsertHtml(drop_text);
			   	}
				}.bind(this)
			});
		}
	}
});

// Displays wysiwyg editor contents in popup window, with necessary styles & 
// media objects formatted
var WysiwygPreviewer = Behavior.create({
	initialize: function() {
		// Find matching fckeditor id and save for click
		// Don't try to get now, b/c we can't be sure fckeditor loaded yet.
		this.editor = undefined;
		this.editor_id = undefined;
		this.previewer = wysiwyg();
		
		var ta = (this.element.up('textarea') || this.element.previous('textarea'));
		if (ta !== undefined) {
			this.editor_id = ta.id;
		}
	},
	onclick: function(evt) {
		if (this.editor_id !== undefined) {
			if (this.editor === undefined) {
				this.editor = fckCollection.get_fck(this.editor_id);
			}
			if (this.editor !== undefined) {
				evt.stop();
				// Get editor contents & pass to server for filtering - display results
				var text = this.editor.GetXHTML();
				
				Lightview.show({
					// When creating iframe, cannot use POST request method?
					href: evt.target.href + '?dialog=1&message=' + encodeURIComponent(text),
					rel: 'iframe',
					title: 'Preview',
					options: {
						fullscreen: true,
						topclose: true,
						ajax: {
							// POST params ignored if iframe method (forces GET)
							method: 'post',
							parameters: 'dialog=1&message=' + encodeURIComponent(text)
						}
					}
				});
			}
		}
	}
});

// Wrapper to Scriptaculous Draggable constructor
var DraggableObject = Behavior.create({
	initialize: function() {
		new Draggable(this.element.id, {revert: true});
	}
});

// Wrapper for Accordion library

var Accordion = Behavior.create({
	initialize: function() {
		new Accordion(this.element);
	}
});

// Creates jQuery scroller

var MediaScroller = Behavior.create({
	initialize: function() {
		jQuery('#scroller').sortable({items: '.decoration', opacity: 0.6,
    	update: function(event, ui) {
	      jQuery.ajax({
	        type: "POST",
	        url: this.readAttribute('target'),
	        processData: true,
					dataType: 'script',
	        data: jQuery("#scroller").sortable('serialize') + '&' + AJ.authenticity_token_query_parameter_for_page()
      	})
    	}
  	});
	}
});

// Interface to Slideshow library

var Slideshow = Behavior.create({
	initialize: function(opts) {
		Event.observe(document, 'dom:loaded', function() {
			this.container = this.element;
			document.observe('lightview:loaded', function() {
				// Is this good JS?
				this.slideshow = new SlideShow(this.container, opts);
			}.bind(this));
		}.bind(this));
	},
	onclick: function(evt) {
		var element = Event.element(evt);
		if (element.hasClassName('play_slideshow')) {
			evt.stop();
			if (!this.slideshow) { this.slideshow = new SlideShow(this.element, opts); }
			this.slideshow.start(element);
		}
	}
});

// Wrapper for Flowplayer library

var Flowplayer = Behavior.create({
	initialize: function() {
		opts = this.element.readAttribute('rel').evalJSON();
		if (window.flowplayer) {
			// Create Flowplayer & use 1st frame of video as splash image --> 
			flowplayer(this.element.id, FlowplayerSwfUrl, {
				key: FLOWPLAYER_PRODUCT_KEY,
				clip: { 
					url: this.element.readAttribute('url'),
					autoPlay: opts.autoPlay || false,  
					autoBuffering: true,
					initialScale: opts.scale || 'scale'
				},
				logo: {
					//url: '/images/eternos.gif',
					fullscreenOnly: false
				}
			});
		}
	}
});

Event.addBehavior({
	'.tabselector li': TabbedForms,
	'.form_with_terms': FormTermsValidation,
	'.toggleable': Toggle,
	'a.popup_get': LightviewPopup('iframe'),
	'a.video_link': LightviewPopup('inline'),
	'.gallery_item': GalleryItem,
	'.delete_link': Delete,
	'.remote_delete': Remote.Delete,
	'#item_list': Remote.Delete,
	'.tooltip-target' : Prototip,
	'.withHint': DefaultValueAsHint,
	'.accordion': Accordion,
	'#slideshow': Slideshow({with_track: false}),
	'#slideshow-narrated': Slideshow({with_track: true}),
	'.video_player': Flowplayer,
	'.catch_lightview_close': LightviewClose,
	'.remote_form': RemoteForm,
	'select': FormSelect,
	'input.auto_complete': AutoCompleteInput,
	'#scroller': MediaScroller,
	'.radio_group_toggle_on_click': RadioGroupToggle,
	'.ajax_region_select': AjaxCountryRegionSelect,
	'.draggable': DraggableObject,
	'.fckeditor-drop-container': WysiwygDropTarget,
	'.wysiwyg_preview': WysiwygPreviewer,
	
	'#decoration_gallery_form:submit': function(e) {
		this.selected_content.value = $$('.gallery_item-selected').collect(function(val) {
			return /_(\d+)$/.exec(val.id)[1]; 
		});
		if (this.selected_content.value == '') {
			alert('Please select at least one');
			return false;
		}
		else {
			return true;
		}
	},
	'#plan_form:submit': function(evt) {
		if (plan = $RF('plan_form', 'plan')) { 
			$('plan_form').action = $('plan_form').action + '/' + plan; 
			return true; 
		} else { 
			alert('Please select an account');
			evt.stop();
			return false; 
		}
	},
	// Select text on focus
  'input[type=text]:focus, textarea:focus': function(e) {
    this.select();
  }
});
Event.addBehavior.reassignAfterAjax = true; 

// jQuery section


