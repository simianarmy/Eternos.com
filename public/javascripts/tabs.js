// $Id$

function tabselect(tab) {
  var tablist = $('tabcontrol1').getElementsByTagName('li');
  var nodes = $A(tablist);
  var lClassType = tab.className.substring(0, tab.className.indexOf('-') );

  nodes.each(function(node){
    if (node.id == tab.id) {
      tab.className=lClassType+'-selected';
    } else {
      node.className=lClassType+'-unselected';
    };
  });
}

function paneselect(pane) {
  var panelist = $('panecontrol1').getElementsByTagName('li');
  var nodes = $A(panelist);

  nodes.each(function(node){
    if (node.id == pane.id) {
      pane.className='pane-selected';
    } else {
      node.className='pane-unselected';
    };
  });
}

// Displays tabbed pane
function loadPane(pane) {
	if ((pane.innerHTML=='') || !busy_ctrl) {
	    reloadPane(pane, src);
	 }
}

// Loads a pane from a url src w/ Ajax update
function loadPane(pane, src) {
  if ((pane.innerHTML=='') || !busy_ctrl) {
    reloadPane(pane, src);
  }
}

function reloadPane(pane, src) {
  new Ajax.Updater(pane, src, {	method: 'get', asynchronous:1, evalScripts:true, 
		onLoading:load_busy($('container')), onComplete:unload_busy});
}