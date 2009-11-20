var MAX_STEPS = 2;

document.observe("dom:loaded", function() {
	if ($('account-setting-content')) {
		setDinamycHeight('account-setting-content'); 
	}
	
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body);

  if (container) {
    var img = new Image;
    img.src = '/images/spinner.gif';

    function createSpinner() {
      new Element('img', { src: img.src, 'class': 'spinner' });
    }

    container.observe('click', function(e) {
      var el = e.element();
      if (el.match('.pagination a')) {
        el.up('.pagination').insert(createSpinner());
        new Ajax.Request(el.href, { asynchronous:true, evalScripts:true, method: 'get',
                        onLoading:function(request){$('progress-bar').show();}, 
                        onComplete:function(request){$('progress-bar').hide();} });
        e.stop();
      }
    })
  }
});

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
//	alert('updateSourceActivationIcon ' + button + ': ' + activate);
	var buttonEl = $(button + '-button');
	var stupidCSSFix = (button === 'fb') ? '-btn2' : '-btn';

	if (activate == 'true') {
		//alert('activating button ' + button);
		buttonEl.removeClassName(button+stupidCSSFix)
		buttonEl.addClassName(button+'-active');
	} else {
		//alert('deactivating button ' + button);
		buttonEl.removeClassName(button+'-active');
		buttonEl.addClassName(button+stupidCSSFix);
	}
}

function resizeScrollbar() {
	Scroller.updateAll();
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
				if (current_step == MAX_STEPS && (sel = $('account-setup-complete'))) {
					sel.show();
				}
			}
		}
	});
}

function highlightStep(step_id) {
  //var step = 'step' + stepNum;
  $(step_id).down('a').addClassName(step_id + '-active').removeClassName(step_id + '-btn');
  
  $$('.step').each(function(div) {
    if ((div.id !== step_id) && div.down('a').hasClassName(div.id + '-active')) {
      div.down('a').removeClassName(div.id + '-active');
      div.down('a').addClassName(div.id + '-btn');
    }
  });
}

// Activate next step
function activateStep(stepNum) {
	var step = 'step' + stepNum;
	$(step + '-disabled').hide();
	$(step).show();
}

function showCompleteStep(stepNum) {
	var step = 'step' + stepNum;
	$(step).down('a').addClassName(step + 'complete-btn');
}

function activatedFb(){
  parent.document.getElementById('fb-button').setAttribute('class', 'fb-active');
}


function toggleCustomTextRelation(id){
  $('select-relation-type-'+id).toggle();
  $('custom-relation-type-'+id).toggle();
  $('link-relation-back-'+id).toggle();
  $('link-relation-other-'+id).toggle();
}

function toggleCustomTextFamily(id){
  $('select-family-type-'+id).toggle();
  $('custom-family-type-'+id).toggle();
  $('link-family-back-'+id).toggle();
  document.getElementById('select-family-type-'+id+'').selectedIndex=0;
}

function getRegion(val,elementId){
  new Ajax.Request('/account_settings/select_region/'+val, {asynchronous:true, evalScripts:true, method:'get',parameters:'cols_id='+elementId+'',
                   onLoading:function(request){$('loading-image-'+elementId).show();}, 
                   onComplete:function(request){$('loading-image-'+elementId).hide();} });return false;
}



function deleteFormMedicalCondition(){
  $('add-new-medical-condition').remove();   
  if ($('form_medical_condition').value == "1"){
    $('save-button-medical-condition').hide();
    window.counter_medical_condition = 1;
  }else{
    val = $('form_medical_condition').value;
    $('form_medical_condition').value =(val - 1);
  }
}

function deleteFormFamily(){
  $('add-new-family').remove();
  if ($('form_family').value == "1"){
    $('save-button-family').hide();
    window.counter_family = 1;
  }else{
    val = $('form_family').value;
    $('form_family').value =(val - 1);
  }
}

function showOtherTextbox(val, id){
  if(val=='Other'){
    $('select-family-type-'+id).toggle();
    $('custom-family-type-'+id).toggle();
    $('link-family-back-'+id).toggle();
  }
}

function toPresentText(text, val, description){
  if(val){
    var content = $('present-'+text+'-'+val+'');
    if(content.innerHTML==""){
      createDateElement(text, val);
      $('text-present-'+text+'-'+val+'').innerHTML = description;
    }else{
      $('date-present-'+text+'-'+val+'').remove();  
      $('text-present-'+text+'-'+val+'').innerHTML = "<b>To Present<b>";
    }
  } 
}
