// $Id$
//
// Memento editor object

var MementoEditor = function() {
	var that = {};
	
	var contentCache = {},
		artifactPicker 		= null,
		artifactSeletion	= null,
		artifactViewerId 	= 'artifact_view',
		artifactTypesId	 	= 'type_list',
		droppablesId		 	= 'scrollable_decorations';
		
	// Private functions
	
	// Handles artifact type picker link click
	function onArtifactTypeLinkClick(url) {
		// Check cache for results
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
		//that.refreshSelector();
	};
	
	// Public functions
	
	that.init = function() {
		$$('#' + artifactTypesId + ' li.artitype a').each(function(link) {
			link.observe('click', function(e) { 
				e.stop(); 
				onArtifactTypeLinkClick(e.element().href); 
				return false; 
			});
		});
		artifactPicker = ArtifactSelector.init(artifactViewerId);
		artifactSelection = ArtifactSelection.init(droppablesId);
		
		return this;
	};
	that.refreshSelector = function() {
		artifactPicker.refresh();
	}
	return that;
} ();

// Artifact picker object
var ArtifactSelector = function() {
	var that = {};
	
	var parent_el,
		scroller_el,
		scroller;
		
	// Init function - takes artifact view parent dom id
	that.init = function(parent) {
		parent_el = parent;
		scroller_css = '#' + parent_el + ' .decoration_item';
		return this;
	};
	// Update
	that.refresh = function() {
		jQuery('#' + parent_el + ' .scrollable').scrollable({size: 5});
		$$(scroller_css).each(function(i) {
			new Draggable( i, {
				revert: true,
				ghosting: true
			});
		});
	};
	return that;
} ();

// Artifact slideshow items scroller
var ArtifactSelection = function() {
	var that = {};
	
	var selectionId;
	
	function onArtifactAdded(draggable, droparea) { 
		alert('added ' + draggable);
	}
	
	// Init function - takes artifact selection dom id
	that.init = function(droppablesId) {
		selectionId = droppablesId;
		
		// Make selection a drop target
		Droppables.add(selectionId, {
			hoverclass: 'hoverActive',
			onDrop: onArtifactAdded
		});
		
		// initialize scrollable widget
		jQuery('#' + selectionId + ' .scrollable').scrollable();
		
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
