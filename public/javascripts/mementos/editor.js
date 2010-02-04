// $Id$
//
// Memento editor object

var MementoEditor = function() {
	var that = {};
	
	var contentCache = {},
		artifactPicker = null;
		
	// Private functions
	
	// Handles artifact type picker link click
	function onArtifactTypeLinkClick(url) {
		// Check cache for results
		if (contentCache[url]) {
			populateArtifactView(contentCache[url]);
		} else {
			new Ajax.Updater({success:'artifact_view',failure:'flash_notice'}, url, {
				asynchronous: true, 
				evalScripts:true, 
				method: 'get',
				parameters: '&view=memento_editor&authenticity_token=' + encodeURIComponent(window._token),
				onLoading: function(request) { spinner.load('artifact_view'); },
				onComplete: function(request) { 
					spinner.unload(); 
					//contentCache[url] = request.responseText.evalJSON();
					//populateArtifactView(contentCache[url]); 
				}
			});
		}
		return false;
	};
	
	function populateArtifactView(data) {
		$('artifact_view').update(data);
	};
	
	// Public functions
	
	that.init = function() {
		$$('#type_list li a').each(function(link) {
			link.observe('click', function(e) { onArtifactTypeLinkClick(e.element().href); e.stop(); });
		});
		artifactPicker = ArtifactSelector.init('artifact_view');
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
		
	that.init = function(parent) {
		parent_el = parent;
		scroller_css = '#' + parent_el + ' .scrollable';
		return this;
	};
	that.refresh = function() {
		scroller = jQuery(scroller_css).scrollable({size: 5});
	};
	return that;
} ();