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
				ghosting: false,
				zindex: 100000
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
			item: 'div'
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
		selectionScroller = null;
	
	function onArtifactAdded(draggable, droparea) { 
		var drophere = $A(selectionScroller.getItems()).last();
		
		console.log("added artifact to droppable target: " + droparea.id);

		// Move 'drop-here' box to the end
		drophere.remove();
		selectionScroller.getItemWrap().append(draggable);
		selectionScroller.reload();
		selectionScroller.getItemWrap().append(drophere);
		selectionScroller.reload().end();
	};
	// Removes all but the drophere div
	function clearItems() {
		var items = selectionScroller.getItems();
		var i, size = items.size();
		for (i=0; i<size-1; i++) {
			items[i].remove();
		}
		selectionScroller.reload();
	};
	// Init function - takes artifact selection dom id
	that.init = function(droppablesId) {
		selectionId = '#' + droppablesId + ' .scrollable';
		
		// Make selection a drop target
		Droppables.add('selection-scroller', {
			hoverclass: 'hoverActive',
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
			hoverclass: 'hoverActive',
			only: ['decoration_item', 'gallery_item']
		});
		
		// initialize scrollable widget
		jQuery(selectionId).scrollable({item: 'div', hoverClass: 'hover'}).navigator();
		// Save handle to plugin
		selectionScroller = jQuery(selectionId).scrollable();
		
		$('clear_selection').observe('click', clearItems);
		// Make selection items sortable
					/*
		jQuery('#' + selectionId).sortable({
			items: '.artifact',
			opacity: 0.6
			update: function(event, ui) {
				jQuery.ajax({
					type: "POST",
					url: this.readAttribute('target'),
					processData: true,
					dataType: 'script',
					data: jQuery(selectionId).sortable('serialize') + '&' + window._token
				});
			}
		});
					*/
		return this;
	};
	return that;
} ();
