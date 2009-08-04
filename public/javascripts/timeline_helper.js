/*
 * Eternos Timeline classes using prototype method:Class.create({})
 * 
 * Classes are:
 * 
 * ETLDate
 * ETLArray
 * ETLDom
 * ETLDomArtifact
 * ETLDomEvent
 * ETLDomArtifactItem
 * ETLDomEventItem
 * ETLEventSource
 * ETLEventSourceFacebook
 * ETLEventSourceTwitter
 * ETLEventSourceBackupPhoto
 * ETLEventSourceFeed
 * ETLEventSourceEmail
 * ETLEventParser
 * ETLSearch
 * ETLBase
 * 
 * 
 */ 


//Eternos Timeline Date
var ETLDate = Class.create({
  initialize: function(date, format){
    this.inDate = date;
    this.inFormat = format || 'natural';
    this.getOutDate();
  },
  getOutDate: function(){
    if(this.inFormat == 'natural'){
      this.outDate = this.inDate.getFullYear() +'-'+ this.inDate.getMonth() +'-'+ this.inDate.getDate();
    } else {
      this.outDate = new Date(this.inDate.substr(0, 4), this.inDate.substr(5, 2), this.inDate.substr(8, 2));
    }
  }
})


//Eternos Timeline Array that has custom methods 
function ETLArray() {
  this.unique = function(){
  	var r = new Array();
  	o:for(var i = 0, n = this.length; i < n; i++){
  		for(var x = 0, y = r.length; x < y; x++){
  			if(r[x]==this[i]){ continue o;}
  		}
  		r[r.length] = this[i];
  	}
  	return r;
  }
  
  this.randResult = function(num){}
}
ETLArray.prototype = new Array();


//Eternos Timeline DOM for Artifact and Story
var ETLDom = Class.create({
  initialize: function(domID){
    this.parent = $(domID);
    this.title = "";
    this.top = "";
    this.bottom = "";
    this.items = new ETLArray();
    this.resetItems();
  },
  itemsToHtml: function(){
    for(i=0;i<this.items.length;i++){
      this.items[i] = this.items[i].toHtml();
    }
  },
  resetItems: function(){
    this.parent.innerHTML = "";
  },
  makeItemsUniq: function(){
    this.items.unique();
  },
  itemsToHtml: function(){
    return this.items.join("");
  },
  write: function(){
    this.itemsToHtml();
    this.makeItemsUniq();
    this.parent.insert(this.top+this.itemsToHtml+this.bottom);
  },
  addItem: function(item){
    this.items.push(item);
  },
  setTitle: function(title){
    this.title = title;
  },
  setTop: function(top){
    this.top = top;
  },
  setBottom: function(bottom){
    this.bottom = bottom;
  }
})


//Eternos Timeline Artifact, inherited from ETLDom
var ETLDomArtifact = Class.create(ETLDom, {
  initialize: function($super, domId){
    $super(domId);
    this.setTitle("Artifacts");
    this.setTop("<div class='artibox-top'><div class='title5'>" +this.title+ "</div></div><div class='artibox'>");
    this.setBottom("</div><img src='/images/artibox-bottom.gif' />");
  }
})


//Eternos Timeline Story, inherited from ETLDom
var ETLDomEvent = Class.create(ETLDom, {
  initialize: function($super, domId){
    $super(domId);
    this.setTitle("Stories");
    this.setTop("<div class='storybox-top'><div class='title5'>" +this.title+ "</div></div><div class='storybox'>");
    this.setBottom("</div><img src='/images/storybox-bottom.gif' />");
  }
})


//Eternos Timeline Artifact Item, with source from 'event' in evalJSON response
var ETLArtifactItem = Class.create({
  initialize: function(event){
    this.sourceEvent = event;
    this.thumbHeight = 70;
    this.thumbWidth = 70;
    this.popImg();
  },
  popImg: function(){
    if (this.sourceEvent.facebook_activity_stream_item){
      if (this.sourceEvent.facebook_activity_stream_item.attachment_type == "photo"){
        this.imageUrl = this.sourceEvent.facebook_activity_stream_item.src;
        this.itemType = "Facebook";
      }
    } else if (this.sourceEvent.backup_photo){
      this.imageUrl = this.sourceEvent.backup_photo.source_url;
      this.itemType = "Backup Photo";
    }     
  },
  toHtml: function(){
    rv = (this.imageUrl == "" || this.imageUrl == undefined) ? "" : "<a href=# onclick=\"Lightview.show( {href:'"+this.imageUrl+"', options:{ajax:{evalScripts:true, method:'get', parameters:'&authenticity_token='+ encodeURIComponent('cd0107f95e066667938b7f27f3b4732cf8ace5ca')}, autosize:false, closeButton:false, width:800}, rel:'iframe'});return false;\"><img src='" +this.imageUrl+ "' class='thumnails2' /></a>";
    return rv;      
  }
})
  

//Eternos Timeline Story Item
var ETLEventItem = Class.create({
  initialize: function(event){
    this.sourceEvent = event;
    this.thumbHeight = 70;
    this.thumbWidth = 70;
    this.popImg();
  },
  popImg: function(){
    if (this.sourceEvent.facebook_activity_stream_item){
      if (this.sourceEvent.facebook_activity_stream_item.attachment_type == "photo"){
        this.imageUrl = this.sourceEvent.facebook_activity_stream_item.src;
        this.itemType = "Facebook";
      }
    } else if (this.sourceEvent.backup_photo){
      this.imageUrl = this.sourceEvent.backup_photo.source_url;
      this.itemType = "Backup Photo";
    }     
  },
  toHtml: function(){
    rv = (this.imageUrl == "" || this.imageUrl == undefined) ? "" : "<a href=# onclick=\"Lightview.show( {href:'"+this.imageUrl+"', options:{ajax:{evalScripts:true, method:'get', parameters:'&authenticity_token='+ encodeURIComponent('cd0107f95e066667938b7f27f3b4732cf8ace5ca')}, autosize:false, closeButton:false, width:800}, rel:'iframe'});return false;\"><img src='" +this.imageUrl+ "' class='thumnails2' /></a>";
    return rv;      
  }
})


//Eternos Timeline Event Source
var ETLEventSource = Class.create({
  initialize: function(event){
    this.assetUrl = "http://simile.mit.edu/timeline/api/";
    this.imgUrl = this.assetUrl + "images/";
    this.title = this.desc = this.img = this.link = this.icon = this.color = this.tcolor = null;
    this.date = new Date();
    this.event = event;
  },
  toTLEventSource: function(){
    this.outEvent = new Timeline.DefaultEventSource.Event(
      this.date, this.date, this.date, this.date, true, 
      this.title, this.desc, this.img, this.link, this.icon, this.color, this.tcolor);

    return this.outEvent;
  }
})


//Eternos Timeline Facebook Event Source
var ETLEventSourceFacebook = Class.create(ETLEventSource, {
  initialize: function($super, event){
    $super(event);
    this.icon = this.imgUrl + "dark-blue-circle.png";
    this.color = "blue";
    this.textColor = "blue";
    this.fetchEvent();
  },
  fetchEvent: function(){
    if (this.event.published_at) {
      this.date = new ETLDate(this.event.published_at).outputDate;
    }
    
    switch (this.event.attachment_type) {
      case "photo" :
        this.title = "Uploaded photo";
        this.desc = fb_event.message;
        this.img = fb_event.src;
        break;
      case "link" :
        this.title = "Wall posting";
        this.desc = fb_event.message;
        this.link = fb_event.src;
        break;
      case null :
        this.title = "Updated status";
        this.desc = fb_event.message;
        this.img = "";
        break;
      default: 
        this.title = "Facebook post";
        this.desc = fb_event.message;
        this.img = "";
        break;                  
    }    
  }
})


//Eternos Timeline Twitter Event Source
var ETLEventSourceTwitter = Class.create(ETLEventSource, {
  initialize: function($super, event){
    $super(event);
    this.icon = this.imgUrl + "dull-green-circle.png";
    this.color = "cyan";
    this.textColor = "cyan";
    this.fetchEvent();
  },
  fetchEvent: function(){
    if (this.event.published_at){
      this.date = new ETLDate(this.event.published_at).outputDate;
    }
    this.title = "Post a tweet";
    this.desc = this.event.message;    
  }
})


//Eternos Timeline Backup Photo Event Source
var ETLEventSourceBackupPhoto = Class.create(ETLEventSource, {
  initialize: function($super, event){
    $super(event);
    this.icon = this.imgUrl + "gray-circle.png";
    this.color = "gray";
    this.textColor = "gray";
    this.fetchEvent();
  },
  fetchEvent: function(){
    if (this.event.backup_photo.created_at){
      this.date = new ETLDate(this.event.backup_photo.created_at).outputDate;
    }
    this.title = "Backup photo";
    this.desc = this.event.backup_photo.caption;
    this.img = this.event.backup_photo.source_url;    
  }  
})


//Eternos Timeline Feed Event Source
var ETLEventSourceFeed = Class.create(ETLEventSource, {
  initialize: function($super, event){
    $super(event);
    this.icon = this.imgUrl + "dull-red-circle.png";
    this.color = "orange";
    this.textColor = "orange";
    this.fetchEvent();
  },
  fetchEvent: function(){
    if (this.event.feed_entry.published_at){
      this.date = new ETLDate(this.event.feed_entry.published_at).outputDate;
    }
    
    this.title = "New feed item";
    this.desc = "SOURCE: " + this.event.feed_entry.name + "; DESCRIPTION: " + this.event.feed_entry.summary;
    this.link = this.event.feed_entry.url;    
  }  
})


//Eternos Timeline Email Event Source
var ETLEventSourceEmail = Class.create(ETLEventSource, {
  initialize: function($super, event){
    $super(event);
    this.icon = this.imgUrl + "red-circle.png";
    this.color = "red";
    this.textColor = "red";
    this.fetchEvent();
  },
  fetchEvent: function(){
    if (this.event.backup_email.received_at) {
      this.date = new ETLDate(this.event.backup_email.received_at).outputDate;
    }
    
    this.title = "Receiving an email";
    this.desc = "FROM: " + this.event.backup_email.sender[0] + "; SUBJECT: " + this.event.backup_email.subject;    
  }  
})


//Eternos Timeline Event Parser
var ETLEventParser = Class.create({
  initialize: function(events){
    this.events = events;
  },
  parse: function(){
    for(var i=0;i<this.events.results.length-1;i++) {
      if (this.events.results[i].event != null){}
    }; 
  }
})


//Eternos Timeline Search
var ETLSearch = Class.create({
  initialize: function(member_id, params){
    var date = new Date();
    
    this.searchUrl = "/timeline/search/js/";
    this.startDate = params.startDate || new ETLDate(date).outDate;
    this.endDate = params.endDate || new ETLDate(date).outDate;
    this.options = params.options;
    
    this.getFullSearchUrl();
    this.response = this.getJSON();
  },
  getFullSearchUrl: function(){
    this.fullSearchUrl = this.searchUrl + window._ETLMemberID +'/'+ this.startDate +'/'+ this.endDate +'/'+ this.options
  },
  getJSON: function(){
    var response = new Ajax.Request(this.fullSearchUrl, {
      method: 'get',
      onSuccess: function(transport){
        var response = transport;
        this.response_text = transport.responseText;
      },
      onFailure: function(){},
      onLoading: function(){}
    });
    return response;
  }
})


//Eternos Timeline Base
var ETLBase = Class.create({
  initialize: function(domID, params){
    window._ETLMemberID = params.memberID;
    window._ETLResizeTimerID = null;
    var date = new Date();
    
    this.domID = domID;
    this.params = params;
    this.memberID = params.memberID;
    this.startDate = params.startDate || new ETLDate(date);
    this.endDate = params.endDate || new ETLDate(date);
    this.options = params;
    this.theme = Timeline.ClassicTheme.create();
		var d = Timeline.DateTime.parseGregorianDateTime("1960");
    this.bandInfos = [
			Timeline.createBandInfo({
			  width:          "10%", 
			  intervalUnit:   Timeline.DateTime.DECADE, 
			  intervalPixels: 200,
			  date:           d,
			  showEventText:  false,
			  theme:          this.theme
			}),		
			Timeline.createBandInfo({
				width:          "60%",
				intervalUnit:   Timeline.DateTime.DAY,
				intervalPixels: 200,
				date:           d,
				theme: this.theme
			}),
			Timeline.createBandInfo({
				width:          "15%",
				intervalUnit:   Timeline.DateTime.MONTH,
				intervalPixels: 200,
				date:           d,
				overview: true,
				eventSource: params.eventSource || new Timeline.DefaultEventSource(),
				theme: this.theme
			}),
			Timeline.createBandInfo({
        width:          "15%",
        intervalUnit:   Timeline.DateTime.YEAR,
				overview: true,
				date:           d,
        intervalPixels: 200,
        theme: this.theme
      })
     ];
    this.setupBands();
    this.init();
  },
  
  setupBands: function(){
		this.bandInfos[1].syncWith = 0;
    this.bandInfos[2].syncWith = 1;
		this.bandInfos[3].syncWith = 2;
		
    this.bandInfos[0].highlight = false;
		this.bandInfos[1].highlight = true;
		this.bandInfos[2].highlight = true;
		this.bandInfos[3].highlight = true;
		
    this.bandInfos[0].etherPainter = new Timeline.YearCountEtherPainter({
        startDate:  "Nov 14 1938 00:00:00 GMT",
        multiple:   5,
        theme:      this.theme
    });
    this.bandInfos[0].decorators = [
        new Timeline.SpanHighlightDecorator({
            startDate:  "Nov 14 1938 00:00:00 GMT",
            endDate:    "Dec 05 2008 00:00:00 GMT",
            startLabel: "birth",
            endLabel:   "death",
            color:      "#5AAAC7",
            opacity:    50,
            theme:      this.theme
        })
    ];
    this.bandInfos[1].decorators = [
        new Timeline.SpanHighlightDecorator({
					  startDate:  "Nov 14 1930 00:00:00 GMT",
            color:      "#B2CAD7",
            theme:      this.theme
        })
    ];		
  },
  init: function(){
    this.create();
    this.showLoading();
    this.searchEvents();
    this.addEvents(this.searchResults);
  },
  create: function(){
    this.timeline = Timeline.create(document.getElementById(this.domID), this.bandInfos);
  },
  addEventSource: function(){},
  onBandScrolling: function(){
    this.timeline.getBand(0).addOnScrollListener(function(band){
      var min_date = new ETLDate(band.getMinVisibleDate(), 'rails').outputDate;
      var max_date = new ETLDate(band.getMaxVisibleDate(), 'rails').outputDate;
    });      
  },
  searchEvents: function(){
    this.searchResults = new ETLSearch(this.memberID, this.params);
    this.addEvents();
  },
  onWindowResize: function(){
    if (window._ETLResizeTimerID == null) {
      window._ETLResizeTimerID = window.setTimeout(function() {
        window._ETLResizeTimerID = null;
        tl.layout();
      }, 500);
    }    
  },
  showLoading: function(){
    this.timeline.showLoadingMessage();
  },
  hideLoading: function(){
    this.timeline.hideLoadingMessage();
  },
  addEvents: function(){
    
  },
  showError: function(){
    alert('Error loading timeline data, reload your browser');
  },
  toggleDetails: function(){},
  setTheme: function(){}  
})
