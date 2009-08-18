// $Id$
//
// Timeline javascript module

// required Date' prototypes
Date.prototype.numDays = function(){
  return 32 - new Date(this.getFullYear(), this.getMonth(), 32).getDate();
}
Date.prototype.getFullMonth =  function(){
	var m = this.getMonth()+1+"";
	return (m.length<2) ? "0"+m : m;
}
Date.prototype.startingMonth = function(){
	return this.getFullYear()+"-"+this.getFullMonth()+"-01";
}
Date.prototype.endingMonth = function(){
	return this.getFullYear()+"-"+this.getFullMonth()+"-"+this.numDays();
}
Date.prototype.getMonthName =  function(){
  var nm = ["January","February","March","April","May","June","July","August","September","October","November","December"];
  var nu = [0,1,2,3,4,5,6,7,8,9,10,11];
  return nm[this.getMonth()];
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
Date.prototype.monthRange = function(num, dir){
	var set_up = function(d){d.setMonth(d.getMonth()+num)}
	var set_down = function(d){d.setMonth(d.getMonth()-num)}
	
	dir == 'next' ? set_up(this) : set_down(this);
	var rv = this.getFullYear()+"-"+this.getFullMonth()+"-"+this.getDate();
	dir == 'next' ? set_down(this) : set_up(this);
	
	return rv;
}

// required Array' prototypes 
Array.prototype.unique = function(){
  var r = new Array();
  o:for(var i = 0, n = this.length; i < n; i++){
    for(var x = 0, y = r.length; x < y; x++){
      if(r[x]==this[i]){ continue o;}
    }
    r[r.length] = this[i];
  }
  return r;
}
Array.prototype.randResult = function(){
  
}
Array.prototype.include = function(val) {
  return this.index(val) !== null;
}

//Date parsing regex & sort function
var MysqlDateRE = /^(\d{4})\-(\d{2})\-(\d{2})/;
var mysqlTimeToDate = function(datetime) {
    //function parses mysql datetime string and returns javascript Date object
    //input has to be in this format: 2007-06-05 15:26:02
    var regex = /^([0-9]{2,4})-([0-1][0-9])-([0-3][0-9]) (?:([0-2][0-9]):([0-5][0-9]):([0-5][0-9]))?$/;
    var parts = datetime.replace(regex,"$1 $2 $3 $4 $5 $6").split(' ');
    return new Date(parts[0],parts[1]-1,parts[2],parts[3],parts[4],parts[5]);
}
var mysqlDateToDate = function(date) {
    //function parses mysql datetime string and returns javascript Date object
    //input has to be in this format: 2007-06-05
    var parts = date.replace(MysqlDateRE,"$1 $2 $3").split(' ');
    return new Date(parts[0],parts[1]-1,parts[2]);
}
var orderDatesDescending = function(x, y) {
	x = x.replace(MysqlDateRE,"$1$2$3");
	y = y.replace(MysqlDateRE,"$1$2$3");
	if (x > y) return -1
	if (x < y) return 1;
	return 0; 
};

// ETimeline 'class'

var ETimeline = function(opts) {
	var me = new Object();
	var options = Object.extend(opts, {});
	var api	 = '0.1';
	
	// Private instances & functions
	
// Utilities, constants and vars needed
var ETLUtil = function(){}
ETLUtil.itemTypes = [
	{type: "FacebookActivityStreamItem", display_text: "Facebook Post", display_text_plural: "Facebook Posts", icon: "dark-blue"}, 
	{type: "TwitterActivityStreamItem", display_text: "Tweet", display_text_plural: "Tweets", icon: "dull-green"}, 
	{type: "FeedEntry", display_text: "Blog Post", display_text_plural: "Blog Posts", icon: "dull-red"}, 
	{type: "BackupEmail", display_text: "Email", display_text_plural: "Emails", icon: "red"}, 
	{type: "Photo", display_text: "Photo", display_text_plural: "Photos", icon: "blue"},
	{type: "Video", display_text: "Video", display_text_plural: "Videos", icon: "green"},
	{type: "Music", display_text: "Music", display_text_plural: "Music", icon: "green"},
	{type: "Audio", display_text: "Audio", display_text_plural: "Audio", icon: "green"},
	{type: "Document", display_text: "Document", display_text_plural: "Documents", icon: "grey"},
	{type: "School", display_text: "School", display_text_plural: "Schools", icon: "dull-blue"},
	{type: "Family", display_text: "Family Member", display_text_plural: "Family Members", icon: "dull-blue"},
	{type: "Medical", display_text: "Medical Data", display_text_plural: "Medical Data", icon: "dull-blue"},
	{type: "MedicalCondition", display_text: "Medical Condition", display_text_plural: "Medical Conditions", icon: "dull-blue"},
	{type: "Job", display_text: "Job", display_text_plural: "Jobs", icon: "dull-blue"}, 
	{type: "Address", display_text: "Address", display_text_plural: "Addresses", icon: "dull-blue"}
];
ETLUtil.pauseExec = function(ms){
	var d = new Date();
	var c = null;

	do { c = new Date(); }
	while(c-d < ms);	
}
ETLUtil.emptyResponse = "{\"results\": [], \"previousDataUri\": null, \"responseDetails\": null, \"request\": \"\", \"resultCount\": 0, \"status\": 200, \"futureDataUri\": null}"
ETLUtil.assetUrl = "http://simile.mit.edu/timeline/api/";
ETLUtil.imgUrl = ETLUtil.assetUrl+"images/";
ETLUtil.iconPostfix = "-circle.png";

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

//Eternos Timeline Selector
var ETLMonthSelector = Class.create({
  initialize: function(domID){
    this.parent = $(domID);
    this.activeDate = new Date();
    this.advanceMonths = new Array();
    this.pastMonths = new Array();
		this.enableClick();
    this.top    = "<a href=\"#\" class=\"btn-left\" onclick=\""+this.stepDownAttr+" return false;\"></a>";
    this.bottom = "<a href=\"#\" class=\"btn-right\" onclick=\""+this.stepUpAttr+" return false;\"></a>";
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
	disableClick: function(){
		this.stepUpAttr = this.stepDownAttr = "";
	},
	enableClick: function(){
		this.stepDownAttr = "window._ETLMonthSelector.stepMonth('down');";
		this.stepUpAttr = "window._ETLMonthSelector.stepMonth('up');";		
	},
  populate: function(){
    this._initContent();
    this._setContent();
    this._write();  
  },
  stepMonth: function(param){
    this.activeDate.stepMonth(param);
		this.disableClick();
		this.populate();
		var params = {
			startDate: this.activeDate.startingMonth(),
			endDate: this.activeDate.endingMonth(),
			options: window._ETLTimeline.options}
		window._ETLTimeline.searchEvents(params);
  }
})

//Eternos Timeline Artifact Section
var ETLArtifactSection = Class.create({
  initialize: function(domID){
    this.parent = $(domID);
		this.numShowed = 18;
		this.timeOut = 3;
    this.title = "Artifacts";
		this.template = artifactTemplates.artifacts();
		this.boxTemplate = artifactTemplates.artifactBox();
    this.items = new Array();

		this.showLoading();
  },
  _clearContent: function(){
    this.content = "";
  },
  _itemsToS: function(){
    for(var i=0;i<this.items.length;i++){
			var ul_class = (i >= this.numShowed) ? "class=\"hidden-artifact-item\" style=\"display:none\"" : "class=\"visible-artifact-item\"";
			if (this.items[i] !== undefined && this.items[i].attributes.thumbnail_url !== undefined) {
				this.content += this.boxTemplate.evaluate({num: i, 
					style: ul_class, 
					url: this.items[i].attributes.url, 
					thumbnail_url: this.items[i].attributes.thumbnail_url});
	    }
    }
  },
  _write: function() {
    this.parent.innerHTML = this.template.evaluate({title: this.title, artifacts: this.content});
    window._ETLArtifactSection = this;
  },
  randomize: function(){
	  var v = $$('li.visible-artifact-item');
		var h = $$('li.hidden-artifact-item');
		new PeriodicalExecuter(function(pe) {
			if (v.length>0) {
				var i = Math.floor(Math.random()*v.length);
				var j = Math.floor(Math.random()*h.length);
				var tmp = v[i].childElements()[0].childElements()[0].src;

				v[i].pulsate({ pulses: 1, duration: 1.5 });
				v[i].childElements()[0].childElements()[0].src = h[j].childElements()[0].childElements()[0].src;
				h[j].childElements()[0].childElements()[0].src = tmp;
			}
		}, this.timeOut);
  },	
  addItem: function(item){
    this.items.push(item);
  },
  addItems: function(items){
    for(var i=0;i<items.length;i++){
      this.addItem(items[i]);
    }
  },
  populate: function(){
		this._clearContent();
    this._itemsToS();
    this._write();
  },
  showLoading: function(){
    this.content = "<p>Loading Artifacts..</p><br/>";
    this._write();
  },
	updateTitle: function(title){
		this.title = title;
		this._write();
	}
})

//Eternos Timeline Event Section
var ETLEventSection = Class.create({
  initialize: function(domID){
    this.parent		= $(domID);
    this.title 		= "Events";
    this.loading 	= "<p>Loading Events..</p><br/>";
		this.template = eventListTemplates.events();
    this.content 	= "";
    this.images 	= new Array();

    this.populate();
    this.showLoading();
  },
  _clearContent: function(){
    this.content = "";
  },
  _write: function(){
    this.parent.innerHTML = this.template.evaluate({title: this.title, events: this.content});
    window._ETLEventSection = this;
  },
  addContent: function(content){
    this.content = content;
  },
  populate: function(){
    this._write();
  },
  showLoading: function(){
    this.content = this.loading;
    this.populate();
  }
})

//Eternos Timeline Event Source
var ETLEventSource = Class.create({
  initialize: function(s){
    this.start_date = s.start_date;
    this.end_date = s.end_date;
    this.type = s.type;
    this.attributes = s.attributes;
  },
	isArtifact: function() {
		return (this.type === 'Photo' || this.type === 'Video' || this.type === 'WebVideo');
	}
});

//Eternos Timeline Event Item
var ETLEventItems = Class.create({
  initialize: function(items){
		this.items				= items;
		this.first 				= s = new ETLEventSource(items[0]);
    this.type 				= s.type;
    this.start_date 	= s.start_date;
    this.end_date 		= s.end_date;
		this.attributes 	= s.attributes;
    this.num 					= items.length;
    this.items 				= items;
		this.html 				= '';
		this.artifactTemplate		= eventListTemplates.eventArtifactItem();
		this.hiddenItemTemplate = eventListTemplates.hiddenItem();
		this.itemWithTooltipTemplate = eventListTemplates.eventItemWithTooltip(); 
    this._setTitle();
    this._setHtml();
  },
  _setTitle: function(){
		var type = this.first.type;
		var event = ETLUtil.itemTypes.detect(function(e) { return e.type === type });
		if (event) {
			if (this.num > 1) {
				this.title = this.num +" "+ event.display_text_plural;
			} else if (this.num == 1) {
				this.title = event.display_text;
			}
		} else {
			this.title = "Unknown event";
		}
  },
  _setHtml: function(){
		// Need to format the link so all content will be displayed
		if (this.first.isArtifact()) {
			this.html = this._getArtifactItemHtml();
		} else {
			this.html = this._getInlineItemHtml();
		}
  },
	_getLinkUrl: function(item) {
		if (item.isArtifact()) {
			return item.attributes.url;
		} else {
		}
	},
	// Determine 'rel' attribute for Lightview link html
	_getLinkRel: function() {
		if (this.first.isArtifact()) {
			// Lightview auto-detects content so just need to know if gallery or not
			return (this.num > 1) ? 'gallery[' + this.first.attributes.id + ']' : '';
		} else {
			return 'ajax';
		}
	},
	_getArtifactItemHtml: function() {
		var other_items = '';
		if (this.num > 1) {
			for (var i=1; i<this.num; i++) {
				other_items += this.hiddenItemTemplate.evaluate({ 
					link_url: this._getLinkUrl(this.items[i]), 
					link_rel: this._getLinkRel()});
			}
		}
		return this.artifactTemplate.evaluate({title: this.title, 
			link_url: this._getLinkUrl(this.first), 
			link_rel: this._getLinkRel(),
			other_items: other_items});
	},
	_getInlineItemHtml: function() {
	 	return this.itemWithTooltipTemplate.evaluate({title: this.title, tooltip: this.attributes.description})
	}
})

//Eternos Timeline Event Item Detail
var ETLEventItemDetail = Class.create({
  initialize: function(event){
    this.source = event;
  }
})

//Eternos Timeline Event Source (Timeline.DefaultEventSource.Event)
var ETLTimelineEvent = Class.create({
  initialize: function(event){
    var date = new ETLDate(event.start_date, 'rev').outDate;
    this.start_date = this.start_end = this.earliest = this.latest = date;
    this.title = event.title;
    this.type = event.type;
    this._toTLEventSource();
  },
  _setIcon: function(){
    var type = this.type;
    var event = ETLUtil.itemTypes.detect(function(e) { return e.type === type });
    this.icon = ETLUtil.imgUrl+event.icon+ETLUtil.iconPostfix;
  },
  _toTLEventSource: function(){
    this._setIcon();
    this.event = new Timeline.DefaultEventSource.Event({
      start: this.start_date,
      end: this.end_date,
      latestStart: this.latest,
      earliestEnd: this.earliest,
      instant: true,
      text: this.title,
      description: this.type,
      icon: this.icon
    });
  }
})

//Eternos Timeline Event Collection
var ETLEventCollection = Class.create({
	initialize: function(){
		this.sources	= new Array();		// Event sources
		this.dates 		= new Array();			// Date collection (by day)
		this.rawItems = new Array();
		this.items 		= new Array();
		this.html			= ''
		this.groupTemplate = eventListTemplates.eventGroup();
	},
	addSource: function(s){
	  var source = new ETLEventSource(s);
	  this.sources.push(source);

		if (! this.dates.include(source.start_date)) {
		  this.rawItems[source.start_date] = new Array(source);
			this.dates.push(source.start_date);
		} else {
		  this.rawItems[source.start_date].push(source);
		}
	},
	populate: function(){
	  var items, items_html;
		var event;
		var date;
		var year = window._ETLMonthSelector.activeDate.getFullYear();
		var month = window._ETLMonthSelector.activeDate.getMonth();

		// Sort items by descending array
		this.dates.sort(orderDatesDescending);

		// Only use events that fall in the active date month
		var active = this.dates.select(function(d) {
			return (d !== undefined && parseInt(d.substr(0, 4)) === year && parseInt(d.substr(5, 2), 10) === month);
		});
		active.each(function(d) {
			var val = this.rawItems[d];
			items_html = ''
			items = this._groupItems(val);

			for(var j=0;j<items.length;j++){
				event = new ETLEventItems(items[j]);
				this.items.push(event);
				items_html += event.html;
			}
			this.html += this.groupTemplate.evaluate({date: this._eventDate(d), body: items_html});
		}, this);
	},
	_groupItems: function(items){
	  var types = new Array();
	  var results = new Array();
    
    for(var i=0; i < items.length; i++){
      if(types.include(items[i].type)){
        results[types.length-1].push(items[i]);
      } else {
        types.push(items[i].type);
        results[types.length-1] = new Array(items[i]);
      }
    }
	  return results;
	},
	_eventDate: function(date) {
		var d = mysqlDateToDate(date);
		return d.toLocaleDateString();
	}
	
})

//Eternos Timeline Artifact 
var ETLArtifact = Class.create({
	initialize: function(object) {
		this.type = object.type;
		this.attributes = object.attributes;
	}
});

//Eternos Timeline Event Parser
var ETLEventParser = Class.create({
  initialize: function(events){
    this.eventItems = new ETLEventCollection();
    this.artifactItems = new Array();
    this.jsonEvents = events.evalJSON();
    this._populate();
  },
  _populate: function(){
    this.doParsing();
		this.populateResults();    
  },
  _mergeEvents: function(events){
    var merged = this.jsonEvents.results.concat(events.results);
    this.jsonEvents.results = merged;
  },
  pushEvents: function(events){
    this._mergeEvents(events.evalJSON());
    this._populate();
  },
  doParsing: function() {
    for(var i=0;i<this.jsonEvents.results.length;i++) {
			// TODO: Use source for all collection classes too
			source = new ETLEventSource(this.jsonEvents.results[i]);
			
			if (source.isArtifact(this.jsonEvents.results[i])) {
        window._ETLArtifactSection.addItem(this.jsonEvents.results[i]);
        this.artifactItems.push(this.jsonEvents.results[i]);
      } else {
          //TODO: non artifact items
      }
			//TODO: parsing event item
			this.eventItems.addSource(this.jsonEvents.results[i]);
    }
    this.eventItems.populate();
  },
  populateResults: function(){
    window._ETLArtifactSection.populate();
		window._ETLArtifactSection.randomize();
		
		window._ETLEventSection.addContent(this.eventItems.html);
    window._ETLEventSection.populate();
    
    //window._ETLTimeline.populate();
  }
});

//Eternos Timeline Search. init: timeline object and {startDate: 'sring date', endDate: 'string date', options: 'string'}
var ETLSearch = Class.create({
  initialize: function(params){
    var date = new Date();
    
    this.searchUrl = "/timeline/search/js/";
    this.startDate = params.startDate || new ETLDate(date).outDate;
    this.endDate = params.endDate || new ETLDate(date).outDate;
    this.options = params.options;
    this.complete = false;
    
    this._getFullSearchUrl();
    this._getJSON(window._ETLTimeline, this.fullSearchUrl);
  },
  _getFullSearchUrl: function(){
    this.fullSearchUrl = this.searchUrl + window._ETLMemberID +'/'+ this.startDate +'/'+ this.endDate +'/'+ this.options
  },
  _getJSON: function(tmline, url){
    new Ajax.Request(url, {
      method: 'get',
      onSuccess: function(transport){
        var response = transport.responseText || "";
        tmline.pushRawEvents(response);
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
});

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
    this.options = params.options;
    this.rawEvents = new ETLEventParser(ETLUtil.emptyResponse);
    
    this._setReqDates();
    this._setupTheme();
    this._setupEvents();
    this._setupBands(this);
    this.init(true);
  },
  _setupTheme: function(){
    this.theme = Timeline.ClassicTheme.create();
  },  
  _setupEvents: function(){
    this.eventSources = new Timeline.DefaultEventSource();
    if (this.rawEvents != undefined){
			var item;
			for(var i=0;i<this.rawEvents.eventItems.items.length;i++){
				
        //item = new ETLTimelineEvent(this.rawEvents.eventItems.items[i]);
        //this.eventSources.add(item.event);
        
				item = this.rawEvents.eventItems.items[i];
        var start_date = new ETLDate(item.start_date, 'str').outDate;
				var end_date = new ETLDate(item.end_date, 'str').outDate;
				var title = item.title;
				var description = "";
				var event = new Timeline.DefaultEventSource.Event({
					start: start_date,
					text: title,
					description: description});
        this.eventSources.add(event);
          
			}
    }
  },
  _setupBands: function(obj){
    var date = new Date();
    this.bandInfos = [
      Timeline.createBandInfo({
        width: "20%", 
        intervalUnit: Timeline.DateTime.DECADE, 
        intervalPixels: 200,
        date: date,
        showEventText: false,
        theme: this.theme
      }),   
      Timeline.createBandInfo({
        width: "55%",
        intervalUnit: Timeline.DateTime.DAY,
        intervalPixels: 100,
        date: date,
        eventSource: this.eventSources,
        theme: this.theme
      }),
      Timeline.createBandInfo({
        width: "13%",
        intervalUnit: Timeline.DateTime.MONTH,
        intervalPixels: 500,
        date: date,
        overview: true,
        theme: this.theme
      }),
      Timeline.createBandInfo({
        width: "12%",
        intervalUnit: Timeline.DateTime.YEAR,
        overview: true,
        date: date,
        intervalPixels: 500,
        theme: this.theme
      })
     ];    
    
    this.bandInfos[0].syncWith = 1;
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
      window._ETLResizeTimerID = new PeriodicalExecuter(function(pe){
        window._ETLResizeTimerID = null;
      }, 0.5)
    }
  },
  _handleBandScrolling: function(){
    var tlMinDate = this.tlMinDate;
    var tlMaxDate = this.tlMaxDate;
    this.timeline.getBand(1).addOnScrollListener(function(band){
      //console.log("MAX timeline...band: "+tlMaxDate.monthRange(0,'')+"..."+band.getMaxVisibleDate().monthRange(0,''));
      //console.log("MIN timeline...band: "+tlMinDate.monthRange(0,'')+"..."+band.getMinVisibleDate().monthRange(0,''));
      window._ETLTimeline.timeline.hideBackupMessage();
      var start_date; var end_date;
      if(band.getMaxVisibleDate() > tlMaxDate){ 
        start_date = tlMaxDate.monthRange(0, '');
        end_date = tlMaxDate.monthRange(2, 'next');
        tlMaxDate.setMonth(tlMaxDate.getMonth()+2);
        window._ETLTimeline.searchEvents({startDate: start_date, endDate: end_date, options: window._ETLTimeline.options});
      } else if(band.getMinVisibleDate() < tlMinDate){
        start_date = tlMinDate.monthRange(2, 'prev');
        end_date = tlMinDate.monthRange(0, '');       
        tlMinDate.setMonth(tlMinDate.getMonth()-2); 
        window._ETLTimeline.searchEvents({startDate: start_date, endDate: end_date, options: window._ETLTimeline.options});
      }
      //console.log(start_date+"---"+end_date);
    });
    //console.log("Updated date: "+this.tlMaxDate);
  },
  _setReqDates: function(){
    this.currentDate = new Date();
    this.tlMinDate = new Date();
    this.tlMaxDate = new Date();
    this.tlMinDate.setMonth(this.tlMinDate.getMonth()-1);
    this.tlMaxDate.setMonth(this.tlMaxDate.getMonth()+1);
  },
  _create: function(){
    this.timeline = Timeline.create($(this.domID), this.bandInfos);
		this.timeline.addCustomMethods();
  },
  init: function(first_init){
    //first_init parameter:
    //true, include default search for first timeline init, and false vice versa
    this._create();
    this._handleWindowResize();
    this._handleBandScrolling();
    if(first_init){
      this.assignObject();
      this.searchEvents();
    }
  },
  assignObject: function(){
    window._ETLTimeline = this;
  },
  showLoading: function(){
    this.timeline.showLoadingMessage();
  },
  hideLoading: function(){
    this.timeline.hideLoadingMessage();
		this.timeline.showBackupMessage();
  },
  showError: function(){
    this.hideLoading();
    //TODO:
  },
  showBubble: function(elements){},
  searchEvents: function(params){
    //var params = {startDate: this.startDate, endDate: this.endDate, options: this.options}
		var p = (params == undefined) ?  {startDate: this.currentDate.monthRange(1,'prev'), endDate: this.currentDate.monthRange(1,'next'), options: this.options} : params;
    new ETLSearch(p);
  },
  pushRawEvents: function(events){
    this.unprocessedEvents = events;
    this.rawEvents.pushEvents(this.unprocessedEvents);
    this.populate();
  },
  populate: function(){
    this._setupEvents();
		this._setupBands(this);
    this.init(false);
  }
})

// HTML Templates for all dynamic DOM content
var eventListTemplates = {
	events: function() {
		return new Template("<div class=\"storybox-top\"><div class=\"title5\">#{title}</div></div>" + 
			"<div class=\"storybox\">#{events}</div><img src=\"/images/storybox-bottom.gif\" /></div>");
	},
	eventGroup: function() { 
		return new Template('<div class="event_list_group"><div class="event_list_date">#{date}</div>' +
			'<div class="event_list_group_items"><ul>#{body}</ul></div></div>'); 
	},
	eventArtifactItem: function() {
		return new Template('<li><div class="event_list_group_item"><a href="#{link_url}" class="lightview" rel="#{link_rel}">#{title}</a>#{other_items}</div></li>');
	},
	hiddenItem: function() {
		return new Template('<a href="#{link_url}" class="lightview" rel="#{link_rel}"></a>');
	},
	eventItemWithTooltip: function() {
		return new Template('<a class="tooltip-target" rel="{fixed: true, ' +
			'width: \'auto\', hideOthers: true, viewport: true, hook: {target: \'topRight\', ' +
			'tip: \'bottomLeft\'}, stem: \'bottomLeft\'}">#{title}</a>' +
			'<span class="tooltip">#{tooltip_content}</div>');
	}
};

var artifactTemplates = {
	artifacts: function() {
		return new Template("<div class=\"artibox-top\"><div class=\"title5\">#{title}</div></div>" + 
			"<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" +
			"<img src=\"/images/artibox-bottom.gif\" /></div>");
	},
	artifactBox: function() {
		return new Template("<li id=\"etl-artifact-item-#{num}\" #{style}><a href=\"#{url}\" " +
		"class=\"lightview\" rel=\"set[artifacts]\" title=\":: :: slideshow: true, autosize: true, fullscreen: true\"><img src='#{thumbnail_url}' class='thumnails2'/></a>" +
			"</li>");
	}
};

var draw = function() {
	new ETLMonthSelector(options.month_selector_id);
  new ETLArtifactSection(options.artifact_section_id);
  new ETLEventSection(options.events_section_id);
  new ETLBase(options.timeline_section_id, options.timeline_opts);
}

// Set public methods now
me.draw = draw;
me.api	= api;

// Return 'class' object with only public methods exposed.
return me;
};


