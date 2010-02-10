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
		
	// info div element is bound to the function's scope
	function onArtifactMouseover(event) {
		var target = event.findElement();
		var div, info;

		// Look for artifact container element
		if (target.hasClassName('decoration_item')) { 
			div = target;
		} else {
			div = target.up('.decoration_item');
		}
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
		selectedArtifact = null;
	
	function showNotice(msg, options) {
		$('editor_notice').update(msg);
		//$('editor_notice').removeClassName('hidden');
		$('editor_notice').fade({ duration: 3.0, from: 1, to: 0 });
	};
	// Called when artifact dropped on selector area
	function onArtifactAdded(draggable, droparea) { 
		var drophere = $A(selectionScroller.getItems()).last();
		var items = selectionScroller.getItemWrap();
		
		console.log("added artifact to droppable target: " + droparea.id);
		// Save artifact for other actions 
		selectedArtifact = draggable;
		jQuery(selectedArtifact).hover(function() {
			// Need to add class for remove icon
		});
		jQuery(selectedArtifact).click(function() {
			showArtifactEditForm(this);
		});
		// Move 'drop-here' box to the end
		drophere.remove();
		items.append(draggable);
		items.append(drophere);
		selectionScroller.reload().end();
		
		showActionLinks();
		showArtifactEditForm(draggable);
	};
	
	function showActionLinks() {
		$('selection_links').removeClassName('hidden');
	};
	function hideActionLinks() {
		$('selection_links').addClassName('hidden');
	};
	// Displays form for adding text description to an artifact
	function showArtifactEditForm(artifact) {
		$('artifact_editor').removeClassName('hidden');
		// Populate with existing text description
		if (artifact.text_description !== undefined) {
			$('artifact_description').value = artifact.text_description;
		} else {
			$('artifact_description').value = $('artifact_description').defaultValue;
		}
		$('arti_preview').update(artifact.innerHTML);
	};
	function hideArtifactEditForm() {
		$('artifact_editor').addClassName('hidden');
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
	// Creates playlist array for Flowplayer from selected artifacts
	function generatePlaylist() {
		var src, playlist = [];
		
		if (selectionScroller.getSize() <= 1) {
			return playlist;
		}
		$A(selectionScroller.getItems()).each(function(item) {
			if (((src = item.readAttribute('src')) !== undefined) && (src !== null)) {
				if ((item.id.match('photo|^video') !== null)) {
					playlist.push(src);
				} else if (item.id.match('web_video') !== null) {
					playlist.push({url: src, scaling: 'fit'});
				} else if (item.id.match('music|audio') !== null) {
					playlist.push({url: src, duration: item.readAttribute('duration')});
				}
			}
		});
		return playlist;
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
		var playlist = generatePlaylist();
		if (playlist.size() === 0) { return; }
		console.dir(playlist);
		
		hideArtifactEditForm();
		
		flowplayer('preview_pane', FlowplayerSwfUrl, {
			key: FLOWPLAYER_PRODUCT_KEY,
			clip: {  
			 	// by default clip lasts 5 seconds 
			 	duration: 5         
			},
			// first entry in a playlist work as a splash image
			playlist: playlist,
			
			logo: {
				url: '/images/favico.png',
				fullscreenOnly: false
			},
			plugins: {
				// content plugin settings
				content: {
					url: 'flowplayer.content-3.1.0.swf',
					
					// some display properties 
					width: "50%",
					height: 220,
					padding:30, 
					backgroundColor: '#112233', 
					opacity: 0.7, 

					// one styling property  
					backgroundGradient: [0.1, 0.1, 1.0], 

					// content plugin specific properties 
					html: '<p>This big overlay is a content plugin</p>', 
					style: {p: {fontSize: 40}}
				},

				// and a bit of controlbar skinning   
				controls: { 
					playlist: true, 
					backgroundColor:'#002200', 
					height: 30, 
					stop: true 
				}
			}
		});
	};
	// Init function - takes artifact selection dom id
	that.init = function(droppablesId) {
		selectionId = '#' + droppablesId + ' .scrollable';
		
		// Make selection a drop target
		Droppables.add('selection-scroller', {
			hoverclass: 'selectorHover',
			onDrop: onArtifactAdded,
			accept: ['decoration_item', 'gallery_item']
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
			only: ['decoration_item', 'gallery_item']
		});
		
		// initialize scrollable widget
		jQuery(selectionId).scrollable({item: 'div', clickable: true, activeClass: 'active', hoverClass: 'hoverActive'}).navigator();
		// Save handle to plugin
		selectionScroller = jQuery(selectionId).scrollable();
		
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
