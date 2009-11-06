// $Id$
// Facebook related objects & functions

var EternosFB = function() {
	return {
		create_account_form_cb: function() {
	    var api = FB.Facebook.apiClient;
		  var uid = api.get_session().uid;
		  // Get full name for form inputs
		  api.users_getInfo([uid], ["first_name", "last_name"], function(response, exception) {
				if (exception) {
					alert("Error logging you in, contact support");
				} else if ( response[0] ) {
		    	$('first-name').value = response[0].first_name;
		    	$('last-name').value = response[0].last_name;
				}
		  });
		  var fb_name_tag = "<fb:name uid='" + uid + "' useyou='false'></fb:name>";
		  $('fb-name').innerHTML = 'Full Name: ' + fb_name_tag;
			// Don't hide password fields - needed in case Facebook disconnected
		  //if ($('password-input')) $('password-input').hide();
		  //if ($('password-conf-input')) $('password-conf-input').hide();
			$('fb_pass_text').show();
		  $('user_facebook_id').value = uid;
		  FB.XFBML.Host.parseDomTree(); 
	  },

		facebook_profile_request_cb: function(request, client_cb) {
			json = request.responseText.evalJSON();
			if (typeof client_cb === 'function') {	
				client_cb(json);
			} else if (typeof client_cb === 'object') {
				client_cb.json = json;
			} else {
				return json;
			}
		}
	};
}();
