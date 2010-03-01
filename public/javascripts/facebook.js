// $Id$
// Facebook related objects & functions

var EternosFB = function() {
	return {
		create_account_form_cb: function() {
	    var api = FB.Facebook.apiClient;
		  var uid = api.get_session().uid;
			var fb_name_tag;
			var birthday;
			
		  // Get full name for form inputs
		  api.users_getInfo([uid], ["first_name", "last_name", "birthday_date", "email"], function(response, exception) {
				if (exception) {
					alert("Error logging you in, contact support");
				} else if ( response[0] ) {
					if ($('user_full_name')) {
						$('user_full_name').value = [response[0].first_name, response[0].last_name].join(' ');
					} else if ($('first-name')) {
		    		$('first-name').value = response[0].first_name;
		    		$('last-name').value = response[0].last_name;
					}
					$('email').balue = response[0].email;
					// Parse birthday string for date select
					if ((birthday = response[0].birthday_date) && (birthday !== '')) {
						dates = birthday.split('/');
						$('profile_birthday_2i').value = parseInt(dates[0]);
						$('profile_birthday_3i').value = parseInt(dates[1]);
						$('profile_birthday_1i').value = dates[2];
					}					
					if ($('new_account_form')) {
						new Effect.Highlight('new_account_form', { pulses: 3 });
						$('facebook-signup').fade({duration: 1.0, from: 1, to: 0.3});
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
