// $Id$
//

jQuery.noConflict();
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

// jQuery:
// when DOM is loaded, create scrollable element
jQuery(document).ready(function($) {
  	// Using jquery.scrollable code
	  $("div.scrollable").scrollable({
	    size: 6,
	    hoverClass: 'hover'
	  });
		$().bind('reloadScroller', function() {
			$("div.scrollable").scrollable().reload();
		});
});


