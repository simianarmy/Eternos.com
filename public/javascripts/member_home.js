// $Id$
//
// Member home page javascript 

function onSearchComplete() {
  $('events').hide(); $('back-to-events-button').show();
}
function onShowEvents() {
  $('search-results').hide(); $('events').show(); $('back-to-events-button').hide();
}
function createTagCloud(tag_cloud_url, opts) {
	// Build tag cloud
	// Having fun with prototype + jquery
  jQuery.getJSON(tag_cloud_url, function(data) {
    //create list for tag links
    jQuery("<ul>").attr("id", "tagList").appendTo("#tag-cloud");
    //create tags
    jQuery.each(data.tags, function(i, val) {
      //create item
      var li = jQuery("<li>");
	
      jQuery("<a>").text(val.tag).attr({title:"See all events tagged with " + val.tag, 
				href: opts.user_search_path + val.tag}).appendTo(li);
			li.children().css("fontSize", (val.freq / 10 < 1) ? val.freq / 10 + 1 + "em": (val.freq / 10 > 2) ? "2em" : val.freq / 10 + "em");
			
      //add to list
      li.appendTo("#tagList");
    });
  });
}

document.observe('dom:loaded', function() {
	lightview_height = 0.9 * win_dimension()[1];
  handle_timeout_popups(ETERNOS.session_timeout_seconds);

	// Reload timeline after a lightview popup closes
	Event.observe(window, 'lightview:hidden', function(e) { 
    //ETERNOS.timeline.reload(); 
  });
});

