//required Date' prototypes
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

//required constants 
ETLEventNames = function(){}
ETLEventNames.itemTypes = ["FacebookActivityStreamItem", "TwitterActivityStreamItem", "FeedEntry", "BackupEmail", "Photo", "Job", "Address"];
ETLEventNames.singularTypes = ["A Facebook Activity", "A Twitter Activity", "A Blog Post", "A New Email", "A Photo Backup", "A Job Update", "An Address Update"];
ETLEventNames.pluralTypes = ["Facebook Activities", "Twitter Activities", "Blog Posts", "New Emails", "Photo Backups", "Job Updates", "Address Updates"];

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
    this.top    = "<a href=\"#\" class=\"btn-left\" onclick=\"window._ETLMonthSelector.stepMonth('down'); return false;\"></a>";
    this.bottom = "<a href=\"#\" class=\"btn-right\" onclick=\"window._ETLMonthSelector.stepMonth('up'); return false;\"></a>";
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

//Eternos Timeline Artifact Section
var ETLArtifactSection = Class.create({
  initialize: function(domID){
    this.parent = $(domID);
		this.numShowed = 12;
		this.timeOut = 3;
    this.title = "Artifacts";
    this.bottom = "</div><img src=\"/images/artibox-bottom.gif\" /></div>";
    this.items = new Array();
		this._getTop();
		this.showLoading();
  },
	_getTop: function(){
		this.top = "<div class=\"artibox-top\"><div class=\"title5\">"+this.title+"</div></div><div class=\"artibox\">";
	},
  _clearContent: function(){
    this.content = "";
  },
  _itemsToS: function(){
		this.content += "<ul id=\"etl-artifact-items\" style=\"list-style-type:none\">"
    for(var i=0;i<this.items.length;i++){
			var ul_class = (i >= this.numShowed) ? "class=\"hidden-artifact-item\" style=\"display:none\"" : " class=\"visible-artifact-item\"";
			if (this.items[i] !== undefined && this.items[i].attributes.thumbnail_url !== undefined) {
		  	this.content += ("<li id=\"etl-artifact-item-"+i+"\""+ul_class+"><a href=\""+this.items[i].attributes.url+"\" class=\"lightview\" rel=\"set[artifacts]\"><img src='" + this.items[i].attributes.thumbnail_url + "' class='thumnails2' /></a></li>");
	    }
    }
		this.content += "</ul>";
  },
  _write: function(){
    this.parent.innerHTML = this.top+this.content+this.bottom;
    window._ETLArtifactSection = this;
  },
  randomize: function(){
	  var v = $$('li.visible-artifact-item');
		var h = $$('li.hidden-artifact-item');
		new PeriodicalExecuter(function(pe) {
			if (v.length > 0) {
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
		this._getTop();
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
  }
})

//Eternos Timeline Event Item
var ETLEventItem = Class.create({
  initialize: function(items){
    this.type = items[0].type;
    this.start_date = items[0].start_date;
    this.end_date = items[0].end_date;
    
    this.num = items.length;
    this.items = items;
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
    //console.log(this.title);
  },
  _setHtml: function(){
    this.html = "<li><p>"+this.title+" | "+this.start_date+"</p></li>"
  }
})

//Eternos Timeline Event Item Detail
var ETLEventItemDetail = Class.create({
  initialize: function(event){
    this.source = event;
  }
})

//Eternos Timeline Event Collection
var ETLEventCollection = Class.create({
	initialize: function(){
		this.sources = new Array();
		this.dates = new Array();
		this.rawItems = new Array();
		this.items = new Array();
	},
	addSource: function(s){
	  var source = new ETLEventSource(s);
	  this.sources.push(source);
	  
		if(!this.dates.include(source.start_date)){
		  this.dates.push(source.start_date);
		  this.rawItems[this.dates.length-1] = new Array(source);
		} else {
		  this.rawItems[this.dates.indexOf(source.start_date)].push(source);
		}
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
	populate: function(){
	  var items; var event;
	  this.html = "";
		for(var i=0;i<this.rawItems.length;i++){
		  items = this._groupItems(this.rawItems[i]);
		  for(var j=0;j<items.length;j++){
		    event = new ETLEventItem(items[j]);
        this.items.push(event);
        this.html += event.html;
		  }
		}
		console.log(this.html);
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
  _eventIsArtifact: function(e) {
		return (e.type === 'BackupPhoto' || e.type === 'Photo' || e.type === 'Video' ||
		e.type === 'WebVideo') || 
		((e.type === 'FacebookActivityStreamItem' || e.type === 'TwitterActivityStreamItem') && 
		(e.attributes.attachment_type === 'photo' || e.attributes.attachment_type === 'video'));
	},
  doParsing: function() {
    for(var i=0;i<this.jsonEvents.results.length;i++) {
			if (this._eventIsArtifact(this.jsonEvents.results[i])) {
        window._ETLArtifactSection.addItem(this.jsonEvents.results[i]);
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
//    if (window._ETLResizeTimerID == null) {
//      window._ETLResizeTimerID = window.setTimeout(function() {
//        window._ETLResizeTimerID = null;
//      }, 500);
//    }    
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
    var prm = {startDate: '2009-02-01', endDate: '2009-03-01', options: this.options}
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

