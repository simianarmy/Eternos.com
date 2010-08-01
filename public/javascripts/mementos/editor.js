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

// Globals

var MementoEditor = function() {
	var that = {};

	var contentCache = {},
		artifactPicker = null,
		artifactSeletion = null,
		audioPicker = null,
		audioSelection = null,
		artifactViewerId = 'artifacts_list',
		artifactTypesId = 'type_list',
		wysiwygId = 'slide_text_editor',
		wysiwygEditor = null,
		droppablesId = 'scrollable_decorations',
		artifactDetailsId = 'artifacts_expanded_view',
		tabsSelector = 'ul#artifact-tabs',
		audioTabsSelector	= 'ul#soundtrack-tabs';

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
	that.init = function() {
		// Create wysiwyg widget 1st
		textSlideEditor = TextEditor.init();
		artifactPicker = ArtifactPicker.init(artifactViewerId, tabsSelector);
		audioPicker = AudioPicker.init(audioTabsSelector);
		artifactSelection = ArtifactSelection.init(droppablesId, textSlideEditor);
		
		jQuery('#wysiwyg_form').submit(function() {
			onTextEditorSave();
			return false;
		});
		
		return this;
	};
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
		spinner.unload();
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
					} else if (true || currentPane.is(":empty")) {
						// load it with a page specified in the tab's href attribute
						spinner.load('type_list');
						currentPane.load(this.getTabs().eq(i).attr("href"));
					} 
				}
			}
		}); 
		// tabs cacheing fucks up page refreshes
		//.history();
		tabs = jQuery(tabsSelector).tabs('div.panes1 > div');
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
		var scroller;
		var pane = currentPane;
		
		// Make all artifacts draggable
		this.createDraggables($A(jQuery(pane).find('.artifact')));

		// Create scrollable object for draggables if found on page
		scroller = jQuery(pane).find('.scrollable');
		if (scroller) {
			jQuery(scroller).scrollable({
				size: 5,
				hoverClass: 'hoverActive'
			});//.navigator().mousewheel();

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
			newSlide = jQuery(newSlideDiv()).append(selectedArtifact.innerHTML);
			draggable.hide();
			
			selectedArtifact = newSlide[0];
			// Copy dragged div's attributes
			selectedArtifact.id = draggable.id;
			selectedArtifact.writeAttribute('src', draggable.readAttribute('src'));
			if ((duration = draggable.readAttribute('duration')) !== null) {
				selectedArtifact.durationSeconds = parseFloat(duration); // Copy playtime in seconds
			}
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
		jQuery('slideshow_info').removeClass('hidden');
	};

	// Hide slide links
	function hideActionLinks() {
		jQuery('slideshow_info').addClass('hidden');
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
		onMovieUpdated();
	};

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
				width: MEMENTO.width + 40,
				height: MEMENTO.height + 40
			}
		});
		
		//new Effect.ScrollTo('preview_pane');  
		movieGenerator.preview();
	};
	
	// Public functions
	
	// Programmatically add artifacts (non drag&drop)
	that.addArtifacts = function(artifacts) {
		artifacts.each(function(i) {
			onArtifactAdded(i);
		});
	};
	
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

		// create movie generator
		movieGenerator = MovieGenerator.init(selectionScroller);
		
		// Setup click handlers
		$$('form.clear_slides').each(function(f) {
			f.observe('submit', function(e) { e.stop(); clearItems(); });
		});

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
						spinner.load('pane3');
						currentPane.load(this.getTabs().eq(i).attr("href"));
					} 
				}
			}
		}); 
		// tabs cacheing fucks up page refreshes
		//.history();
		tabs = jQuery(tabsSelector).tabs('div.panes2 > div');
		currentPane = tabs.getPanes().eq(0);
		
		soundManager.onready(function(oStatus) {
			if (!oStatus.success) {
				mementoFlash.error('Error initializing sound...please reload the page.');
			}
		});
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
		ogDropareaHtml,
		currentAudio = null;
	
	// on audio dropped into droptarget
	function onAudioAdded(draggable, droparea) {
		var text;
		var source;
		
		dropTarget = droparea; // Save this for when we want to empty it
		selection.push(draggable);
		text = "Soundtrack files: " + selection.map(function(audio) {
			return audioIcon + audio.readAttribute('fname');
		});
		droparea.innerHTML = text;
	};
	that.onAudioAdded = onAudioAdded;
	
	// Removes all sounds
	function clearItems() {
		selection.clear();
		jQuery(dropTarget).html(ogDropareaHtml);
	};
	
	// Returns list of track sources
	function getTracks() {
		var source;
		return selection.map(function(audio) {
			if ((source = audio.down('li a').href) !== null) {
				return source;
			}
		});
	};
	
	that.getSize = function() {
		return selection.size();
	};
	
	that.play = function() {
		var sounds;
		
		if (this.getSize() > 0) {
			sounds = getTracks();
		
			currentAudio = soundManager.createSound({
				id: "memento_soundtrack",
			  url: sounds[0],
			  volume: 50
			});
			currentAudio.play();
		}
	};
	
	that.stop = function() {
		if (currentAudio !== null) {
			currentAudio.stop();
			currentAudio = null;
		}
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
	
	that.init = function(domId) {
		selection = new Array();
		
		ogDropareaHtml = jQuery('#'+domId).html();
		$$('form.clear_sounds').each(function(f) {
			f.observe('submit', function(e) { e.stop(); clearItems(); });
		});
			
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
		jQuery('#duration').html('Total movie play time: ' + secondsToDuration(movie.getTotalDuration()));
		jQuery('#frames').html(movie.getNumSlides() + ' frames');
		jQuery('#frame_seconds').html('Average frame display duration: ' + secondsToDuration(movie.getAvgDurationPerSlide()));
		jQuery('#audio-info').html(movie.getSoundtrack().getSize() + ' audio tracks');
	};
	return {
		update: update
	};
}();

var MovieGenerator = function() {
	var that = {};

	var artifacts, soundtrack, expose, seconds_per_frame, 
		DefaultSecondsPerFrame = 5,
		initContentBoxWidth = 240,
		initContentBoxHeight = 400,
		soundtrackId = 'soundtrack-selection',
		totalPlaytime,
		slideInfoMap = new Hash();

	// Creates playlist array for Flowplayer from selected artifacts
	function generatePlaylist() {
		var i, src, info, item, playlist = [];
		
		if (artifacts.getSize() <= 1) {
			return playlist;
		}
		// Step through all slides but the last (dragdrop slide)
		var slides = artifacts.getItems();
		for (i=0; i<slides.size()-1; i++) {
			// If slide contains artifact
			item = slides[i];
			if (((src = item.readAttribute('src')) !== undefined) && (src !== null)) {
				if ((item.id.match('photo') !== null)) {
					playlist.push({
						url: src,
						scaling: 'fit',
						// by default clip lasts 5 seconds 
						duration: getAvgDurationPerSlide()
					});
					console.log("Adding image or video: " + src);
				} else if (item.id.match('video') !== null) {
					playlist.push({
						url: src,
						scaling: 'fit'
					});
					console.log("Adding video: " + src);
				} 
				// Save each clip's metadata for playblack event handlers
				if (item.text_description !== undefined) {
					slideInfoMap[src] = item.text_description;
				}
			} else if (item.userHtml) { // slide is text only
				// Use tiny image for "video" position for now
				// Generate id for this playlist item
				playlist.push({
					url: "/images/black.jpg",
					textId: 'text_' + i,
					duration: getAvgDurationPerSlide()
				});
				slideInfoMap['text_'+i] = item.userHtml;
			}
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
	
	// Returns total runtime
	that.getTotalDuration = function() {
		return totalPlaytime;
	};
	
	that.getSoundtrack = function() {
		return soundtrack;
	};
	
	// Wrapper to soundtrack handler
	function onAudioAdded(draggable, droparea) {
		soundtrack.onAudioAdded(draggable, droparea);
		that.movieUpdated();
	};
	
	// Helpers to determine position of slide in movie
	function isFirstSlide(playlist, clip) {
		return (playlist[0].url === clip.url);
	}
	// Helper to determine when movie is on last slide
	function isLastSlide(playlist, clip) {
		return (playlist[playlist.size()-1].url === clip.url);
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

		movieInfo.update(this);
	};
	
	// Create movie preview using existing selection
	that.preview = function() {
		var playlist = generatePlaylist();
		var text, boxWidth = initContentBoxWidth, boxHeight = initContentBoxHeight;
		var animateTextBoxOpenOptions = {width: boxWidth, height: boxHeight};
		
		if (playlist.size() === 0) {
			return;
		}
		flowplayer('movie_player', FlowplayerSwfUrl, {
			key: FLOWPLAYER_PRODUCT_KEY,
			clip: {
				// accessing current clip's properties 
				onStart: function(clip) {
					console.log("on clip " + clip.url);
					console.log("clip text: " + slideInfoMap[clip.url]);
					
					if (isFirstSlide(playlist, clip)) {
						//expose.load();
						// If there is a soundtrack, start it
						soundtrack.play();
					}
					// get access to a configured plugin
					
					var plugin = this.getPlugin("content");
					
					if ((text = slideInfoMap[clip.url]) !== undefined) {
						if (text === '') {
							boxWidth = boxHeight = 1;
						}
						plugin.animate(animateTextBoxOpenOptions, function() {
							this.setHtml(slideInfoMap[clip.url]);
						});
						//$('slide_caption').innerHTML = slideInfoMap[clip.url];
						//$('slide_caption').show();
					} else if (clip.textId) {
						plugin.animate({width: "100%", height: "100%"}, function() {
							this.setHtml(slideInfoMap[clip.textId]);
						});
					} else {
						// Hide content plugin
						plugin.animate({width: 1, height: 1}, function() {
							this.setHtml('');
						});
					}
					
				},
				
				onLastSecond: function(clip) {
					// If at end of movie...
					if (isLastSlide(playlist, clip)) {
						this.getPlugin("content").animate({width: boxWidth, height: boxHeight}, function() {
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
			},

			// screen positioning inside background screen.
			screen: {
				height: 400,
				bottom: 0,
				left: 110,
				right: 10
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
				controls: null,

				// content plugin settings
				content: {
					url: 'flowplayer.content-3.1.0.swf',

					// some display properties 
					width: initContentBoxWidth,
					height: initContentBoxHeight,
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
					opacity: 0.9,
					textDecoration: 'none',
					backgroundColor: '#BBE3FC',
					backgroundGradient: [0.1, 2, 0.1],

					/*
							initial HTML content. content can also be fetched from the HTML document
							*/
					html: ''
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
	
	that.init = function(selection) {
		artifacts = selection;
		soundtrack = Soundtrack.init(soundtrackId);

		totalPlaytime = 0;
		seconds_per_frame = 0;
		/*
		expose = jQuery("#preview_pane").expose({
			// return exposing API 
			api: true
		});
		*/
		// Make audio selection a drop target
		Droppables.add(soundtrackId, {
			hoverclass: 'soundtrackHover',
			onDrop: onAudioAdded,
			accept: ['audio']
		});
		
		return this;
	};
	return that;
} ();

