/*
 * Eternos Timeline classes using prototype method:Class.create({})
 * Not implemented yet
 * 
 * Classes are:
 * 
 * ETLDate
 * ETLArray
 * ETLDom
 * ETLDomArtifact
 * ETLDomStory
 * ETLDomArtifactItem
 * ETLDomStoryItem
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
 * 

//Eternos Timeline Date
var ETLDate = Class.create({
  initialize: function(date, format){
    this.inDate = date;
    this.inFormat = format || 'natural';
  },
  getOutDate: function(){
    if(this.inFormat == 'natural'){
      this.outDate = this.inDate.getFullYear() +'-'+ this.inDate.getMonth() +'-'+ this.inDate.getDate();
    } else {
      this.outDate = new Date(this.inDate.substr(0, 4), this.inDate.substr(5, 2), this.inDate.substr(8, 2));
    }
    return this.outDate();
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
var ETLDomStory = Class.create(ETLDom, {
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
var ETLStoryItem = Class.create({
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
    window._ETLMemberID = member_id;
    var date = new Date();
    
    this.searchUrl = "http://staging.eternos.com/timeline/search/js/";
    this.startDate = params.start_date || new ETLDate(date);
    this.endDate = params.end_date || new ETLDate(date);
    this.options = params.options
  },
  getFullSearchUrl: function(){},
  search: function(){},
  onLoading: function(){},
  onSuccess: function(){},
  onFailure: function(){},
  parseEvents: function(){},
  createEvent: function(){}
})


//Eternos Timeline Base
var ETLBase = Class.create({
  initialize: function(tmline, domID, params){
    var date = new Date();
    this.sourceObj = tmline;
    this.domID = domID;
    this.options = params;
    this.startDate = params.startDate || new ETLDate(date);
    this.endDate = params.endDate || new ETLDate(date);
    this.theme = Timeline.ClassicTheme.create();
    this.bandInfos = [
       Timeline.createBandInfo({
           width:          "15%",
           intervalUnit:   Timeline.DateTime.YEAR,
           intervalPixels: 150,
           overview: true,
           theme: this.theme
       }),
       Timeline.createBandInfo({
           width:          "85%",
           intervalUnit:   Timeline.DateTime.MONTH,
           intervalPixels: 200,
           eventSource: params.eventSource || new Timeline.DefaultEventSource(),
           theme: this.theme
       })
     ];    
  },
  syncBands: function(){
    this.timeline.bandInfos[1].syncWith = 0;
    this.timeline.bandInfos[1].highlight = true;     
  },
  init: function(){},
  addEventSource: function(){},
  onBandScrolling: function(){
    this.timeline.getBand(0).addOnScrollListener(function(band){
      var min_date = new ETLDate(band.getMinVisibleDate(), 'rails').outputDate;
      var max_date = new ETLDate(band.getMaxVisibleDate(), 'rails').outputDate;
      var el_options = 'fake';
      //TODO: search
    });      
  },
  searchEvents: function(){},
  onWindowResize: function(){
    if (resizeTimerID == null) {
      resizeTimerID = window.setTimeout(function() {
        resizeTimerID = null;
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
  addEvents: function(){},
  toggleDetails: function(){},
  setTheme: function(){}  
})


 * 
 * 
 * 
 * 
 */



/*Eternos Timeline Date Format*/
function ETLDate(date, format){
  this.dateFormat = (format == null) ? 'default' : format.toString();
  this.inputDate  = date;
  
  //private
  function procOutputDate(obj){
    if (obj.dateFormat == 'default') {
      obj.outputDate = new Date(obj.inputDate.substr(0, 4), obj.inputDate.substr(5, 2), obj.inputDate.substr(8, 2));
    }else{
      obj.outputDate = obj.inputDate.getFullYear() +'-'+ obj.inputDate.getMonth() +'-'+ obj.inputDate.getDate();
    }      
  }
  
  procOutputDate(this);
}

/*Eternos Timeline Array that has unique method*/
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
}
ETLArray.prototype = new Array();

/*Eternos Timeline Artifact*/
function ETLArtifact(domID){
  this.parent = $(domID);
  this.title  = "Artifacts";
  this.top    = "<div class='artibox-top'><div class='title5'>" +this.title+ "</div></div><div class='artibox'>";
  this.bottom = "</div><img src='/images/artibox-bottom.gif' />";
  this.items   = new ETLArray;
  
  //private
  function itemsToHtml(artifact){
    for (i = 0; i < artifact.items.length; i++) {
      artifact.items[i] = artifact.items[i].toHtml();
    }
  }
  function resetItems(artifact){
    artifact.parent.innerHTML = "";
  }
  function makeItemsUniq(artifact){
    artifact.items.unique();
  }
  
  //public
  this.write = function(){
    itemsToHtml(this);
    makeItemsUniq(this);
    var html_item = this.items.join("");
    this.parent.insert(this.top + html_item + this.bottom);
  }
  this.addItem = function(item){
    this.items.push(item);
  }
  this.setTitle = function(title){
    this.title = title;
  }
  
  resetItems(this);
}

/*Eternos Timeline Artifact Item, with source from 'event' in evalJSON response*/
function ETLArtifactItem(event){
  this.thumbHeight = 70;
  this.thumbWidth = 70;
  this.sourceEvent = event;
  
  //private
  function populateImg(obj){
    if (obj.sourceEvent.facebook_activity_stream_item){
      if (obj.sourceEvent.facebook_activity_stream_item.attachment_type == "photo"){
        obj.imageUrl = obj.sourceEvent.facebook_activity_stream_item.src;
        obj.itemType = "Facebook";
      }
    } else if (obj.sourceEvent.backup_photo){
      obj.imageUrl = obj.sourceEvent.backup_photo.source_url;
      obj.itemType = "Backup Photo";
    } 
  }
  
  //public
  this.toHtml = function(){
    rv = (this.imageUrl == "" || this.imageUrl == undefined) ? "" : "<a href=# onclick=\"Lightview.show( {href:'"+this.imageUrl+"', options:{ajax:{evalScripts:true, method:'get', parameters:'&authenticity_token='+ encodeURIComponent('cd0107f95e066667938b7f27f3b4732cf8ace5ca')}, autosize:false, closeButton:false, width:800}, rel:'iframe'});return false;\"><img src='" +this.imageUrl+ "' class='thumnails2' /></a>";
    return rv;    
  }
  
  populateImg(this);
}


/*Eternos Timeline Story*/
function ETLStory(domID){
  this.parent = $(domID);
  this.title  = "Stories";
  this.top    = "<div class='storybox-top'><div class='title5'>" +this.title+ "</div></div><div class='storybox'>";
  this.bottom = "</div><img src='/images/storybox-bottom.gif' />";
  this.item   = "";  
  
  this.write = function(){
    this.parent.insert(this.top + this.item + this.bottom);
  }
  this.addItem = function(item){
    this.item += item;
  }
}

/*Eternos Timeline Story Item*/
function ETLStoryItem(event){
  this.thumbHeight = 70;
  this.thumbWidth = 70;
  this.sourceEvent = event;
  this.popImg();
}
ETLStoryItem.prototype.popImg = function(){
  if (this.sourceEvent.facebook_activity_stream_item){
    if (this.sourceEvent.facebook_activity_stream_item.attachment_type == "photo"){
      this.imageUrl = this.sourceEvent.facebook_activity_stream_item.src;
      this.itemType = "Facebook";
    }
  } else if (this.sourceEvent.backup_photo){
    this.imageUrl = this.sourceEvent.backup_photo.source_url;
    this.itemType = "Backup Photo";
  } 
}
ETLStoryItem.prototype.toHtml = function(){
  rv = (this.imageUrl == "" || this.imageUrl == undefined) ? "" : "<div class='story-subox'><img src='" +this.imageUrl+ "' class='thumnails1' /><div class='story-detail-box'><div class='story-detail-title'>Story Title 1</div><div class='story-detail-date'>December 21, 2010</div><div class='story-detail-subject'>Subject :<a href='#' class='story-subject-btn'>Vacation</a>,&nbsp;<a href='#' class='story-subject-btn'>Friends</a></div></div></div>";
  return rv;
}


/*Eternos Timeline Search*/
function ETLSearch(member_id, options){
  window._ETLMemberID = member_id;
  var date = new Date();
  
  this.searchUrl = "/timeline/search/js/";
  this.startDate = options.start_date || new ETLDate(date);
  this.endDate = options.end_date || new ETLDate(date);
  this.options = options.options
  
  this.onFailure = function(){}
  this.onLoading = function(){}
  this.onSuccess = function(){}
  
  new Ajax.Request(this.searchUrl+this.member+'/'+this.startDate+'/'+this.endDate+'/'+this.options, {
    method: 'get',
    onSuccess: function(transport){
      var response = transport.responseText || "";
      //TODO:
    },
    onFailure: function(){
      //TODO:
    },
    onLoading: function(){
      //TODO:
    }
  });  
}

/*Eternor Timeline Event Source*/
function ETLEventSource(events){
  this.asset_url = "http://simile.mit.edu/timeline/api/";
  this.imgs_url = this.asset_url + "images/";
  this.title = this.desc = this.img = this.link = this.icon = this.color = this.tcolor = null;
  this.sourceEvent = events
    
  this.parse = function(events){
    
  }
  this.create = function(event){
    if (event.facebook_activity_stream_item){
      new ETLEventSourceFacebook(event);
    } else if (event.twitter_activity_stream_item){
      new ETLEventSourceTwitter(event);
    } else if (event.backup_photo){
      new ETLEventSourcePhoto(event);
    } else if (event.backup_email){
      new ETLEventSourceEmail(event);
    } else if (event.feed_entry){
      new ETLEventSourceFeed(event);
    }
  }
}

function ETLEventSourceFacebook(){}
function ETLEventSourceTwitter(){}
function ETLEventSourceFeed(){}
function ETLEventSourceEmail(){}
function ETLEventSourceBackupPhoto(){}

ETLEventSourceFacebook.prototype = new ETLEventSource();
ETLEventSourceTwitter.prototype = new ETLEventSource();
ETLEventSourceFeed.prototype = new ETLEventSource();
ETLEventSourceEmail.prototype = new ETLEventSource();
ETLEventSourceBackupPhoto.prototype = new ETLEventSource();


/*Eternos Timeline Base Class*/
function ETLBase(tmline, domID, options){
  this.theme = Timeline.ClassicTheme.create();
  this.bandInfos = [
     Timeline.createBandInfo({
         width:          "15%",
         intervalUnit:   Timeline.DateTime.YEAR,
         intervalPixels: 150,
         overview: true,
         theme: theme
     }),
     Timeline.createBandInfo({
         width:          "85%",
         intervalUnit:   Timeline.DateTime.MONTH,
         intervalPixels: 200,
         eventSource: options.eventSource || new Timeline.DefaultEventSource(),
         theme: theme
     })
   ];
  
  this.syncBands = function()  {
   this.bandInfos[1].syncWith = 0;
   this.bandInfos[1].highlight = true; 
  }
  
  this.init = function(tmline){
    this.timeline = Timeline.create(document.getElementById(domID), this.bandInfos);
  }
  this.addEventSource = function(){}
  this.scrollBand = function(){}
  this.searchEvents = function(){}
  this.onResize = function(){}
  this.showLoading = function(){}
  this.hideLoading = function(){}
  this.addEvents = function(){}
  this.toggleDetails = function(){}
  this.setTheme = function(){}
}



//initialize Timeline 
var tl;
function tl_init(event_source) {
   var theme = Timeline.ClassicTheme.create();
   theme.event.bubble.width = 400;
   var bandInfos = [
     Timeline.createBandInfo({
         width:          "15%",
         intervalUnit:   Timeline.DateTime.YEAR,
         intervalPixels: 150,
         overview: true,
         theme: theme
     }),
     Timeline.createBandInfo({
         width:          "85%",
         intervalUnit:   Timeline.DateTime.MONTH,
         intervalPixels: 200,
         eventSource: event_source,
         theme: theme
     })
   ];
   bandInfos[1].syncWith = 0;
   bandInfos[1].highlight = true; 
   tl = Timeline.create(document.getElementById("my-timeline"), bandInfos);
   
   //event listener for timeline band scrolling
   tl.getBand(0).addOnScrollListener(function(band){
     var min_date = new ETLDate(band.getMinVisibleDate(), 'rails').outputDate;
     var max_date = new ETLDate(band.getMaxVisibleDate(), 'rails').outputDate;
     var el_options = 'fake';
     tl_search(window._tl_member_id, min_date, max_date, el_options);
   });
   
}

var resizeTimerID = null;
function onResize() {
   if (resizeTimerID == null) {
       resizeTimerID = window.setTimeout(function() {
           resizeTimerID = null;
           tl.layout();
       }, 500);
   }
}

//search Timeline events
function tl_search(member, start_date, end_date, options){
  window._tl_member_id = member;
  new Ajax.Request('/timeline/search/js/'+member+'/'+start_date+'/'+end_date+'/'+options, {
      method: 'get',
      onSuccess: function(transport){
        var response = transport.responseText || "";
        tl_toggle_timeline_details();
        tl_parse_events(response);
      },
      onFailure: function(){
        tl_on_failure();
      },
      onLoading: function(){
        tl_on_loading();
      }
  });
}

//parse returning response from Timeline search
function tl_parse_events(source){
  var events = source.evalJSON();
  var event_source = new Timeline.DefaultEventSource();
  var artifacts = new ETLArtifact('arti-area');
  var stories = new ETLStory('story-area');
  
  for(var i=0;i<events.results.length-1;i++) {
    if (events.results[i].event != null){
      var event = tl_create_event_source(events.results[i], event_source);
      event_source.add(event); 

      var artifact = new ETLArtifactItem(events.results[i].event);
      artifacts.addItem(artifact);
      
      var story = new ETLStoryItem(events.results[i].event).toHtml();
      stories.addItem(story);
    }
  };
  
  tl_init(event_source);
  artifacts.write();
  stories.write();
}

//create event source
function tl_create_event_source(source){
  var event = source.event;
  var tl_title = tl_desc = tl_img = tl_link = tl_icon = tl_color = tl_tcolor = null;
  var tl_date = new Date();
  var asset_url = "http://simile.mit.edu/timeline/api/";
  var imgs_url = asset_url + "images/";
    
  if (event.facebook_activity_stream_item){
    fb_event = event.facebook_activity_stream_item
    
    tl_icon = imgs_url + "dark-blue-circle.png";
    tl_color = tl_tcolor = "blue";
    if (fb_event.published_at) {
      tl_date = new ETLDate(fb_event.published_at).outputDate;
    }
    
    switch (fb_event.attachment_type) {
      case "photo" :
        tl_title = "Uploaded photo";
        tl_desc = fb_event.message;
        tl_img = fb_event.src;
        break;
      case "link" :
        tl_title = "Wall posting";
        tl_desc = fb_event.message;
        tl_link = fb_event.src;
        break;
      case null :
        tl_title = "Updated status";
        tl_desc = fb_event.message;
        tl_img = "";
        break;
      default: 
        tl_title = "Facebook post";
        tl_desc = fb_event.message;
        tl_img = "";
        break;                  
    }
  } else if (event.twitter_activity_stream_item){
    tw_event = event.twitter_activity_stream_item
    
    tl_color = tl_tcolor = "cyan";
    tl_icon = imgs_url + "dull-green-circle.png";
    if (tw_event.published_at){
      tl_date = new ETLDate(tw_event.published_at).outputDate;
    }
    
    tl_title = "Post a tweet";
    tl_desc = tw_event.message;
  } else if (event.backup_photo) {
    if (event.backup_photo.created_at){
      tl_date = new ETLDate(event.backup_photo.created_at).outputDate;
    }
    
    tl_icon = imgs_url + "gray-circle.png";
    tl_color = tl_tcolor = "gray";
    tl_title = "Backup photo";
    tl_desc = event.backup_photo.caption;
    tl_img = event.backup_photo.source_url;
  } else if (event.backup_email){
    tl_icon = imgs_url + "red-circle.png";
    tl_color = tl_tcolor = "red";
    if (event.backup_email.received_at) {
      tl_date = new ETLDate(event.backup_email.received_at).outputDate;
    }
    
    tl_title = "Receiving an email";
    tl_desc = "FROM: " + event.backup_email.sender[0] + "; SUBJECT: " + event.backup_email.subject;
  } else if (event.feed_entry) {
    if (event.feed_entry.published_at){
      tl_date = new ETLDate(event.feed_entry.published_at).outputDate;
    }
    
    tl_icon = imgs_url + "dull-red-circle.png";
    tl_color = tl_tcolor = "orange";
    tl_title = "New feed item";
    tl_desc = "SOURCE: " + event.feed_entry.name + "; DESCRIPTION: " + event.feed_entry.summary;
    tl_link = event.feed_entry.url;
  }
  
  var return_event = new Timeline.DefaultEventSource.Event(
    tl_date, tl_date, tl_date, tl_date, true, 
    tl_title, tl_desc, tl_img, tl_link, tl_icon, tl_color, tl_tcolor);
    
  return return_event;       
}

//display blank timeline(without points)
function tl_blank(){
  var event_source = new Timeline.DefaultEventSource();
  tl_init(event_source);
}

//behavior on timeline loading
function tl_on_loading(){
  //TODO:
}

//action if timeline failure
function tl_on_failure(){
  tl_blank();
}

//show/hide stories, artifacts and backup progress
function tl_toggle_timeline_details(){
  $('timeline-detail').toggle();
}

//handling on failure
function tl_show_on_failure(){
  
}

//on timeline drag event
function tl_on_drag(){
  
}
