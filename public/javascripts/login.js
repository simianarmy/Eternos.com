// $Id$

// Include this file in member home page to initialize session timeout handlers and 
// other 1-time initializations

// Sets up observer to handle case when a session is timed out and a lightview 
// pop opens in an iframe.  Logs user out by redirect.
var handle_timeout_popups = function(timeout) {	
	var lastRequestTime = new Date().getTime();
	var clickTime;
	
  document.observe('lightview:opened', function(e) {
    clickTime = new Date().getTime();
    if ((clickTime - lastRequestTime) > (timeout * 1000)) {
			e.stop();
      Lightview.hide();
		  window.location = '/logout'; // Destroy session
		} 
	  lastRequestTime = new Date().getTime();
  });
};

var handle_account_setup = function() {
	document.observe('lightview:loaded', function() {
		Lightview.show({
			href:'/account_settings', 
			rel:'iframe',
			options:{
				ajax:{
					evalScripts:true, 
					method:'get'
				}, 
				autosize:false, 
				closeButton:false, 
				height:lightview_height, 
				width:800
				}});
				Event.observe(window, 'lightview:hidden', function(e) {
					window.location.reload();
				});
	});
};