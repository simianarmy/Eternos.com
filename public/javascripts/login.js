// $Id$

// Include this file in member home page to initialize session timeout handlers and 
// other 1-time initializations

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