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
    } else if (this.inFormat == 'gregorian'){
      this.outDate = Timeline.DateTime.parseGregorianDateTime(this.inDate.substr(0, 4));
    } else{
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
  },
  showLoading: function(){},
  hideLoading: function(){}
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
    rv = (this.imageUrl == "" || this.imageUrl == undefined) ? "" : "<img src='" +this.imageUrl+ "' class='thumnails2' />";
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
    this.timelineEvents = new Array();
    this.artifactItems = new Array();
    this.jsonEvents = events.evalJSON();
    alert(this.jsonEvents);
    this.doParsing();
    alert(this.artifactItems);
  },
  doParsing: function(){
    for(var i=0;i<this.jsonEvents.results.length;i++) {
      if (this.jsonEvents.results[i].event != null){
        var event = this.jsonEvents.results[i].event;
        
        var tmlne_event = new ETLEventSource(event);
        var artft_item = new ETLArtifactItem(event);
        
        if (artft_item != null){
          this.artifactItems.push(artft_item);
        }
        
        this.timelineEvents.push(this.jsonEvents.results[i].event);
      }
    };
  }
})


//Eternos Timeline Search
//init: timeline object and {startDate: 'sring date', endDate: 'string date', options: 'string'}
var ETLSearch = Class.create({
  initialize: function(timeline, params){
    var date = new Date();
    
    this.timeline = timeline;
    this.searchUrl = "/timeline/search/js/";
    this.startDate = params.startDate || new ETLDate(date).outDate;
    this.endDate = params.endDate || new ETLDate(date).outDate;
    this.options = params.options;
    this.complete = false;
    
    this._getFullSearchUrl();
    this._getJSON(this.timeline, this.fullSearchUrl);
  },
  _getFullSearchUrl: function(){
    this.fullSearchUrl = this.searchUrl + window._ETLMemberID +'/'+ this.startDate +'/'+ this.endDate +'/'+ this.options
  },
  _getJSON: function(tmline, url){
    new Ajax.Request(url, {
      method: 'get',
      onSuccess: function(transport){
        var response = transport.responseText || "";
        tmline.pushEvents(response);
        tmline.hideLoading();
      },
      onFailure: function(){
        tmline.showError();
      },
      onLoading: function(){
        tmline.showLoading();
      }
    });
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
    
    this.bandInfos = [
      Timeline.createBandInfo({
        width:          "20%", 
        intervalUnit:   Timeline.DateTime.DECADE, 
        intervalPixels: 200,
        date:           date,
        showEventText:  false,
        theme:          this.theme
      }),   
      Timeline.createBandInfo({
        width:          "55%",
        intervalUnit:   Timeline.DateTime.DAY,
        intervalPixels: 200,
        date:           date,
        theme: this.theme
      }),
      Timeline.createBandInfo({
        width:          "13%",
        intervalUnit:   Timeline.DateTime.MONTH,
        intervalPixels: 200,
        date:           date,
        overview: true,
        eventSource: params.eventSource || new Timeline.DefaultEventSource(),
        theme: this.theme
      }),
      Timeline.createBandInfo({
        width:          "12%",
        intervalUnit:   Timeline.DateTime.YEAR,
        overview: true,
        date:           date,
        intervalPixels: 200,
        theme: this.theme
      })
     ];
    this._setupBands(this);
    this.init();
  },
  
  _setupBands: function(obj){
    this.bandInfos[1].syncWith = 0;
    this.bandInfos[2].syncWith = 1;
    this.bandInfos[3].syncWith = 2;
    
    this.bandInfos[0].highlight = false;
    this.bandInfos[1].highlight = true;
    this.bandInfos[2].highlight = true;
    this.bandInfos[3].highlight = true;
    
    var start_date = new ETLDate(obj.startDate, 'gregorian').outDate;
    var end_date = new ETLDate(obj.endDate, 'gregorian').outDate;
    
    this.bandInfos[0].etherPainter = new Timeline.YearCountEtherPainter({
        startDate:  start_date,
        multiple:   5,
        theme:      this.theme
    });
    this.bandInfos[0].decorators = [
        new Timeline.SpanHighlightDecorator({
            startDate:  start_date,
            endDate:    end_date,
            startLabel: "birth",
            endLabel:   "",
            color:      "#5AAAC7",
            opacity:    50,
            theme:      this.theme
        })
    ];
    this.bandInfos[1].decorators = [
        new Timeline.SpanHighlightDecorator({
            startDate:  start_date,
            color:      "#B2CAD7",
            theme:      this.theme
        })
    ];    
  },
  _handleWindowResize: function(){
    if (window._ETLResizeTimerID == null) {
      window._ETLResizeTimerID = window.setTimeout(function() {
        window._ETLResizeTimerID = null;
        this.timeline.timeline.layout();
      }, 500);
    }    
  },  
  _create: function(){
    this.timeline = Timeline.create(document.getElementById(this.domID), this.bandInfos);
  },  
  _onBandScrolling: function(){
    this.timeline.getBand(0).addOnScrollListener(function(band){
      var min_date = new ETLDate(band.getMinVisibleDate()).outputDate;
      var max_date = new ETLDate(band.getMaxVisibleDate()).outputDate;
      //TODO:
    });
  },  
  _parseEvents: function(){
    this.events = new ETLEventParser(this.sourceEvent);
  },
  _populateEvents: function(){},  
  init: function(){
    this._create();
    this._handleWindowResize();
    this._onBandScrolling();
    this.searchEvents();
  },
  searchEvents: function(){
    var prm = {startDate: '2009-02-01', endDate: '2009-03-01', options: 'fake'}
    new ETLSearch(this, prm);
  },
  showLoading: function(){
    this.timeline.showLoadingMessage();
  },
  hideLoading: function(){
    this.timeline.hideLoadingMessage();
  },
  pushEvents: function(events){
    this.sourceEvent = events;
    this._parseEvents();
    this._populateEvents();
  },
  showError: function(){
    this.hideLoading();
    //TODO:
  },
  showBubble: function(elements){}
})



//required Date prototype for Month selector
Date.prototype.getMonthName =  function(){
  var nm = ["January","February","March","April","May","June","July","August","September","October","November","December"];
  var nu = [0,1,2,3,4,5,6,7,8,9,10,11];
  return nm[this.getMonth()];
}
Date.prototype.numDays = function(){
  return 32 - new Date(this.getFullYear(), this.getMonth(), 32).getDate();
}
Date.prototype.stepMonth = function(param){
  if (param == 'up') {
    if (this.getMonth() == 11){
      this.setMonth(0);
      this.setFullYear(this.getFullYear() + 1);
    } else {
      this.setMonth(this.getMonth() + 1);
    }
  }else if (param == 'down'){
    if (this.getMonth() == 0){
      this.setMonth(11);
      this.setFullYear(this.getFullYear() - 1);      
    }else{
      this.setMonth(this.getMonth() - 1);
    }
  }
}

var ETLMonthSelector = Class.create({
  initialize: function(domID){
    this.parent = $(domID);
    this.activeDate = new Date();
    this.advanceMonths = new Array();
    this.pastMonths = new Array();
    this.top    = "<a href=\"#\" class=\"btn-left\" onclick=\"window._ETLMonthSelector.stepMonth('down')\"></a>";
    this.bottom = "<a href=\"#\" class=\"btn-right\" onclick=\"window._ETLMonthSelector.stepMonth('up')\"></a>";
    this.populate();
  },
  _initContent: function(){
    this.activeMonth = this.activeDate.getMonthName();
    this.activeYear = this.activeDate.getFullYear();
  },
  _setContent: function(){
    var m = "<span class=\"subtitle6\">"+this.activeMonth+"</span>";
    var y = "<span class=\"subtitle7\">"+this.activeYear+"</span>";
    this.content = m+y;
  },
  _write: function(){
    this.parent.innerHTML = this.top + this.content + this.bottom;
    window._ETLMonthSelector = this;
  },
  populate: function(){
    this._initContent();
    this._setContent();
    this._write();  
  },
  stepMonth: function(param){
    this.activeDate.stepMonth(param);
    this.populate();
    //TODO: catch the date then attach timeline search here
  }
})

