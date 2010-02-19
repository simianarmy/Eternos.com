// $Id$
//
// Memento editor object

// Helper functions

var flash_and_fade = function(id, message) {
	$(id).innerHTML = message;
	setTimeout(function() { new Effect.Fade(id); }, 15000);
};

var MementoEditor = function() {
	var that = {};
	
	var contentCache = {},
		artifactPicker 		= null,
		artifactSeletion	= null,
		artifactViewerId 	= 'artifacts_list',
		artifactTypesId	 	= 'type_list',
		wysiwygId					= 'slide_text_editor',
		wysiwygEditor			= null,
		droppablesId		 	= 'scrollable_decorations',
		artifactDetailsId	= 'artifacts_expanded_view',
		tabs							= null,
		currentPane				= null,
		AlbumPaneId				= 'pane1',
		VideoPaneId				= 'pane2',
		AudioPaneId				= 'pane3',
		TextPaneId				= 'pane4';
		
	// Private functions
	
	function showMessage(message) {
		flash_and_fade('notice_notice', message);
	};
	
	function showError(message) {
		flash_and_fade('notice_error', message);
	};
	
	// Handles artifact type picker link click
	function onArtifactTypeLinkClick(link) {
		var url = link.href;
		
		// Check cache for results
		that.hideArtifactDetailsView();
		if (link.id === 'new_text_slide') {
			// wysiwyg editor tab handled differently than other content types
			showWysiwygEditor();
		} else if (contentCache[url]) {
			// Load from cache
			populateArtifactView(contentCache[url]);
		} else {
			new Ajax.Updater({success: artifactViewerId, failure: 'flash_notice'}, url, {
				asynchronous: true, 
				evalScripts:true, 
				method: 'get',
				parameters: '&view=memento_editor&authenticity_token=' + encodeURIComponent(window._token),
				onLoading: function(request) { spinner.load(artifactTypesId); },
				onComplete: function(request) { 
					spinner.unload(); 
					contentCache[url] = request.responseText;
					artifactViewPopulated();
				},
				onFailure: function() {
					showError("Unexpected error loading content...please try again");
				}
			});
		}
	};
		
	function artifactViewPopulated() {
		var paneId = currentPane[0].id;
		
		// If audio pane loaded
		if (paneId === AudioPaneId) {
			// Setup inline audio players
			if (inlinePlayer) {
				inlinePlayer.init();
			} else {
				inlinePlayer = new InlinePlayer();
			}
		}
	};
	
	function onTextEditorSave() {
		var val = textSlideEditor.getContents();
		if (val && (val !== '')) {
			if (artifactSelection.addSlide(val)) {
				showMessage('Text slide added');
			}
		} else {
			showError('You must enter some text before it can be added your movie!');
		}
	}
	// Public functions
	
	that.init = function() {
		// Create artifact tabs & click handlers
		jQuery('ul.tabs').tabs('div.panes > div', {
			effect: 'fade',
			onBeforeClick: function(event, i) {
				// get the pane to be opened
				currentPane = this.getPanes().eq(i);
				if (currentPane.is(":empty")) {
					// load it with a page specified in the tab's href attribute
					spinner.load('type_list'); 
					currentPane.load(this.getTabs().eq(i).attr("href"));
				} 
			}
		}	);	
		tabs = jQuery('ul.tabs').tabs('div.panes > div');
		currentPane = tabs.getPanes().eq(0);
		artifactPicker = ArtifactSelector.init(artifactViewerId);
		artifactSelection = ArtifactSelection.init(droppablesId);
		textSlideEditor = TextEditor.init();
		
		jQuery('#wysiwyg_form').submit(function() {
			onTextEditorSave();
			return false;
		});
		soundManager.onready(function(oStatus) {
		  if (!oStatus.success) {
		    showError('Error initializing sound...please reload the page.');
		  }
		});
		return this;
	};
	that.getArtifactPicker = function() {
		return artifactPicker;
	};
	that.refreshSelector = function() {
		spinner.unload();
		artifactViewPopulated();
		artifactPicker.refresh(currentPane);
	};
	that.hideArtifactDetailsView = function() {
		$(artifactDetailsId).update();
		$('drag_instructions').addClassName('hidden');
	};
	return that;
} ();

// WysiwygEditor handler
var TextEditor = function() {
	var that = {};
	
	var editor = null,
		selector = 'textarea.editor';
	
	function show(contents) {
		editor.setData(contents);
	};
	
	function hide() {
		editor.destroy();
	};
	
	function clear() {
		editor.setData('');
	};
	
	function getContents() {
		return editor.getData();
	};
	that.getContents = getContents;
	
	that.init = function() {
			// Setup wysiwyg editor
		jQuery('textarea.editor').ckeditor(function() { 
			/* callback code */
			editor = this; 
		}, mementosCKEditorConfig());
		jQuery('#clear_wysiwyg').click(function() { clear(); });
		return this;
	};
	return that;
} ();

// Artifact picker object
var ArtifactSelector = function() {
	var that = {};
	
	var scroller_el,
		scroller;
		
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
		var target = event.findElement();
		var div = getArtifactContainer(target), 
			info = null;

		if (div) {
			info = div.down('div.info');
		}
		if ((info !== null) && (info !== undefined)) {
			this.innerHTML = info.innerHTML;
		} else {
			this.innerHTML = '';
		}
	};
	// Init function - takes artifact view parent dom id
	that.init = function() {	
		return this;
	};
	// Create draggable objects
	that.createDraggables = function(items) {
		var opts = {revert: true};
		
		// Use dragdroppatch.js option 'superghosting' for non-audio divs in order to 
		// fix the dragging visibility bug & clone dragged object 
		if (items.size() && !items[0].hasClassName('audio')) {
			opts.superghosting = true;
		}
		items.each(function(i) {	
			new Draggable( i, opts );
		});
	};
	// Update selector pane
	that.refresh = function(pane) {
		var scroller;
		
		// Make all artifacts draggable
		this.createDraggables($A(jQuery(pane).find('.artifact')));
		
		// Create scrollable object for draggables if found on page
		scroller = jQuery(pane).find('.scrollable');
		if (scroller) {
			jQuery(scroller).scrollable({
				size: 5, 
				hoverClass: 'hoverActive'
			}).navigator().mousewheel();
			// Observe scrollable parent container for mouseover to handle all artifact mouseovers
			if ((infoDiv = pane.find('.artifact_info')) !== null) {
				pane.hover(function() { onArtifactMouseover.bindAsEventListener(infoDiv[0]); });
			}
		}
	};
	return that;
} ();

// Artifact slideshow items scroller
var ArtifactSelection = function() {
	var that = {};
	
	var selectionId,
		cleared = false,
		selectionScroller = null,
		selectedArtifact = null,
		audioSelection = null,
		playlistGenerator = null;
		soundtrackId = 'soundtrack-selection';
	
	function showNotice(msg, options) {
		flash_and_fade('editor_notice', msg);
	};
	// Called when artifact dropped on selector area
	function onArtifactAdded(draggable, droparea) { 
		var drophere = $A(selectionScroller.getItems()).last();
		var items = selectionScroller.getItemWrap();
		
		// Save artifact for other actions 
		selectedArtifact = draggable;
		jQuery(selectedArtifact).hover(function() {
			showArtifactEditForm(this);
			selectedArtifact = this; // Make it the selected item
		}, function() {
			// On hover out
		});
		// Move 'drop-here' box to the end
		drophere.remove();
		items.append(selectedArtifact);
		items.append(drophere);
		selectionScroller.reload().end();
		
		showActionLinks();
		showArtifactEditForm(selectedArtifact);
	};
	
	function showActionLinks() {
		$('selection_links').removeClassName('hidden');
	};
	function hideActionLinks() {
		$('selection_links').addClassName('hidden');
	};
	// Displays form for adding text description to an artifact
	function showArtifactEditForm(artifact) {
		var node;
		$('artifact_editor').removeClassName('hidden');
		
		// Populate with existing text description
		if (artifact.text_description !== undefined) {
			$('artifact_description').value = artifact.text_description;
		} else {
			$('artifact_description').value = $('artifact_description').defaultValue;
		}
		if ((node = artifact.down('img')) !== null) {
			$('arti_preview_img').innerHTML = '<img src="' + node.src + '"/>';
		}
		if ((node = artifact.down('div.info')) !== null) {
			$('arti_preview_details').removeClassName('hidden');
			$('arti_preview_details').innerHTML = node.innerHTML;
		}
	};
	function hideArtifactEditForm() {
		$('artifact_editor').addClassName('hidden');
		$('arti_preview_details').addClassName('hidden');
	};
	// Saves user-inputed text 
	function saveArtifactDescription() {
		if (selectedArtifact !== null) {
			selectedArtifact.text_description = $('artifact_description').value;
		}
		showNotice('saved');
	};
	// Removes all but the drophere div
	function clearItems() {
		var items = selectionScroller.getItems();
		var i, size = items.size();
		for (i=0; i<size-1; i++) {
			items[i].remove();
		}
		selectionScroller.reload();
		hideActionLinks();
		hideArtifactEditForm();
	};
	
	function togglePreview(link) {
		if (link.hasClassName('hide')) {		
			$('do_preview').innerHTML = 'Show preview';
			link.removeClassName('hide');
			$('preview_pane').hide();
		} else {
			$('do_preview').innerHTML = 'Hide preview';
			link.addClassName('hide');
			$('preview_pane').show();
			showPreview();
		}
	};
	// Generates preview slideshow
	function showPreview() {
		hideArtifactEditForm();
		movieGenerator.preview();
	};
	// Init function - takes artifact selection dom id
	that.init = function(droppablesId) {
		selectionId = '#' + droppablesId + ' .scrollable';
		
		// Make selection a drop target
		Droppables.add('selection-scroller', {
			hoverclass: 'selectorHover',
			onDrop: onArtifactAdded,
			accept: ['video', 'photo', 'video_thumb']
			//containment: 'artifact_picker'
		});
		// Make sortables container
		// Make selection a drop target
		Sortable.create('item_list', {
			tag: 'div',
			overlap: 'horizontal',
			constraint: 'horizontal',
			dropOnEmpty: true,
			hoverclass: 'hoverActive ',
			accept: ['video', 'photo']
		});
		
		// initialize scrollable widget & save object
		jQuery(selectionId).scrollable({item: 'div', clickable: true, activeClass: 'active', hoverClass: 'hoverActive'}).navigator();
		selectionScroller = jQuery(selectionId).scrollable();

		// initialize audio soundtrack container
		audioSelection = AudioSelection.init(soundtrackId);
		
		// create movie generator
		movieGenerator = MovieGenerator.init(selectionScroller, audioSelection);
		
		// Setup click handlers
		$('clear_selection').observe('click', clearItems);
		
		// Setup description input
		jQuery('#artifact_description').addClass("idleField");
		jQuery('#artifact_description').focus(function() {
			jQuery(this).removeClass("idleField").addClass("focusField");
			if (this.value == this.defaultValue){ 
				this.value = '';
			}
			if(this.value != this.defaultValue){
				this.select();
			}
		}, function() {
			jQuery(this).removeClass("focusField").addClass("idleField");
			if (jQuery.trim(this.value) == ''){
				this.value = (this.defaultValue ? this.defaultValue : '');
			}
		});
		/*
		jQuery('#artifact_description').blur(function() {
			jQuery(this).removeClass("focusField").addClass("idleField");
			if (jQuery.trim(this.value) == ''){
				this.value = (this.defaultValue ? this.defaultValue : '');
			}
		});
		*/			
		// Setup description save button click handler
		$('save_desc').observe('click', function(e) { e.stop(); saveArtifactDescription(); });
		$('do_preview').observe('click', function(e) { e.stop(); togglePreview(this); });
		
		return this;
	};

	return that;
} ();

var AudioSelection = function() {
	var that = {};
	
	var selection = new Array();
	var audioIcon = '<img src="/javascripts/timeline/icons/audio.png" width="15" height="15"/>';
	
	// Returns total duration of sountrack in seconds
	function getDuration() {
		var duration;
		return selection.inject(0, function(acc, audio) {
			if ((duration = audio.readAttribute('duration')) !== null) {
				return acc + parseInt(duration, 10);
			} else {
				return acc;
			}
		});
	};
	function onAudioAdded(draggable, droparea) {
		var text;
		
		console.log("audio added: " + draggable.id + " to " + droparea.id);
		selection.push(draggable);
		text =  "Soundtrack files: " + selection.map(function(audio) { 
			return audioIcon + audio.down('div.info').innerHTML;
		});
		droparea.innerHTML = text;
		console.log("total duration: " + getDuration());
	};

	that.init = function(soundtrackId) {
		// Make selection a drop target
		Droppables.add(soundtrackId, {
			hoverclass: 'soundtrackHover',
			onDrop: onAudioAdded,
			accept: ['audio']
		});
		return this;
	};
	return that;
}();

var MovieGenerator = function() {
	var that = {};

	var artifacts,
	soundtrack,
	duration,
	expose,
	seconds_per_frame,
	DefaultSecondsPerFrame = 5,
	slideInfoMap = new Hash();

	// Creates playlist array for Flowplayer from selected artifacts
	function generatePlaylist() {
		var src, info, playlist = [];

		if (artifacts.getSize() <= 1) {
			return playlist;
		}
		$A(artifacts.getItems()).each(function(item) {
			if (((src = item.readAttribute('src')) !== undefined) && (src !== null)) {
				if ((item.id.match('photo|^video') !== null)) {
					playlist.push(src);
				} else if (item.id.match('web_video') !== null) {
					playlist.push({url: src, scaling: 'fit'});
				} else if (item.id.match('music|audio') !== null) {
					playlist.push({url: src, duration: item.readAttribute('duration')});
				}
				// Save each clip's metadata for playblack event handlers
				if (item.text_description !== undefined) {
					slideInfoMap[src] = item.text_description;
				}
			}
		});
		return playlist;
	};
	
	// Calculates default clip duration in seconds
	function getDefaultClipDuration() {
		// If soundtrack is empty,
		return DefaultSecondsPerFrame;
	};
	// Create movie preview using existing selection
	that.preview = function() {
		var playlist = generatePlaylist();
		if (playlist.size() === 0) { return; }

		flowplayer('movie_player', FlowplayerSwfUrl, {
			key: FLOWPLAYER_PRODUCT_KEY,
			clip: {  
				// by default clip lasts 5 seconds 
				duration: getDefaultClipDuration(),
				// accessing current clip's properties 
				onStart: function(clip) { 
					// get access to a configured plugin
					var plugin = this.getPlugin("content");
					
					if (slideInfoMap[clip.url]) {
						console.log("playing clip with text: " + slideInfoMap[clip.url]);
						plugin.setHtml(slideInfoMap[clip.url]);
						//$('slide_caption').innerHTML = slideInfoMap[clip.url];
						//$('slide_caption').show();
					} else {
						plugin.setHtml('');
						//$('slide_caption').innerHTML = '';
						//$('slide_caption').hide();
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
			},
			
			// screen positioning inside background screen.
			screen: {		
				height:380, bottom: 0, left: 100
			},

			onStart: function() {
				expose.load(); 
			}, 

			// when playback finishes, close the expose 
			onFinish: function() { 
				expose.close(); 
			},
			// content specific event listeners and methods 
			onMouseOver: function() { 
				this.getPlugin("content").setHtml('Mouse over'); 
			}, 

			onMouseOut: function() { 
				this.getPlugin("content").setHtml('Mouse moved away. Please visit Finland someday.'); 
			},
					
			plugins: {
				controls: null,
				
				// content plugin settings
				content: {
					url: 'flowplayer.content-3.1.0.swf',

					// some display properties 
					width:260, height: 370, top:10, left: 10,
					borderRadius:30,
					padding: 15,			
					body: {fontSize:20},
					opacity: 0.7, 
					textDecoration: 'outline',
					
					// one styling property  
					backgroundGradient: [0.1, 0.1, 1.0], 

					// linked stylesheet 
					//stylesheet: 'content-plugin.css',
					
					// content plugin specific properties 
					html: ''
				}
				
				// Uncomment for production
				/*
				gatracker: { 
					url: "flowplayer.analytics-3.1.5.swf", 
					trackingMode: "Bridge"
				}
				*/
			}
		});
	};
	
	that.init = function(selection, audio) {
		artifacts = selection;
		soundtrack = audio;
		duration = 0;
		seconds_per_frame = 0;
		/* here is the exposing part of this demo */
		expose = jQuery("#preview_pane").expose({ 
			// return exposing API 
		  api: true
		});
		
		return this;
	};
	return that;
}();