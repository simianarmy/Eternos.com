//message box for timeline
Timeline._Impl.prototype.addCustomMethods = function() {
	var containerDiv = this._containerDiv;
	var doc = containerDiv.ownerDocument;

	var message = SimileAjax.Graphics.createMessageBubble(doc);
	message.containerDiv.className = "timeline-message-container";
	containerDiv.appendChild(message.containerDiv);

	message.contentDiv.className = "timeline-message";
	message.contentDiv.innerHTML = "Please backup your accounts first";

	this.showMessageBox = function() { message.containerDiv.style.display = "block"; };
	this.hideMessageBox = function() { message.containerDiv.style.display = "none"; };
};


//required Date' prototypes
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

//required Array' prototypes 
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

// Date parsing regex & sort function
var dateRE = /^(\d{4})\-(\d{2})\-(\d{2})/;

var orderDatesDescending = function(x, y) {
	x = x.replace(dateRE,"$1$2$3");
	y = y.replace(dateRE,"$1$2$3");
	if (x > y) return -1
	if (x < y) return 1;
	return 0; 
};

//required constants 
var ETLEventNames = function(){}
ETLEventNames.itemTypes = ["FacebookActivityStreamItem", "TwitterActivityStreamItem", "FeedEntry", "BackupEmail", "Photo", "Job", "Address"];
ETLEventNames.singularTypes = ["Facebook Post", "Tweet", "Blog Post", "Email", "Photo", "A Job Update", "An Address Update"];
ETLEventNames.pluralTypes = ["Facebook Posts", "Tweets", "Blog Posts", "Emails", "Photos", "Job Updates", "Address Updates"];

//Utilities
ETLUtil = function(){}
ETLUtil.pause = function(ms){
	var d = new Date();
	var c = null;

	do { c = new Date(); }
	while(c-d < ms);	
}

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
		this.numShowed = 12;
		this.timeOut = 3;
    this.title = "Artifacts";
		this.content = '';
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
    this.parent = $(domID);
    this.title = "Events";
    this.loading = "<p>Loading Events..</p><br/>";
    this.content = "";
    this.top = "<div class=\"storybox-top\"><div class=\"title5\">"+this.title+"</div></div><div class=\"storybox\">";
    this.bottom = "</div><img src=\"/images/storybox-bottom.gif\" /></div>";
    this.images = new Array();
    this.populate();
    this.showLoading();
  },
  _clearContent: function(){
    this.content = "";
  },
  _write: function(){
    this.parent.innerHTML = this.top+this.content+this.bottom;
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
		return (this.type === 'BackupPhoto' || this.type === 'Photo' || this.type === 'Video' ||
		this.type === 'WebVideo') || 
		((this.type === 'FacebookActivityStreamItem' || this.type === 'TwitterActivityStreamItem') && 
		(this.attributes.attachment_type === 'photo'));
	}
});

//Eternos Timeline Event Item
var ETLEventItem = Class.create({
  initialize: function(items){
		this.source 			= s = new ETLEventSource(items[0]);
    this.type 				= s.type;
    this.start_date 	= s.start_date;
    this.end_date 		= s.end_date;
		this.attributes 	= s.attributes;
    this.num 					= items.length;
    this.items 				= items;
		this.html 				= '';
		this.template 		= eventListTemplates.eventItem();
		
    this._setTitle();
    this._setHtml();
  },
  _setTitle: function(){
    if(this.items.length>1){
      this.title = this.num +" "+ ETLEventNames.pluralTypes[ETLEventNames.itemTypes.indexOf(this.items[0].type)];
    }else if(this.items.length==1){
      this.title = ETLEventNames.singularTypes[ETLEventNames.itemTypes.indexOf(this.items[0].type)];
    }else{
      this.title = "Invalid event";
    }
  },
  _setHtml: function(){
		this.html = this.template.evaluate({title: this.title, link_url: this._getLinkUrl(), link_rel: this._getLinkRel()});
  },
	_getLinkUrl: function() {
		return this.attributes.url;
	},
	// Determine 'rel' attribute for Lightview link html
	_getLinkRel: function() {
		if (this.source.isArtifact()) {
			return 'image';
		} else {
			return 'ajax';
		}
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
    this.assetUrl = "http://simile.mit.edu/timeline/api/";
    this.imgUrl = this.assetUrl + "images/";
    this.title = this.desc = this.img = this.link = this.icon = this.color = this.tcolor = "HALLO";
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
		//console.log("Active year/month = " + year + '/' + month);
		// Sort items by descending array
		this.dates.sort(orderDatesDescending);
		//console.log("sorted dates " + this.dates);

		// Only use events that fall in the active date month
		active = this.dates.select(function(d) {
			return (d !== undefined && parseInt(d.substr(0, 4)) === year && parseInt(d.substr(5, 2), 10) === month);
		});
		//console.dir(active);
		active.each(function(d) {
			//console.log("date = " + d);
			val = this.rawItems[d];
			//console.dir(val);
			items_html = ''
			items = this._groupItems(val);
			//console.dir(items);

			for(var j=0;j<items.length;j++){
				event = new ETLEventItem(items[j]);
				this.items.push(event);
				items_html += event.html;
			}
			this.html += this.groupTemplate.evaluate({date: d, body: items_html});
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
	_eventDateHtml: function(date) {
		return ''
	}
	
})

//Eternos Timeline Artifact 
var ETLArtifact = Class.create({
	initialize: function(object) {
		this.type = object.type;
		this.attributes = object.attributes;
	},
	
});

//Eternos Timeline Event Parser
var ETLEventParser = Class.create({
  initialize: function(events){
    this.eventItems = new ETLEventCollection();
    this.artifactItems = new Array();
    this.jsonEvents = events.evalJSON();
    this.doParsing();
		this.populateResults();
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

//Eternos Timeline Search
//init: timeline object and {startDate: 'sring date', endDate: 'string date', options: 'string'}
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
        tmline.parseSearchResults(response);
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
		this.currentDate = date;
    
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
				item = this.rawEvents.eventItems.items[i];

				var start_date = new ETLDate(item.start_date, 'str').outDate;
				var end_date = new ETLDate(item.end_date, 'str').outDate;
				var title = item.title;
				var description = "";
				var event = new Timeline.DefaultEventSource.Event(start_date, end_date, start_date, end_date, true, title, description, "", "", "", "", "");
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
    this.timeline.getBand(1).addOnScrollListener(function(band){
      var min_date = new ETLDate(band.getMinVisibleDate()).outputDate;
      var max_date = new ETLDate(band.getMaxVisibleDate()).outputDate;

      //TODO:
			//ETLUtil.pause(1000);
			//console.dir(band._onScrollListeners);
    });
  }, 
  _create: function(){
    this.timeline = Timeline.create($(this.domID), this.bandInfos);
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
  parseSearchResults: function(results){
    this.searchResults = results;
    this.rawEvents = new ETLEventParser(this.searchResults);
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
	eventGroup: function() { 
		return new Template('<div class="event_list_group"><div class="event_list_date">#{date}</div>' +
			'<div class="event_list_group_items"><ul>#{body}</ul></div></div>'); 
	},
	eventItem: function() {
		return new Template('<li><div class="event_list_group_item"><a href="#{link_url}" class="lightview" rel="#{link_rel}">#{title}</a></div></li>');
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
