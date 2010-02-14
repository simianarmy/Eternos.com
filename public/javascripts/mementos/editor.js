// $Id$
//
// Memento editor object

var MementoEditor = function() {
	var that = {};
	
	var contentCache = {},
		artifactPicker 		= null,
		artifactSeletion	= null,
		artifactViewerId 	= 'content_pane',
		artifactTypesId	 	= 'type_list',
		droppablesId		 	= 'scrollable_decorations',
		artifactDetailsId	= 'artifacts_expanded_view';
		
	// Private functions
	
	// Handles artifact type picker link click
	function onArtifactTypeLinkClick(url) {
		// Check cache for results
		that.hideArtifactDetailsView();
		if (contentCache[url]) {
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
					//populateArtifactView(contentCache[url]); 
				}
			});
		}
	};
	
	function populateArtifactView(data) {
		$(artifactViewerId).update(data);
	};
	
	function showWysiwygEditor() {
		$('wysiwig').removeClassName('hidden');
	};
	// Public functions
	
	that.init = function() {
		// Observe tab link clicks
		$$('#' + artifactTypesId + ' li.artitype a').each(function(link) {
			link.observe('click', function(e) { 
				e.stop(); 
				onArtifactTypeLinkClick(this.href); 
				return false; 
			});
		});
		// Observe text slide tab separately
		$('next_text_slide').observe('click', function(e) { e.stop(); showWysiwygEditor(); });
		
		artifactPicker = ArtifactSelector.init(artifactViewerId);
		artifactSelection = ArtifactSelection.init(droppablesId);
		
		return this;
	};
	that.getArtifactPicker = function() {
		return artifactPicker;
	};
	that.refreshSelector = function() {
		artifactPicker.refresh();
	};
	that.hideArtifactDetailsView = function() {
		$(artifactDetailsId).update();
	};
	return that;
} ();

// Artifact picker object
var ArtifactSelector = function() {
	var that = {};
	
	var parent_el,
		scroller_el,
		scroller;
		
	// Helper to return div containing artifact
	function getArtifactContainer(arti) {
		// Look for artifact container element
		if (arti.hasClassName('decoration_item')) { 
			return arti;
		} else {
			return arti.up('.decoration_item');
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
	that.init = function(parent) {
		parent_el = parent;
		scroller_css = '#' + parent_el + ' .decoration_item';
		
		return this;
	};
	// Create draggable objects
	that.createDraggables = function(selector) {
		$$(selector).each(function(i) {	
			new Draggable( i, {
				revert: true,
				ghosting: true
			});
		});
	};
	// Update selector pane
	that.refresh = function() {
		// Make all artifacts draggable
		this.createDraggables(scroller_css);
		// Create scrollable object
		jQuery('#' + parent_el + ' .scrollable').scrollable({
			size: 5, 
			hoverClass: 'hoverActive'
		}).navigator().mousewheel();
		// Observe scrollable parent container for mouseover to handle all artifact mouseovers
		if ((infoDiv = $('artifact_info')) !== null) {
			$(parent_el).observe('mouseover', onArtifactMouseover.bindAsEventListener(infoDiv));
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
		var notice = $('editor_notice');
		
		notice.removeClassName('hidden');
		notice.update(msg);
		notice.show(); // required after fade
		notice.fade({ duration: 3.0, from: 1, to: 0 });
	};
	// Called when artifact dropped on selector area
	function onArtifactAdded(draggable, droparea) { 
		var drophere = $A(selectionScroller.getItems()).last();
		var items = selectionScroller.getItemWrap();
		
		console.log("added artifact to droppable target: " + droparea.id);
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
		showNotice('saved', {fade: true});
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
			accept: ['video', 'photo']
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