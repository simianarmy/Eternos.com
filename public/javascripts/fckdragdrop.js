// $Id$
// Found @ http://www.fckeditor.net/forums/viewtopic.php?f=5&t=6155
// Modified to be more OO
/*
KFCKDrag - a drag/drop thing for fckeditor
this plugin allows an external drag/drop item to be dragged into the FCKeditor window.
when the mouse is released, a function is called which decides what to do based on the dragged object type.
*/
window.parent.FCKeditor_OnComplete=function(FCK) {
	Events.AttachEvent( 'OnMouseUp', DoSomething ) ;
	// Create functions on object
	FCK.kfd_stopDragging = function(e) {
		if (this.kfd_dragstate) {
			console.log("event: stop dragging")
			this.kfd_dragstate=false;
			this.EditorDocument.body.removeChild(this.drag_wrapper);
			this.drag_wrapper=null;
			Draggables.activeDraggable.element.style.display='block';
			Draggables.endDrag(e);
		}
	}.bind(FCK);
	
	FCK.kfd_checkForDrop = function(e) {
		if (!this.kfd_dragstate) return; // nothing being dragged
		console.log("event: dropped item");
		var p=window.parent;
		var type=p.dragType,wrapper=p.drag_wrapper;
		var id=wrapper.id, content_html = wrapper.innerHTML;
		//this.Selection.SelectNode(e.currentTarget);
		//this.Selection.Collapse(false);
		this.InsertHtml('<object:'+id+'>'+ content_html + '</object>');
		e.stopPropagation();
		this.kfd_stopDragging(e);
		
	}.bind(FCK);
	
	FCK.kfd_dragstate=false;
	// These should be methods on FCK object
	kfd_windowEventsInit(FCK, FCK.EditorWindow,FCK.EditorDocument); // initialise window events
	kfd_elementEventsInit(FCK, FCK.EditorDocument); // add mouseup drop checker to every element
	// Attempt to determine where to start drawing cloned object in editor
	// This should get iframe editor area
	var f = FCK.EditorDocument.defaultView.frameElement;
	FCK.dragXoffset = f.offsetWidth;
	FCK.dragYoffset = f.offsetHeight;
	console.log("Editor offsets at %d, %d", FCK.dragXoffset, FCK.dragYoffset);
}
/*
function getEvent(e){
	return e?e:(window.event?window.event:"");
}
*/
function getMouseAt(e){
	var m=getWindowScrollAt();
	m.x+=e.clientX;
	m.y+=e.clientY;
	return m;
}
function getWindowSize(){
	return {x:window.innerWidth,y:window.innerHeight};
}
function getWindowScrollAt(){
	// This looks like the right way to do it
	//return FCKTools.GetDocumentPosition( window, FCK.EditingArea.IFrame ) ;
	// This is the og source way to do it
	return {x:window.pageXOffset,y:window.pageYOffset};
}
function kfd_elementEventsInit(FCK, doc) {
	var els=doc.getElementsByTagName('*');
	for(var i=0;i<els.length;++i){
		var el=els[i];
		if(el.kfd_initialised)continue;
		Event.observe(el, 'mouseup', FCK.kfd_checkForDrop);
		el.kfd_initialised=true;
	}
}

function kfd_windowEventsInit(FCK, win, doc) {
	Event.observe(win, 'mouseover',function(e) {
		console.log("event: mouseover editor");
		if (FCK.kfd_dragstate) return;
		if (Draggables.activeDraggable) {
			console.log("while dragging");
			//var p=window.parent;
			FCK.kfd_dragstate = true;
			// Cloning dragged object seems to be the only way to make it 
			// show up in editor area
			FCK.drag_wrapper = Draggables.activeDraggable.element.cloneNode(true);
			doc.body.appendChild(FCK.drag_wrapper);
			Draggables.activeDraggable.element.style.display='none';
		}
	}, true);
	
	Event.observe(doc, 'mouseout',function(e) {
		console.log("event: mouseout");
		//var m=getMouseAt(e),ws=getWindowSize();
		if ((e.clientX>=0 && e.clientX<FCK.dragXoffset && e.clientY>=0 && e.clientY<FCK.dragYoffset)) return; // browser bug triggers fake mouseouts sometimes...
		console.log("mouse at %d x, %d y", e.clientX, e.clientY);
		FCK.kfd_stopDragging(e);
	}, false);

	Event.observe(doc, 'mousemove',function(e) {
		if (!FCK.kfd_dragstate || (FCK.drag_wrapper === null)) return;
		console.log("dragging at %d x, %d y", e.clientX, e.clientY);
	//	FCK.drag_wrapper.style.left=(m.x+16)+'px';
	//	FCK.drag_wrapper.style.top=m.y+'px';
		FCK.drag_wrapper.style.left =  e.clientX + 'px';
		FCK.drag_wrapper.style.top =  (e.clientY-100) + 'px';
		console.log("object at %s, %s", FCK.drag_wrapper.style.left, FCK.drag_wrapper.style.top);
		//Draggables.activeDraggable.element.style.display='none';
		
	}, false);
}

