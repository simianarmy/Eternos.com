// Some Account Setup helper functions

var MAX_STEPS = 2;

// Callback for Facebook Backup App settings.
var on_facebook_backup_auth_close = function(check_url) {
	new Ajax.Request(check_url, { method: 'get',
		onSuccess:function(transport) {
			json = transport.responseText.evalJSON();
			updateSourceActivationIcon('fb', (json && json.authenticated) ? 'true' : 'false');
		}
	} );
}

function updateSourceActivationIcon(button, activate) {
	alert('updateSourceActivationIcon ' + button + ': ' + activate);
	var buttonEl = $(button + '-button');

	if (activate == 'true') {
		//alert('activating button ' + button);
		buttonEl.addClassName('active2');
		$('step1').addClassName('signup-active');
	} else {
		//alert('deactivating button ' + button);
		buttonEl.removeClassName('active2');
	}
}

function clearFlash() {
  $$('.flash_notice').each(function(e) { e.update(''); });
}

// Linear step activation function
function updateStep(check_url, completed_steps) {
	var sel;
	new Ajax.Request(check_url, {
		method: 'get',
		onSuccess:function(transport) {
			current_step = parseInt(transport.responseText);
			//alert('completed steps = ' + completed_steps + ' current step = ' + current_step);
			if (current_step > completed_steps) {
				showCompleteStep(current_step);
				if ((current_step+1) <= MAX_STEPS) {
					activateStep(current_step+1);
					highlightStep(current_step+1);
				}
			}
		}
	});
}

function activatedFb(){
  parent.document.getElementById('fb-button').setAttribute('class', 'fb-active');
}


