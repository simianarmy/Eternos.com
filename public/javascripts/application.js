// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//var FLOWPLAYER_PRODUCT_KEY = '$3894b992d106ccc5f56';

// Put this in a early-loading script
// code yanked from the Yahoo media player. Thanks, Yahoo.
if (!("console" in window)) {
 	window.console = {log: function() {}, dir: function() {}};
}

// Global container
var ETERNOS = {session_timeout_seconds: 60*60*24};

// Global functionality
document.observe('dom:loaded', function() {
	lightview_height = 0.9 * win_dimension()[1];
  handle_timeout_popups(ETERNOS.session_timeout_seconds);
});

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

// Possible needs its own file if it grows too large.
// WARNING: UNTESTED
var AssetManager = function() {
	var that = {};
	var loaded = {};
	
	// Public methods
	function createScriptElement(url) {
	    var script = document.createElement("script");
	    script.type = "text/javascript";
	    script.language = "JavaScript";
	    script.src = url;
	    document.getElementsByTagName("head")[0].appendChild(script);
	};
	// Use this function to load js files dynamically during script execution
	that.loadJSFile = function(file) {
		if (document.body == null) {
	    try {
	        document.write("<script src='" + file + "' type='text/javascript'></script>");
	    } catch (e) {
	        createScriptElement(file);
	    }
		} else {
	    createScriptElement(file);
		}
	};
	// Use this to load CSS files dynamically
	that.loadCSSFile = function(file) {
		document.write("<link href='" + file + "' media='screen' rel='stylesheet' type='text/css'/>");
	};
	return that;
}();

function win_dimension() {
	if (window.innerHeight !==undefined) {
		A = [window.innerWidth,window.innerHeight]; // most browsers
	} else { // IE varieties
		var D = (document.body.clientWidth)? document.body: document.documentElement;
		A = [D.clientWidth,D.clientHeight];
	}
	return A;
}

function setDinamycHeight(id){
  height = win_dimension()[1];
  heightDiv = 0.83*height;
  $(id).style.height = heightDiv + "px";
	//resizeScrollbar();
}

function resetDinamycHeight(id){
  heightDiv = 590;
  $(id).style.height = heightDiv + "px";
  $(id).style.overflow = "hidden";
}

// What does this do??
function mark_for_destroy(element) {
	$(element).next('.should_destroy').value = 1;
	$(element).up('.pn').hide();
}

// TODO: Use ToggleOnClick Behavior instead
function toggle_show_select_display(field) {
	$(field+'_select').toggle(); $(field+'_show').toggle();
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
  document.cookie = name + '=' + value + expires + '; path=/';
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

    if ($(el).type && $(el).type.toLowerCase() == 'radio') {
     	radioGroup = $(el).name;
      el = $(el).form;
    } else if ($(el).tagName.toLowerCase() != 'form') {
        return false;
    }

    var checked = $(el).getInputs('radio', radioGroup).find(
        function(re) {return re.checked;}
    );
    return (checked) ? $F(checked) : null;
}

/**
 * Concatenates the values of a variable into an easily readable string
 * by Matt Hackett [scriptnode.com]
 * @param {Object} x The variable to debug
 * @param {Number} max The maximum number of recursions allowed (keep low, around 5 for HTML elements to prevent errors) [default: 10]
 * @param {String} sep The separator to use between [default: a single space ' ']
 * @param {Number} l The current level deep (amount of recursion). Do not use this parameter: it's for the function's own use
 */
function print_r(x, max, sep, l) {

	l = l || 0;
	max = max || 10;
	sep = sep || ' ';

	if (l > max) {
		return "[WARNING: Too much recursion]\n";
	}

	var
		i,
		r = '',
		t = typeof x,
		tab = '';

	if (x === null) {
		r += "(null)\n";
	} else if (t == 'object') {

		l++;

		for (i = 0; i < l; i++) {
			tab += sep;
		}

		if (x && x.length) {
			t = 'array';
		}

		r += '(' + t + ") :\n";

		for (i in x) {
			try {
				r += tab + '[' + i + '] : ' + print_r(x[i], max, sep, (l + 1));
			} catch(e) {
				return "[ERROR: " + e + "]\n";
			}
		}

	} else {

		if (t == 'string') {
			if (x == '') {
				x = '(empty)';
			}
		}

		r += '(' + t + ') ' + x + "\n";

	}

	return r;

};
var_dump = print_r;
