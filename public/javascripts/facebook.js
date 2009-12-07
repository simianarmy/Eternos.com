// $Id$
// Facebook related objects & functions

var EternosFB = function() {
	return {
		create_account_form_cb: function() {
	    var api = FB.Facebook.apiClient;
		  var uid = api.get_session().uid;
			var fb_name_tag;
			
		  // Get full name for form inputs
		  api.users_getInfo([uid], ["first_name", "last_name"], function(response, exception) {
				if (exception) {
					alert("Error logging you in, contact support");
				} else if ( response[0] ) {
					if ($('user_full_name')) {
						$('user_full_name').value = [response[0].first_name, response[0].last_name].join(' ');
					} else if ($('first_name')) {
		    		$('first-name').value = response[0].first_name;
		    		$('last-name').value = response[0].last_name;
					}
					if ($('new_account_form')) {
						new Effect.Pulsate('new_account_form', { pulses: 3 });
					}
				}
		  });
			if ($('fb-name')) {	
		  	fb_name_tag = "<fb:name uid='" + uid + "' useyou='false'></fb:name>";
		  	$('fb-name').innerHTML = 'Full Name: ' + fb_name_tag;
			}
			// Don't hide password fields - needed in case Facebook disconnected
		  //if ($('password-input')) $('password-input').hide();
		  //if ($('password-conf-input')) $('password-conf-input').hide();
			if ($('fb_pass_text')) {
				$('fb_pass_text').show();
			}
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
