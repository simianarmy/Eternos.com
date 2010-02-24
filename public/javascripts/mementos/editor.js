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

var flash_and_fade = function(id, message) {
	$(id).innerHTML = message;
	$(id).show();

	setTimeout(function() {
		new Effect.Fade(id);
	},
	5000);
};

var mementoFlash = function() {
	// Private functions
	function showMessage(message) {
		flash_and_fade('flash_notice', message);
	};

	function showError(message) {
		flash_and_fade('flash_error', message);
	};
	
	return {
		message: showMessage,
		error: showError
	};
} ();

var MementoEditor = function() {
	var that = {};

	var contentCache = {},
		artifactPicker = null,
		artifactSeletion = null,
		artifactViewerId = 'artifacts_list',
		artifactTypesId = 'type_list',
		wysiwygId = 'slide_text_editor',
		wysiwygEditor = null,
		droppablesId = 'scrollable_decorations',
		artifactDetailsId = 'artifacts_expanded_view',
		tabs = null,
		currentPane = null,
		AlbumPaneId = 'pane1',
		VideoPaneId = 'pane2',
		AudioPaneId = 'pane3',
		TextPaneId = 'pane4';

	

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
			new Ajax.Updater({
				success: artifactViewerId,
				failure: 'flash_notice'
			},
			url, {
				asynchronous: true,
				evalScripts: true,
				method: 'get',
				parameters: '&view=memento_editor&authenticity_token=' + encodeURIComponent(window._token),
				onLoading: function(request) {
					spinner.load(artifactTypesId);
				},
				onComplete: function(request) {
					spinner.unload();
					contentCache[url] = request.responseText;
					artifactViewPopulated();
				},
				onFailure: function() {
					mementoFlash.error("Unexpected error loading content...please try again");
				}
			});
		}
	};

	// Called when an artifacts tab pane dom is loaded
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
	that.init = function() {
		// Create wysiwyg widget 1st
		textSlideEditor = TextEditor.init();
		
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
				} else if (jQuery(currentPane).attr('id') === TextPaneId) {
					//textSlideEditor.load();
				}
			}
		}).history();
		tabs = jQuery('ul.tabs').tabs('div.panes > div');
		currentPane = tabs.getPanes().eq(0);
		
		artifactPicker = ArtifactSelector.init(artifactViewerId);
		artifactSelection = ArtifactSelection.init(droppablesId, textSlideEditor);
		
		jQuery('#wysiwyg_form').submit(function() {
			onTextEditorSave();
			return false;
		});
		soundManager.onready(function(oStatus) {
			if (!oStatus.success) {
				mementoFlash.error('Error initializing sound...please reload the page.');
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
	// Updates movie details data
	that.updateMovieDetails = function() {
		artifactSelection.getMovieGenerator().movieUpdated();
	};
	return that;
} ();

// WysiwygEditor handler
var TextEditor = function() {
	var that = {};

	var editor = null,
		selector = 'textarea.editor',
		editMode = false,
		initSaveButtonValue;

	function load() {
		editor.setData(jQuery('#wysiwyg_instructions').html());
		editMode = false;
		jQuery('#save_wysiwyg').attr('value', initSaveButtonValue);
	};
	that.load = load;
	
	function edit(contents) {
		editor.setData(contents);
		editMode = true;
		jQuery('#save_wysiwyg').attr('value', 'Save');
	}
	that.edit = edit;
	
	function clear() {
		editor.setData('');
	};
	that.clear = clear;
	
	function getContents() {
		return editor.getData();
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

	that.init = function() {
		// Setup wysiwyg editor
		jQuery('form#wysiwyg_form textarea.editor').ckeditor(function() {
			/* callback code */
			editor = this;
		},
		mementosCKEditorConfig());
		
		initSaveButtonValue = jQuery('#save_wysiwyg').attr('value');
		jQuery('#clear_wysiwyg').click(function() {
			clear();
		});
		return this;
	};
	return that;
} ();

// Artifact picker object
var ArtifactSelector = function() {
	var that = {};

	var scroller_el, scroller;

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
	// Init function - takes artifact view parent dom id
	that.init = function() {
		return this;
	};
	// Create draggable objects
	that.createDraggables = function(items) {
		var opts = {
			revert: true
		};

		// Use dragdroppatch.js option 'superghosting' for non-audio divs in order to 
		// fix the dragging visibility bug & clone dragged object 
		if (items.size() && items[0].hasClassName('video')) {
			opts.superghosting = true;
		}
		items.each(function(i) {
			new Draggable(i, opts);
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
		editingArtifact = null,
		soundtrackId = 'soundtrack-selection';

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
			newSlide = jQuery(newSlideDiv()).append(selectedArtifact.innerHTML);
			draggable.hide();
			duration = jQuery(selectedArtifact).attr('duration');
			selectedArtifact = newSlide[0];
			selectedArtifact.durationSeconds = parseFloat(duration); // Copy playtime in seconds
			// Make sure to create a draggable on the new element to keep drag&drop ordering support
			new Draggable(selectedArtifact, {
				revert: true
			});
		}
		addArtifact(selectedArtifact);
		showArtifactEditForm(selectedArtifact);
		
		onMovieUpdated();
	};
	
	// Called whenever artifact slide added or removed
	function onMovieUpdated() {
		movieGenerator.movieUpdated();
		showActionLinks();
	};
	
	// Adds artifact to scroller
	function addArtifact(artifact) {
		var drophere = getArtifacts().last();
		var items = selectionScroller.getItemWrap();
		
		// Add slide action links code & click handlers
		jQuery(artifact).append(
			jQuery('<div id="artifact-hover-menu-items"></div>').append(
				'<a href="#" class="remove_slide">remove</a>').append(
					artifact.userHtml ? ' | <a href="#editor.html" class="edit_slide">edit</a>' : '')
			);
	
		// Move 'drop-here' box to the end
		drophere.remove();
		items.append(artifact);
		selectionScroller.reload().end();
		items.append(drophere);
		selectionScroller.reload().end();

		if (!artifact.userHtml) {
			jQuery(artifact).hover(function() {
				showArtifactEditForm(this);
				selectedArtifact = this; // Make it the selected item
			},
			function() {
				// On hover out
			});
		}
		
		jQuery('.remove_slide').click(function() {
			removeArtifact(this.up('.artifact'));
		});
		
		jQuery('.edit_slide').click(function() {
			editSlideHtml(this.up('.artifact'));
		});
		
	};
	// Edit html slide action
	function editSlideHtml(artifact) {
		// Load artifact's text html into editor for editing
		editingArtifact = artifact;
		textEditor.edit(artifact.userHtml);
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
	
	// Returns div html for a new slide
	function newSlideDiv() {
		return '<div class="decoration_item artifact text"></div>';
	}
	
	// Show slide links
	function showActionLinks() {
		$('selection_links').removeClassName('hidden');
	};

	// Hide slide links
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
		mementoFlash.message('saved');
	};
	
	// Removes all but the drophere div
	function clearItems() {
		var items = selectionScroller.getItems();
		var i, size = items.size();
		for (i = 0; i < size - 1; i++) {
			items[i].remove();
		}
		selectionScroller.reload();
		hideActionLinks();
		hideArtifactEditForm();
	};

	// Toggle preview link text
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
	
	// Generates movie preview
	function showPreview() {
		hideArtifactEditForm();
		movieGenerator.preview();
	};
	
	// Public functions
	
	// Add html slide
	that.addHtmlSlide = function(html) {
		var slide = jQuery(newSlideDiv()).append('<img src="/javascripts/timeline/icons/doc.png" width="20" height="20" border="0"/>');
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
	
	// Init function - takes artifact selection dom id
	that.init = function(droppablesId, editor) {
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
			accept: ['ß', 'photo']
		});

		// initialize scrollable widget & save object
		jQuery(selectionId).scrollable({
			item: 'div',
			clickable: true,
			activeClass: 'active',
			hoverClass: 'hoverActive'
		}).navigator();
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
			if (this.value == this.defaultValue) {
				this.value = '';
			}
			if (this.value != this.defaultValue) {
				this.select();
			}
		},
		function() {
			jQuery(this).removeClass("focusField").addClass("idleField");
			if (jQuery.trim(this.value) == '') {
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
		$('save_desc').observe('click', function(e) {
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

var AudioSelection = function() {
	var that = {};

	var selection = new Array();
	var audioIcon = '<img src="/javascripts/timeline/icons/audio.png" width="15" height="15"/>';
	var dropTarget,
		ogDropareaHtml;
	
	// on audio dropped into droptarget
	function onAudioAdded(draggable, droparea) {
		var text;

		dropTarget = droparea; // Save this for when we want to empty it
		selection.push(draggable);
		text = "Soundtrack files: " + selection.map(function(audio) {
			return audioIcon + audio.down('div.info').innerHTML;
		});
		droparea.innerHTML = text;
		// Update movie details
		editor.updateMovieDetails();
	};

	// Removes all sounds
	function clearItems() {
		selection.clear();
		jQuery(dropTarget).html(ogDropareaHtml);
		editor.updateMovieDetails();
	};
	
	// Returns total duration of sountrack in seconds
	that.getDuration = function() {
		var duration;
		return selection.inject(0, function(acc, audio) {
			if ((duration = audio.readAttribute('duration')) !== null) {
				return acc + parseFloat(duration, 10).toFixed(2);
			} else {
				return acc;
			}
		});
	};
	
	that.init = function(soundtrackId) {
		// Make selection a drop target
		Droppables.add(soundtrackId, {
			hoverclass: 'soundtrackHover',
			onDrop: onAudioAdded,
			accept: ['audio']
		});
		
		ogDropareaHtml = jQuery('#soundtrack-selection').html();
		jQuery('#clear_sounds').click(function() {
			clearItems();
		});
		return this;
	};
	return that;
} ();

var MovieGenerator = function() {
	var that = {};

	var artifacts, soundtrack, expose, seconds_per_frame, DefaultSecondsPerFrame = 5,
		totalPlaytime,
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
					playlist.push({
						url: src,
						scaling: 'fit'
					});
				} else if (item.id.match('music|audio') !== null) {
					playlist.push({
						url: src,
						duration: item.readAttribute('duration')
					});
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
	
	// Returns # slides in movie
	function getNumSlides() {
		return artifacts.getSize() - 1;
	};
	
	// Converts seconds to MM:SS format
	function secondsToDuration(seconds) {
		var m = Math.floor(seconds / 60);
		var s = (seconds % 60).toFixed();
		return m + ':' + s.pad(2, "0");	
	};
	
	// Returns avg seconds per slide
	that.getAvgDurationPerSlide = function() {
		return avgDurationPerFrame;
	};
	
	// Returns total runtime
	that.getTotalDuration = function() {
		return totalPlaytime;
	};
	
	// Updates movie metadata
	that.movieUpdated = function() {
		var i, artis = artifacts.getItems();
		totalPlaytime = 0;
		seconds_per_frame = 0;

		for (i=0; i<getNumSlides(); i++) { 
			totalPlaytime += artis[i].durationSeconds ? artis[i].durationSeconds : getDefaultClipDuration(); 
		}
		totalPlaytime = Math.max(totalPlaytime, soundtrack.getDuration());
		avgDurationPerFrame = getNumSlides() ? (totalPlaytime / getNumSlides()).toFixed(2) : 0;
		
		jQuery('#duration').html('Total movie play time: ' + secondsToDuration(totalPlaytime));
		jQuery('#frames').html(getNumSlides() + ' frames');
		jQuery('#frame_seconds').html('Average frame display duration: ' + secondsToDuration(avgDurationPerFrame));
	};
	
	// Create movie preview using existing selection
	that.preview = function() {
		var playlist = generatePlaylist();
		if (playlist.size() === 0) {
			return;
		}
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
				height: 380,
				bottom: 0,
				left: 100
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
					width: 260,
					height: 370,
					top: 10,
					left: 10,
					borderRadius: 30,
					padding: 15,
					body: {
						fontSize: 20
					},
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
		totalPlaytime = 0;
		seconds_per_frame = 0;
		/* here is the exposing part of this demo */
		expose = jQuery("#preview_pane").expose({
			// return exposing API 
			api: true
		});

		return this;
	};
	return that;
} ();
