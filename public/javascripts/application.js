// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//var FLOWPLAYER_PRODUCT_KEY = '$3894b992d106ccc5f56';

function mark_for_destroy(element) {
	$(element).next('.should_destroy').value = 1;
	$(element).up('.pn').hide();
}

// TODO: Use ToggleOnClick Behavior instead
function toggle_show_select_display(field) {
	$(field+'_select').toggle(); $(field+'_show').toggle();
}

// For ajax busy spinner
var busy_ctrl;
function load_busy(element) {
	busy_ctrl = getBusyOverlay(element)
}

function unload_busy() {
	try {busy_ctrl.remove(); delete busy_ctrl;} catch(e) {}
}

function show(target) {
  $(target).show();
}

function hide(target) {
  $(target).hide();
}

// Form validation

function checkPresence(field) {
	var hint = $F(field).length == 0 ? "Please enter " + field : "";
	if ($(field + '_hint')) {
		$(field + '_hint').update(hint);
	} else {
		/*content = '<span class="validation" id="' + field + '_hint">' + 
			hint + '</span>';
		new Insertion.After(field, content);
		*/
		alert($(field+'_hint').value);
	}
}

function create_cookie(name, value, days) {
  //jar = new CookieJar({expires: 60, path: '/'});
  //jar.put(name, id);
  var expires = "";
  if (days) {
	var date = new Date();
	date.setTime(date.getTime()+(days*24*60*60*1000));
	expires = "; expires="+date.toGMTString();
  }	
  document.cookie = name + '=' + value + expires + '; path=/'
}

/**
* Returns the value of the selected radio button in the radio group, null if
* none are selected, and false if the button group doesn't exist
*
* @param {radio Object} or {radio id} el
* OR
* @param {form Object} or {form id} el
* @param {radio group name} radioGroup
*/
function $RF(el, radioGroup) {
    if($(el).type && $(el).type.toLowerCase() == 'radio') {
        var radioGroup = $(el).name;
        var el = $(el).form;
    } else if ($(el).tagName.toLowerCase() != 'form') {
        return false;
    }

    var checked = $(el).getInputs('radio', radioGroup).find(
        function(re) {return re.checked;}
    );
    return (checked) ? $F(checked) : null;
}


