// $Id$
//
// Memento editor js

// Helper functions

// Untested: from http://forums.devshed.com/javascript-development-115/convert-seconds-to-minutes-seconds-386816.html
String.prototype.pad = function(l, s){
    return (l -= this.length) > 0
        ? (s = new Array(Math.ceil(l / s.length) + 1).join(s)).substr(0, s.length) + this + s.substr(0, l - s.length)
        : this;
};

// Parses query string for param's value
String.prototype.paramValue = function( key )
{
    var re = new RegExp( "[?&]" + key + "=([^&$]*)", "i" );
    var offset = this.search( re );
    if ( offset == -1 ) return null;
    return RegExp.$1;
};

// Trying various string escaping functions to display captions safely.
// So far only removing quotes & apostrophes completely works.
function getHTMLEncode(t) {
	return t.replace(/'/g, "").replace(/"/g, "").replace(/&#39;/g, "").replace(/&quot;/g, "").replace(/&/g, 'and');
}

// Handy string escaping/unescape functions for passing text inputs from forms to 
// be displayed inside Flowplayer
function htmlEncode(input){
  var t = document.createTextNode(input),
      e = document.createElement('div');
  e.appendChild(t);
  return e.innerHTML;
}

function htmlDecode(input){
  var e = document.createElement('div');
  e.innerHTML = input;
  return e.childNodes[0].nodeValue;
}

var flash_and_fade = function(id, message) {
	var el = $(id);
	if (el) {
		el.innerHTML = message;
		el.show();

		setTimeout(function() {
			new Effect.Fade(id);
		},
		5000);
	}
};

// Override spinner object
var arti_spinner = function() {
	var load = function() {
		$('artifact-loading-bar').show();
	}
	var unload = function() {
		$('artifact-loading-bar').hide();
	}
	return {
		load: load,
		unload: unload
	};
}();

var mementoFlash = function() {
	// Private functions
	function showMessage(message, div) {
		if (!div) div = 'flash_notice';
		flash_and_fade(div, message);
	};

	function showError(message, div) {
		if (!div) div = 'flash_error';
		flash_and_fade(div, message);
	};
	
	return {
		message: showMessage,
		error: showError
	};
} ();

// Globals

var MementoEditor = function() {
	var that = {};

	var contentCache = {},
		artifactPicker = null,
		artifactSeletion = null,
		audioPicker = null,
		audioSelection = null,
		movieGenerator = null,
		soundtrack = null,
		artifactViewerId = 'artifacts_list',
		artifactTypesId = 'type_list',
		wysiwygId = 'slide_text_editor',
		wysiwygEditor = null,
		droppablesId = 'scrollable_decorations',
		artifactDetailsId = 'artifacts_expanded_view',
		tabsSelector = 'ul#artifact-tabs',
		audioTabsSelector	= 'ul#soundtrack-tabs',
		soundtrackId = 'soundtrack-selection';

	// Called when an artifacts tab pane dom is loaded
	// Delegates to picker objects
	function artifactViewPopulated() {
		artifactPicker.artifactViewPopulated();
		audioPicker.artifactViewPopulated();
	};

	// Called when wysiwyg save button clicked
	function onTextEditorSave() {
		var val = textSlideEditor.getContents();
		
		if (textSlideEditor.isEditMode()) {
			artifactSelection.saveHtmlSlide(val);
		} else if (val && (val !== '')) {
			if (artifactSelection.addHtmlSlide(val)) {
				mementoFlash.message('Text slide added');
			}
		} else {
			mementoFlash.error('You must enter some text before it can be added your movie!');
		}
	}
	// Public functions
	
	// Accessor functions
	that.getArtifactPicker = function() {
		return artifactPicker;
	};
	
	that.getArtifactSelection = function() {
		return artifactSelection;
	};
	
	that.addCurrentArtifacts = function() {
		artifactSelection.addArtifacts(artifactPicker.getArtifacts());
	};
	
	// Cleanup/Edit functions
	that.refreshSelector = function() {
		arti_spinner.unload();
		artifactViewPopulated();
		artifactPicker.refresh();
		audioPicker.refresh();
	};
	
	that.hideArtifactDetailsView = function() {
		$(artifactDetailsId).update();
		$('drag_instructions').addClassName('hidden');
	};
	
	// Updates movie details data
	that.updateMovieDetails = function() {
		movieGenerator.movieUpdated();
	};
	
	that.showTextEditor = function() {
		// Display text editor pane
		artifactPicker.displayEditorPane();
	};
	
	// Returns instance of movie generator object
	that.getMovieCreator = function() {
		return movieGenerator;
	}
	
	// Submits Memento to form action for saving
	that.save = function(form) {
		if (artifactSelection.isEmpty()) {
			alert('You must add at least one artifact to create a Memento!');
			return false;
		}
		var title = $('memento_title');
		if ((title.value === '') || (title.value == title.readAttribute('defaultValue'))) {
			alert('Please enter a title for your Memento');
			return false;
		}
		// Get data from movieGenerator
	 	var data = this.getMovieCreator().getFormData();
		var qs = $H(data).toQueryString();

		$('save-memento-form').request({method: form.method,  
			parameters: qs
		});
		// Post to create action
		return false;
	};
	
	// Loads Mememto from JSON data
	that.load = function(id, title, slides_json, sounds_json) {
		console.log("Loading memento '" + title + "'");
		artifactSelection.clearItems();
		soundtrack.clearItems();
		
		// Set form values
		$('memento_id').value = id;
		$('memento_title').value = title;
		
		console.log("Loading slides from JSON");

		$A(slides_json).each(function(json) {
			artifactSelection.loadFromJSON(json);
		});
		console.log("Loading soundtrack from JSON");

		$A(sounds_json).each(function(json) {
			soundtrack.loadFromJSON(json);
		});
	};
	
	// Call to initialize
	that.init = function() {
		// Create wysiwyg widget 1st
		textSlideEditor = TextEditor.init({wysiwyg: false});
		artifactPicker = ArtifactPicker.init(artifactViewerId, tabsSelector);
		audioPicker = AudioPicker.init(audioTabsSelector);
		artifactSelection = ArtifactSelection.init(droppablesId, textSlideEditor);
		soundtrack = Soundtrack.init(soundtrackId);
		
		// create movie generator
		movieGenerator = MovieGenerator.init(artifactSelection, soundtrack);
		
		jQuery('#wysiwyg_form').submit(function() {
			onTextEditorSave();
			return false;
		});
		
		return this;
	};
	
	return that;
} ();

// WysiwygEditor handler
var TextEditor = function() {
	var that = {};

	var editor = null,
		editMode = false,
		options = {},
		initSaveButtonValue;

	function setTextValue(txt) {
		if (options.wysiwyg) {
			editor.setData(jQuery('#wysiwyg_instructions').html());
		} else {
			$('textinput').value = txt;
		}
	}
	function load() {
		editMode = false;
		jQuery('#save_wysiwyg').attr('value', initSaveButtonValue);
	};
	that.load = load;
	
	function edit(contents) {
		setTextValue(contents);
		editMode = true;
		jQuery('#save_wysiwyg').attr('value', 'Save');
	}
	that.edit = edit;
	
	function clear() {
		setTextValue('');
	};
	that.clear = clear;
	
	function getContents() {
		if (options.wysiwyg) {
			return editor.getData();
		} else {
			return $('textinput').value;
		}
	};
	that.getContents = getContents;
	
	function hide() {
		editor.clear();
	};
	that.hide = hide;

	function saveButtonText() {
		
	};
	
	// Returns editMode boolean
	that.isEditMode = function() {
		return editMode;
	};

	that.init = function(opts) {
		options = Object.extend({wysiwyg: false}, opts||{});
		
		if (options.wysiwig) {
			// Setup wysiwyg editor
			jQuery('form#wysiwyg_form textarea.editor').ckeditor(function() {
				// callback code
				editor = this;
			},
			mementosCKEditorConfig());
		} else {
			// No-op
		}
		initSaveButtonValue = jQuery('#save_wysiwyg').attr('value');
		
		jQuery('#clear_wysiwyg').click(function() {
			clear();
		});
		
		return this;
	};
	return that;
} ();


// Artifact picker object
var ArtifactPicker = function() {
	var that = {};
	
	var draggables = [];
	var scroller_el, 
		scroller, 
		domId,
		currentPane,
		panesReady = false,
		tabs = null,
		AlbumPaneId 	= 'artipane1',
		VideoPaneId 	= 'artipane2',
		TextPaneId 		= 'artipane3',
		TextPaneIndex = 2,
		TimelineUploadPaneId 	= 'artipane4';

	// Helper to return div containing artifact
	function getArtifactContainer(arti) {
		// Look for artifact container element
		if (arti.hasClassName('artifact')) {
			return arti;
		} else {
			return arti.up('.artifact');
		}
	};
	// info div element is bound to the function's scope
	function onArtifactMouseover(event) {
		var target = event.currentTarget;
		var info = null;

		if (target) {
			info = target.down('div.info');
		}
		if ((info !== null) && (info !== undefined)) {
			jQuery('.artifact_info').html(info.innerHTML);
		} else {
			jQuery('.artifact_info').html('');
		}
	};
	
	// Called on tab load
	that.artifactViewPopulated = function() {
		var paneId = currentPane[0].id;
		
		console.log(paneId + " populated");
		console.log("Creating video components");
		
		// Setup video players
		jQuery('.video_player').each(function() {
			flowplayer(this.id, FlowplayerSwfUrl,
		  {
		    key: FLOWPLAYER_PRODUCT_KEY,
		    clip: {
		      autoPlay: true
		    }
		  }
		  );
		});
	};
	
	// Display text editor pane
	that.displayEditorPane = function() {
		tabs.click(TextPaneIndex);
	};
	
	// Init function - takes artifact view parent dom id
	that.init = function(domId, tabsSelector) {
		// Create artifact tabs & click handlers
		that.domId = domId;
		
		jQuery(tabsSelector).tabs('div.panes1 > div', {
			effect: 'fade',
			onBeforeClick: function(event, i) {
				// On page load, don't try to load last opened pane - confuses and crashes scroller..
				if (panesReady) {
					// get the pane to be opened
					currentPane = this.getPanes().eq(i);
					if (jQuery(currentPane).attr('id') === TextPaneId) {
						//textSlideEditor.load();
					} else if (jQuery(currentPane).attr('id') == TimelineUploadPaneId) {
						// Upload Pane - do nothing
					} else {
						// load it with a page specified in the tab's href attribute
						arti_spinner.load();
						currentPane.load(this.getTabs().eq(i).attr("href"), null, function() {
							arti_spinner.unload();
						});
					} 
				} 
			}
		});
		// tabs cacheing fucks up page refreshes..don't use history plugin!
		//.history();
		
		// Get api object (for jQueryTools v. 1.2.4)
		tabs = jQuery(tabsSelector).data().tabs;
		currentPane = tabs.getPanes().eq(0);
		currentPane.load(tabs.getTabs().eq(0).attr("href"));
		panesReady = true;
		
		return this;
	};
	// Create draggable objects
	that.createDraggables = function(items) {
		var opts = {
			revert: true
		};
		draggables.clear();
		
		// Use dragdroppatch.js option 'superghosting' for non-audio divs in order to 
		// fix the dragging visibility bug & clone dragged object 
		if (items.size() && items[0].hasClassName('video')) {
			opts.superghosting = true;
		}
		items.each(function(i) {
			draggables.push(i);
			new Draggable(i, opts);
		});
	};
	// Adds all visible artifacts to selection
	that.getArtifacts = function() {
		return draggables;
	};
	
	// Update selector pane
	that.refresh = function() {
		var scroller, api;
		var pane = currentPane;
		
		// Make all artifacts draggable
		this.createDraggables($A(jQuery(pane).find('.artifact')));

		// Create scrollable object for draggables if found on page
		scroller = jQuery(pane).find('.scrollable');
		if (scroller) {
			api = jQuery(scroller).scrollable({
				// Config options here
				prev: '.left',
				next: '.right',
				speed: 100,
				size: 5,
				api: true
			});
			// This doesn't always work??
			if (api) {
				api.begin();
			}
			//jQuery(scroller).scrollable().begin();
			
			jQuery(scroller).find('.decoration_item').hover(function(el) {
				onArtifactMouseover(el);
			});
		}
	};
	return that;
} ();

// Artifact slideshow items scroller
var ArtifactSelection = function() {
	var that = {};

	var selectionId, cleared = false,
		parent = null,
		selectionScroller = null,
		selectedArtifact = null,
		audioSelection = null,
		playlistGenerator = null,
		textEditor = null,
		editingArtifact = null;

	// Called when artifact dropped on selector area
	function onArtifactAdded(draggable, droparea) {
		var newSlide, duration;

		// Save artifact for other actions 
		selectedArtifact = draggable;
		
		// superghosting: draggable fix in dragdropextra.js fails when dropped into Scrollable...
		// workaround by creating a new slide 
		// from the dragged element & hiding the cloned draggable element
		// Currently only applies to videos
		if (jQuery(selectedArtifact).css('position') == 'absolute') {
			newSlide = newSlideDiv().append(selectedArtifact.innerHTML);
			draggable.hide();
			
			selectedArtifact = newSlide[0];
			// Copy dragged div's attributes
			copyArtifactAttributes(selectedArtifact, draggable);			
		}
		addArtifact(selectedArtifact);
		showArtifactEditForm(selectedArtifact);
		
		onMovieUpdated();
	};
	
	// Copies dragged artifact's div attributes to new div element
	function copyArtifactAttributes(dest, src) {
		// Copy dragged div's attributes
		dest.id = src.id;
		dest.writeAttribute('src', src.readAttribute('src'));
		dest.writeAttribute('content_id', src.readAttribute('content_id'));
		if ((duration = src.readAttribute('duration')) !== null) {
			dest.durationSeconds = parseFloat(duration); // Copy playtime in seconds
		}
	};
	
	// Called whenever artifact slide added or removed
	function onMovieUpdated() {
		editor.getMovieCreator().movieUpdated();
		showActionLinks();
	};
	
	// Adds artifact to scroller
	function addArtifact(artifact) {
		var drophere = getArtifacts().last();
		var items = selectionScroller.getItemWrap();
		var editClass = artifact.userHtml ? 'edit_slide' : 'caption_slide';
		var inner, links, 
			artiEditLinks = '<span class="artifact-hover-menu-item-edit ' + editClass + 
		'"></span><span class="artifact-hover-menu-item-delete remove_slide"></span>';
		
		// artifact needs an id for IE 
		if (Prototype.Browser.IE) {
			jQuery(artifact).attr('id', artifact.uniqueID);
		}
		
		// Make sure to create a draggable on the new element to keep drag&drop ordering support
		new Draggable(artifact, {
			revert: true
		});
		
		//jQuery('body').append(artifact);
		// Add slide action icons & click handlers
		if (!Prototype.Browser.IE) {
			jQuery(artifact).append(artiEditLinks);
		}
		jQuery(artifact).hover(function() {
			jQuery(this).children("span").fadeIn(200); 
		}, function() {
			jQuery(this).children("span").fadeOut(200); 
		});
	
		// Move 'drop-here' box to the end
		drophere.remove();
		// Add new element & drop here box 
		selectionScroller.addItem(artifact);
		selectionScroller.addItem(drophere);
		
		// If IE, click handlers won't work on icons, use Prototip tooltip library 
		// as a workaround.
		// TODO: Find out why clicks don't work!
		if (Prototype.Browser.IE) {
			inner = jQuery('<div/>', {
				'class': "ttlinks",
				id: 'tt:' + artifact.id
			});
			links = jQuery('#arti-tooltip').clone().append(inner.append(artiEditLinks)).html();

			new Tip(artifact, links,
				{
					fixed: true,
					hook: {
						tip: 'topMiddle',
						target: 'bottomMiddle'
					},
					stem: 'topMiddle',
					width: 'auto',
					//hideOn: { element: 'tip', event: 'mouseout' }
					hideOn: false,
					hideAfter: 0.1
				}
			);
		}
		
		// Try to scroll to a good position near end of scroller
		if (selectionScroller.getSize() > 4) {
			selectionScroller.seekTo(selectionScroller.getSize()-3);
		}		
	};
	// Edit html slide action
	function editSlideHtml(artifact) {
		// Load artifact's text html into editor for editing
		editingArtifact = artifact;
		textEditor.edit(artifact.userHtml);
		editor.showTextEditor();
	};
	
	// Removes artifact from movie
	function removeArtifact(artifact) {
		getArtifacts().each(function(i) {
			if (artifact == i) {
				new Effect.DropOut(i, {
					afterFinish: function() { 
						i.remove(); 
						onMovieUpdated();
					}
				});
			}
		});
	};
	
	// Returns slide items in Array
	function getArtifacts() {
		return $A(selectionScroller.getItems());
	};
	that.getArtifacts = getArtifacts;
	
	// Returns div html for a new slide
	function newSlideDiv() {
		return jQuery('<div/>', {
			// quote class for IE's awesomeness
			'class': "decoration_item artifact text",
			click: function() {
			   // alert('fuck shit');
			  }
			});
	}
	
	// Show slide links
	function showActionLinks() {
		jQuery('slideshow_info').removeClass('hidden');
	};

	// Hide slide links
	function hideActionLinks() {
		jQuery('slideshow_info').addClass('hidden');
	};
	
	// Displays form for adding text description to an artifact
	function showArtifactEditForm(artifact) {
		var node;
		
		jQuery('#artifact_editor').removeClass('hidden');

		// Populate with existing text description
		if ((artifact.text_description !== undefined) & (artifact.text_description !== null)) {
			$('artifact_description').value = artifact.text_description;
		} else {
			$('artifact_description').value = $('artifact_description').defaultValue;
		}
		if (((node = artifact.down('img')) !== null) && (node !== undefined)) {
			$('arti_preview_img').innerHTML = '<img src="' + node.src + '"/>';
		}
		if (((node = artifact.down('div.info')) !== null) && (node !== undefined)) {
			$('arti_preview_details').removeClassName('hidden');
			$('arti_preview_details').innerHTML = node.innerHTML;
		}
	};

	// Hides artifact caption editor
	function hideArtifactEditForm() {
		$('artifact_editor').addClassName('hidden');
		$('arti_preview_details').addClassName('hidden');
	};
	
	// Saves artifact caption editor contents
	function saveArtifactDescription() {
		if (selectedArtifact !== null) {
			selectedArtifact.text_description = $('artifact_description').value;
		}
	};
	
	// Removes all but the drophere div
	function clearItems() {
		var items = selectionScroller.getItems();
		var i, size = items.size();
		for (i = 0; i < size - 1; i++) {
			items[i].remove();
		}
		selectionScroller.begin();
		hideActionLinks();
		hideArtifactEditForm();
		onMovieUpdated();
	};
	that.clearItems = clearItems;

	// Toggle preview link text
	function togglePreview(link) {
		if (link.hasClassName('hide')) {
			$('do_preview').innerHTML = 'Show preview';
			link.removeClassName('hide');
			$('preview_pane').hide();
		} else {
			//$('do_preview').innerHTML = 'Hide preview';
			//link.addClassName('hide');
			//$('preview_pane').show();
			showPreview();
		}
	};
	
	// Generates movie preview
	function showPreview() {
		hideArtifactEditForm();
		//$('movie_pane').show();
		Lightview.show({href: '#preview_pane',
			title: 'Memento Previewer',
			rel: 'inline',
			options: {
				width: MEMENTO.preview_win_width,
				height: MEMENTO.preview_win_height
			}
		});
	};
	
	// Public functions
	
	that.getSize = function() {
		return selectionScroller.getItems().size();
	};
	
	that.isEmpty = function() {
		return (this.getSize() <= 1);
	};
	
	// Programmatically add artifacts (non drag&drop)
	that.addArtifacts = function(artifacts) {
		artifacts.each(function(i) {
			onArtifactAdded(i);
		});
	};
	
	// Add html slide
	that.addHtmlSlide = function(html) {
		var slide = newSlideDiv().append('<img src="/javascripts/timeline/icons/doc.png" width="20" height="20" border="0"/>');
		slide[0].userHtml = html;
		
		addArtifact(slide[0]);
		onMovieUpdated();
		
		return true;
	};

	// Updates existing slide's wysiwyg html
	that.saveHtmlSlide = function(html) {
		if (editingArtifact !== null) {
			editingArtifact.userHtml = html;
			// Done editing, set editor back to create mode
			textEditor.load();
		} else {
			mementoFlash.error("Error saving slide: don't know which slide to update");
		}
	};
	
	// Returns movie generator object
	that.getMovieGenerator = function() { 
		return movieGenerator;
	};
	
	// Parses string from json object into artifact data, adds to 
	// selection
	that.loadFromJSON = function(json) {
		console.log("Got url " + json.url);
		// Create new slide div
		slide = newSlideDiv().css('position', 'relative');
		if (json.mediaType === 'html') {	
			this.addHtmlSlide(json.html);
		} else {
			slide.attr('src', json.url);
			slide.attr('content_id', json.cid);
			slide.attr('mediaType', json.mediaType);
			
			if (json.caption) {
				slide[0].text_description = json.caption;
			}
		
			if (json.mediaType == 'image') {
				slide.addClass('gallery_item photo');
				slide.append('<img src="' + json.thumb_url + '"/>');
			} else if (json.mediaType == 'video') {
				slide.addClass('decoration_item video');
				slide.append('<img src="' + json.thumb_url + '" class="video_thumb"/>');
			}
			addArtifact(slide[0]);
			onMovieUpdated();
		}
	};
	
	// init helper - finds a target artifact div associated with the clicked link
	function getClickArtifact(el) {
		var ttlinks, ttid;
		
		if (Prototype.Browser.IE) {
			ttlinks = el.up('.ttlinks');
			ttid = ttlinks.id.split(':')[1];
			selectedArtifact = $(ttid);
		} else {
			selectedArtifact = el.up('.artifact');
		}
		return selectedArtifact;
	};
	
	// Init function - takes artifact selection dom id
	that.init = function(droppablesId, editor) {
		var ttlinks, ttid;
		
		selectionId = '#' + droppablesId + ' .scrollable';
		textEditor = editor;
		
		// Make selection a drop target
		Droppables.add('selection-scroller', {
			hoverclass: 'selectorHover',
			onDrop: onArtifactAdded,
			accept: ['video', 'photo', 'video_thumb']
			//containment: 'artifact_picker'
		});
		
		// Make sortables container
		Sortable.create('item_list', {
			tag: 'div',
			overlap: 'horizontal',
			constraint: 'horizontal',
			dropOnEmpty: true,
			hoverclass: 'hoverActive ',
			accept: ['video', 'photo', 'text']
		});

		// initialize scrollable widget & save object
		selectionScroller = jQuery(selectionId).scrollable({
			// Config options here
			prev: '.left',
			next: '.right',
			speed: 100,
			size: 5,
			clickable: true,
			api: true
		});
		selectionScroller.begin();
		
		// Setup click handlers
		$$('form.clear_slides').each(function(f) {
			f.observe('submit', function(e) { e.stop(); clearItems(); });
		});

		// Setup description input
		jQuery('#artifact_description').addClass("idleField").focus(function() {
			jQuery(this).removeClass("idleField").addClass("focusField");
			
			if (this.value == this.defaultValue) {
				this.value = '';
			}
			if (this.value != this.defaultValue) {
				this.select();
			}
		}).blur(function() {
			jQuery(this).removeClass("focusField").addClass("idleField");
			mementoFlash.message('saved', 'caption_notice');
			
			if (jQuery.trim(this.value) == '') {
				this.value = (this.defaultValue ? this.defaultValue : '');
			} 
		}).keyup(function() {
			saveArtifactDescription();
		}).maxChar(MEMENTO.maxCaptionLength);
		

		// Setup artifact 'slide' click handlers, for everyone but IE
		
		// For html slide editing
		jQuery('.caption_slide').live('click', function(evt) {
			evt.preventDefault();
			showArtifactEditForm(getClickArtifact(this));
		});
		// To remove a slide
		jQuery('.remove_slide').live('click', function(evt) {
			removeArtifact(getClickArtifact(this));
			evt.preventDefault();
		});
		// To caption a slide
		jQuery('.edit_slide').live('click', function(evt) {
			editSlideHtml(getClickArtifact(this));
			evt.preventDefault();
		});
	
		// Setup description save button click handler
		// Now in Prototype!  I love using multiple frameworks..
		$('save_desc').observe('submit', function(e) {
			e.stop();
			saveArtifactDescription();
		});
		$('do_preview').observe('click', function(e) {
			e.stop();
			togglePreview(this);
		});
		
		return this;
	};

	return that;
} ();

var AudioPicker = function() {
	var that = {};
	var draggables = [];
	var panesReady = false,
		tabs,
		currentPane,
		AudioPaneId						= 'audiopane1',
		TimelineUploadPaneId 	= 'audiopane2';

	// Called on tab load
	that.artifactViewPopulated = function() {
		var paneId = currentPane[0].id;

		console.log(paneId + " populated");
		console.log("Creating audio components");
		
		if (paneId === AudioPaneId) {
			// Setup inline audio players
			if (inlinePlayer) {
				inlinePlayer.init();
			} else {
				inlinePlayer = new InlinePlayer();
			}
		}
	};
	
	// Create draggable objects
	that.createDraggables = function(items) {
		var opts = {
			revert: true
		};
		draggables.clear();
		
		items.each(function(i) {
			draggables.push(i);
			new Draggable(i, opts);
		});
	};
	
	// Adds all visible artifacts to selection
	that.getArtifacts = function() {
		return draggables;
	};
	
	// Refresh on reload
	that.refresh = function() {
		// Make all artifacts draggable
		this.createDraggables($A(jQuery(currentPane).find('.artifact')));
	};
	
	that.init = function(tabsSelector) {
		// Create artifact tabs & click handlers
		jQuery(tabsSelector).tabs('div.panes2 > div', {
			effect: 'fade',
			
			onBeforeClick: function(event, i) {
				// On page load, don't try to load last opened pane - confuses and crashes scroller..
				if (that.panesReady) {
					// get the pane to be opened
					currentPane = this.getPanes().eq(i);
					if (jQuery(currentPane).attr('id') == TimelineUploadPaneId) {
						// Upload Pane - do nothing
					} else {
						// load it with a page specified in the tab's href attribute
						$('audio-loading-bar').show();
						currentPane.load(this.getTabs().eq(i).attr("href"), null, function() {
							$('audio-loading-bar').hide();
						});
					} 
				}
			}
		}); 
		// tabs cacheing fucks up page refreshes
		//.history();
		tabs = jQuery(tabsSelector).data().tabs;
		currentPane = tabs.getPanes().eq(0);
		
		currentPane.load(tabs.getTabs().eq(0).attr("href"));
		this.panesReady = true;
		
		return this;
	};
	return that;
}();

var Soundtrack = function() {
	var that = {};

	var selection;
	var audioIcon = '<img src="/javascripts/timeline/icons/audio.png" width="15" height="15"/>';
	var dropTarget,
		dropTargetDiv,
		ogDropareaHtml = '',
		currentAudio = null,
		state = 'off';
	
	// on audio dropped into droptarget
	function onAudioAdded(draggable, droparea) {
		var text;
		var source;
		var obj = {};
		
		if (that.getSize() >= 1) {
			alert('Only one audio track is supported at the moment!');
			return;
		}
		if ((source = draggable.readAttribute('src')) !== null) {
			obj.source = source;
			obj.filename = draggable.readAttribute('fname');
			obj.duration = draggable.readAttribute('duration');
			obj.cid = draggable.readAttribute('content_id');
			
			addAudio(obj);
			updateSelectionText(droparea);
		}
		editor.getMovieCreator().movieUpdated();
	};
	that.onAudioAdded = onAudioAdded;
	
	// Adds sound object to list
	function addAudio(sound) {
		selection.push(sound);
	};
	that.addAudio = addAudio;
	
	// Updates description of tracks in list
	// Takes optional div for text update area
	function updateSelectionText(droparea) {
		text = "Soundtrack files: " + selection.map(function(audio) {
			return audioIcon + audio.filename;
		});
		if (droparea) {
			dropTarget = droparea; // Save this for when we want to empty it
			droparea.innerHTML = text;
		} else {
			dropTargetDiv.html(text);
		}
	};
	
	// Removes all sounds
	function clearItems() {
		selection.clear();
		dropTargetDiv.html(ogDropareaHtml);
	};
	that.clearItems = clearItems;
	
	// Returns list of track sources
	function getTracks() {
		var source;
		return selection.map(function(audio) {
			return audio.source;
		});
	};
	that.getTracks = getTracks;
	
	// Returns the track data objects
	that.getTrackData = function() {
		return selection;
	};
	
	that.getSize = function() {
		return selection.size();
	};
	
	// Sound control functions
	that.play = function() {
		var sounds;
		
		if (state === 'playing') return;
		
		if (currentAudio !== null) {
			currentAudio.play();
			state = 'playing';
		} else {
			if (this.getSize() > 0) {
				sounds = getTracks();
			
				currentAudio = soundManager.createSound({
					id: "memento_soundtrack",
				  url: sounds[0],
				  volume: 50
				});
				console.log("Playing audio!");
				currentAudio.play();
				state = 'playing';
			}
		}
	};
	
	that.stop = function() {
		if (currentAudio !== null) {
			console.log("Stopping audio!");
			currentAudio.stop();
			currentAudio = null;
		}
		state = 'off';
	};
	
	that.pause = function() {
		if (currentAudio !== null) {
			console.log("Pausing audio!");
			currentAudio.pause();
			state = 'paused';
		}
	};
	
	// Returns total duration of sountrack in seconds
	that.getDuration = function() {
		var duration = selection.inject(0, function(acc, audio) {
			if ((duration = audio.duration) !== null) {
				return acc + parseFloat(duration, 10).toFixed(2);
			} else {
				return acc;
			}
		});
		return duration;
	};
	
	// Loads soundtrack from json data
	that.loadFromJSON = function(json) {
		console.log("Loading audio: " + json.url);
		// Use json object as sound object
		json.src = json.url;
		json.content_id = json.cid;

		addAudio(json);
		updateSelectionText();
		editor.getMovieCreator().movieUpdated();
	};
	
	that.init = function(domId) {
		selection = new Array();
		
		if (domId !== null) {
			dropTargetDiv = jQuery('#'+domId);
			ogDropareaHtml = dropTargetDiv.html();
			// DOESN'T FUCKING WORK!
			dropTargetDiv.hover(function() { jQuery(this).addClass('selectorHover'); });
				
			// Make audio selection a drop target
			Droppables.add(domId, {
				//hoverclass: 'soundtrackHover',
				onDrop: onAudioAdded,
				accept: ['audio']
			});
		
			$$('form.clear_sounds').each(function(f) {
				f.observe('submit', function(e) { e.stop(); clearItems(); });
			});
		}
		return this;
	};
	return that;
} ();

var movieInfo = function() {
	// Converts seconds to MM:SS format
	function secondsToDuration(seconds) {
		var m = Math.floor(seconds / 60);
		var s = (seconds % 60).toFixed();
		return m + ':' + s.pad(2, "0");	
	};
	
	// Updates movie info pane
	function update(movie) {
		var info = "";
		info += movie.getNumSlides() + ' frames<br/>' +
			'Average slide length: ' + secondsToDuration(movie.getAvgDurationPerSlide()) + '<br/>' +
			movie.getSoundtrack().getSize() + ' Audio tracks<br/>';
		jQuery('#movie_duration').html('Total play time: ' + secondsToDuration(movie.getTotalDuration()));
		jQuery('#movie_info').html(info);
	};
	return {
		update: update
	};
}();

var MovieGenerator = function() {
	var that = {};
	var mediaTypes = {image: 'image', video: 'video', html: 'html', audio: 'audio'};
	var artifacts, soundtrack, expose, seconds_per_frame, 
		DefaultSecondsPerFrame = 5,
		initCaptionBoxWidth = '80%',
		initCaptionBoxHeight = 60,
		totalPlaytime,
		player,
		slideInfoMap = new Hash();

	// Creates playlist array for Flowplayer from selected artifacts
	function generatePlaylist() {
		var i, src, item, clip = {}, playlist = [];
		
		if (artifacts.getSize() <= 1) {
			return playlist;
		}
		// Step through all slides but the last (dragdrop slide)
		var slides = artifacts.getArtifacts();
		for (i=0; i<slides.size()-1; i++) {
			clip = new Object();
			// If slide contains artifact
			item = slides[i];
			if (((src = item.readAttribute('src')) !== undefined) && (src !== null)) {
				if ((item.readAttribute('mediaType') === 'image') || (item.id.match('photo') !== null)) {
					clip = {
						url: src,
						scaling: 'orig',
						// by default clip lasts 5 seconds 
						duration: getAvgDurationPerSlide(),
						mediaType: mediaTypes.image,
						cid: item.readAttribute('content_id')
					};
					console.log("Adding image or video: " + src);
				} else if ((item.readAttribute('mediaType') === 'video') || (item.id.match('video') !== null)) {
					clip = {
						url: src,
						scaling: 'fit',
						mediaType: mediaTypes.video,
						cid: item.readAttribute('content_id')
					};
					console.log("Adding video: " + src);
				} 
				// Save each clip's metadata for playblack event handlers
				if (item.text_description) {
					// We have to escape unsafe characters otherwise Flowplayer won't play
					clip.caption = getHTMLEncode(item.text_description);
					console.log("Saving caption as " + clip.caption);
				}
			} else if (item.userHtml) { // slide is text only
				// Use tiny image for "video" position for now
				// Generate id for this playlist item
				clip = {
					url: "/images/black.jpg",
					textId: 'text_' + i,
					duration: getAvgDurationPerSlide(),
					mediaType: mediaTypes.html,
					// Have to decode html for Flowplayer or plugin won't load
					html: getHTMLEncode(item.userHtml)
				};
			}
			clip.position = i+1;
			playlist.push(clip);
		}
		
		return playlist;
	};

	// Calculates default clip duration in seconds
	function getDefaultClipDuration() {
		// If soundtrack is empty,
		return DefaultSecondsPerFrame;
	};
	
	// Returns # slides in movie
	function getNumSlides() {
		return artifacts.getSize() - 1;
	};
	that.getNumSlides = getNumSlides;
	
	// Returns avg seconds per slide
	function getAvgDurationPerSlide() {
		return avgDurationPerFrame;
	};
	that.getAvgDurationPerSlide = getAvgDurationPerSlide;
	
	// Wrapper to soundtrack handler
	that.onAudioAdded = function(draggable, droparea) {
		soundtrack.onAudioAdded(draggable, droparea);
		movieUpdated();
	};
	
	// Helpers to determine position of slide in movie
	function isFirstSlide(playlist, clip) {
		return (clip.position === 1);
	}
	// Helper to determine when movie is on last slide
	function isLastSlide(playlist, clip) {
		return (clip.position === playlist.size());
	};
	
	// Returns total runtime
	that.getTotalDuration = function() {
		return totalPlaytime;
	};
	
	that.getSoundtrack = function() {
		return soundtrack;
	};
	
	// Updates movie metadata
	that.movieUpdated = function() {
		var i, artis = artifacts.getArtifacts();
		totalPlaytime = 0;
		seconds_per_frame = 0;

		for (i=0; i<getNumSlides(); i++) { 
			totalPlaytime += artis[i].durationSeconds ? artis[i].durationSeconds : getDefaultClipDuration(); 
		}
		totalPlaytime = Math.max(totalPlaytime, soundtrack.getDuration());
		avgDurationPerFrame = getNumSlides() ? (totalPlaytime / getNumSlides()).toFixed(2) : 0;

		movieInfo.update(this);
	};
	
	// Generates movie info for submitting to form
	that.getFormData = function() {
		var formData = {'slide[]': [], 'audio[]': []};
		
		soundtrack.getTrackData().each(function(sound) {
			formData['audio[]'].push($H(sound).toQueryString());
		});

		generatePlaylist().each(function(clip) {
			formData['slide[]'].push($H(clip).toQueryString());
		});
		
		return formData;
	};
	
	// Create movie preview using existing selection
	that.preview = function() {
		var playlist = generatePlaylist();
		var text, boxWidth = initCaptionBoxWidth, boxHeight = initCaptionBoxHeight;
		var animateTextBoxOpenOptions, captionTextStyles, textSlideStyles, plugin;
		// TODO: This should bet set in an external css file
		animateTextBoxOpenOptions = {width: boxWidth, height: boxHeight, bottom: 5};
		captionTextStyles = {backgroundColor: '#112233'};
		textSlideStyles = {backgroundColor:'#333333', border:'1px solid #ffffff'};
		
		if (playlist.size() === 0) {
			return;
		}
		
		player = flowplayer('movie_player', FlowplayerSwfUrl, {
			//log: { level: 'debug' },
			key: FLOWPLAYER_PRODUCT_KEY,
			clip: {
				// accessing current clip's properties 
				onStart: function(clip) {
					console.log("on clip " + clip.url);
					console.log("clip text: " + clip.caption);
					console.log("clip html: " + clip.html);
					console.log("clip duration: " + clip.duration);
					console.log("clip type: " + clip.mediaType);
					console.log("clip cid: " + clip.cid);
					
					// Handle audio 
					if (isFirstSlide(playlist, clip)) {
						//expose.load();
						// If there is a soundtrack, start it
						if (clip.mediaType !== mediaTypes.video) {
							soundtrack.play();
						}
					} else {
						if (clip.mediaType === mediaTypes.video) {
							soundtrack.pause();
						} else {
							soundtrack.play();
						}
					}
					// get access to a configured plugin
					
					plugin = this.getPlugin("content");
					
					if ((text = clip.caption) !== undefined) {
						if (text === '') {
							boxWidth = boxHeight = 1;
						}
						plugin.animate(animateTextBoxOpenOptions, function() {
							this.css(captionTextStyles);
							this.setHtml(clip.caption);
						});
						//$('slide_caption').innerHTML = slideInfoMap[clip.url];
						//$('slide_caption').show();
					} else if (clip.html !== undefined) {
						plugin.animate({width: "85%", height: "85%", top:30, bottom:30}, function() {
							this.css(textSlideStyles);
							this.setHtml('<p class="html">' + clip.html + '</p>');
						});
					} else {
						// Hide content plugin
						plugin.animate({width: 1, height: 1, bottom: 5}, function() {
							this.css(captionTextStyles);
							this.setHtml('');
						});
					}	
				},
				
				onStop: function(clip) {
					if (clip.mediaFormat === 'video') {
						soundtrack.play();
					}
				},
				onLastSecond: function(clip) {
					// If at end of movie...
					if (isLastSlide(playlist, clip)) {
						this.getPlugin("content").animate({top: 30, width: boxWidth, height: boxHeight}, function() {
							this.css(captionTextStyles);
							this.setHtml('<a href="http://eternos.com/?ref=memento">THIS PRESENTATION WAS CREATED USING THE ETERNOS.COM MEMENTO EDITOR</a>');
						});
						soundtrack.stop();
						//expose.close();
					}
				}
			},
			// our playlist
			playlist: playlist,

			logo: {
				url: '/images/favico.png',
				fullscreenOnly: false
			},
			// canvas background
			canvas: {
				background: '#fff'
				//backgroundColor:'#18b9ed',
				//backgroundGradient: 'high'
			},

			// screen positioning inside background screen.
			// What does this really do???
			screen: {
				top: 5,
				left: 2,
				right: 2
				//height: 266,
			},

			onFinish: function() {		
				console.log("onFinish");
			},
			
			// content specific event listeners and methods 
			onMouseOver: function() {
				//this.getPlugin("content").setHtml('Mouse over');
			},

			onMouseOut: function() {
				//this.getPlugin("content").setHtml('Mouse moved away. Please visit Finland someday.');
			},
			
			plugins: {
				// Turn off controls
				controls: null,
				// Captioning
				/*
				captions: {
					url: 'flowplayer.captions-3.2.1.swf',

					// pointer to a content plugin (see below)
					captionTarget: 'content'
				},
				*/
				// content plugin settings
				content: {
					url: 'flowplayer.content-3.2.0.swf',
					
					// initial HTML content. content can also be fetched from the HTML document
					html: '',
					
					// text slide some display properties 
					width: initCaptionBoxWidth,
					height: initCaptionBoxHeight,
					/*
					top: 10,
					left: 10,
					borderColor: '#CCCCCC',
					borderRadius: 10,
					padding: 15,
					// Styles can be defined inline or with external stylesheet
					// http://flowplayer.org/plugins/flash/content.html
					body: {
						fontSize: 14,
						fontFamily: 'Arial',
						textAlign: 'center',
						color: '#000000'
					},
					textDecoration: 'none',
					
					*/
					
					/*
					// Eternos blue background
					opacity: 0.9,
					backgroundColor: '#BBE3FC',
					backgroundGradient: [0.1, 2, 0.1],
					*/
					
					// flowplayer caption example display properties
					bottom: 5,
					// Hard to read on light backgrounds! 
					backgroundColor: '#112233',
					//opacity: 0.7,

					// one styling property 
					//backgroundGradient: [0.1, 0.1, 1.0],
					//backgroundColor: 'transparent',
					backgroundGradient: 'low',
					borderRadius: 4,
					border: 0,
					textDecoration: 'outline',
					
					style: {
						body: {
							fontSize: '14',
							fontFamily: 'Arial',
							textAlign: 'center',
							color: '#ffffff'
						},
						'.html': {
							fontSize: 20,
							fontFamily: 'verdana,arial,helvetica',
							fontWeight: 'bold',
							textAlign: 'center',
							borderRadius: 10,
							textDecoration: 'none'
						}
					}					
				}
				/*
				,
				// Uncomment for production
				gatracker: { 
					url: "flowplayer.analytics-3.1.5.swf", 
					trackingMode: "Bridge"
				}
				*/
			}
		});
	};
	
	that.stop = function() {
		soundtrack.stop();
	};
	
	that.init = function(artis, sounds) {
		artifacts 	= artis;
		soundtrack 	= sounds;
		player 			= null;
		totalPlaytime 		= 0;
		seconds_per_frame = 0;
		/*
		expose = jQuery("#preview_pane").expose({
			// return exposing API 
			api: true
		});
		*/
		soundManager.onready(function(oStatus) {
			// Notify listener that audio is ready to be played - very important for 
			// player page that loads & plays editor very quickly!
			// Using this custom event allows the player page to wait for audio support
			// to be fully loaded before beginning playback
			if (oStatus.success) {
				$('movie_player').fire('audio:ready', {});
			} else {
				mementoFlash.error('Error initializing sound...please reload the page.');
			}
		});
		// Setup movie to start after lightview opens & stops if it closes
		document.observe('lightview:opened', function() {
			that.preview();
		});
		document.observe('lightview:hidden', function() {
			that.stop();
			// CLEAR FLOWPLAYER HTML, NO OTHER WAY TO UNLOAD THE OBJECT!
			$('movie_player').update();
			jQuery('#save-button').removeClass('hidden');
		});
		
		return this;
	};
	return that;
} ();

