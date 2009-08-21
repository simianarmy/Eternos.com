// $Id$
//

// Timeline javascript module
// required Date' prototypes
Date.prototype.numDays = function () {
  return 32 - new Date(this.getFullYear(), this.getMonth(), 32).getDate();
}
Date.prototype.getFullMonth = function () {
  var m = this.getMonth() + 1 + "";
  return (m.length < 2) ? "0" + m : m;
}
// Returns YYYY-MM-DD string
Date.prototype.startingMonth = function () {
  return this.getFullYear() + "-" + this.getFullMonth() + "-01";
}
// Returns YYYY-MM-DD string
Date.prototype.endingMonth = function () {
  return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.numDays();
}
Date.prototype.getMonthName = function () {
  var nm = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  var nu = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  return nm[this.getMonth()];
}
Date.prototype.stepMonth = function (param) {
  if (param == 'up') {
    if (this.getMonth() == 11) {
      this.setMonth(0);
      this.setFullYear(this.getFullYear() + 1);
    } else {
      this.setMonth(this.getMonth() + 1);
    }
  } else if (param == 'down') {
    if (this.getMonth() == 0) {
      this.setMonth(11);
      this.setFullYear(this.getFullYear() - 1);
    } else {
      this.setMonth(this.getMonth() - 1);
    }
  }
	return this;
}
Date.prototype.monthRange = function (num, dir) {
  var set_up = function (d) {
    d.setMonth(d.getMonth() + num)
  }
  var set_down = function (d) {
    d.setMonth(d.getMonth() - num)
  }

  dir == 'next' ? set_up(this) : set_down(this);
  var rv = this.getFullYear() + "-" + this.getFullMonth() + "-" + this.getDate();
  dir == 'next' ? set_down(this) : set_up(this);

  return rv;
}

// required Array' prototypes 
Array.prototype.unique = function () {
  var r = new Array();
  o: for (var i = 0, n = this.length; i < n; i++) {
    for (var x = 0, y = r.length; x < y; x++) {
      if (r[x] == this[i]) {
        continue o;
      }
    }
    r[r.length] = this[i];
  }
  return r;
}
Array.prototype.randResult = function () {

}
Array.prototype.include = function (val) {
  return this.index(val) !== null;
}

//Date parsing regex & sort function
var MysqlDateRE = /^(\d{4})\-(\d{2})\-(\d{2})T?.*/;
var mysqlTimeToDate = function (datetime) {
  //function parses mysql datetime string and returns javascript Date object
  //input has to be in this format: 2007-06-05 15:26:02
  var regex = /^([0-9]{2,4})-([0-1][0-9])-([0-3][0-9]) (?:([0-2][0-9]):([0-5][0-9]):([0-5][0-9]))?$/;
  var parts = datetime.replace(regex, "$1 $2 $3 $4 $5 $6").split(' ');
  return new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4], parts[5]);
}
var mysqlDateToDate = function (date) {
  //function parses mysql datetime string and returns javascript Date object
  //input has to be in this format: 2007-06-05
  var parts = date.replace(MysqlDateRE, "$1 $2 $3").split(' ');
  return new Date(parts[0], parts[1] - 1, parts[2]);
}
var orderDatesDescending = function (x, y) {
  x = x.replace(MysqlDateRE, "$1$2$3");
  y = y.replace(MysqlDateRE, "$1$2$3");
  if (x > y) return -1
  if (x < y) return 1;
  return 0;
};


// ETimeline 'class'
var ETimeline = function (opts) {
  // Private instance of this object for private methods to use
  var that = this;
  var me = new Object();
  var options = Object.extend(opts, {});
  var api = '0.1';
	
  // Private instances & functions
	that.templates = ETemplates;
  that.options = options;
	that.monthSelector = null;

  var ETLUtil = {
    pauseExec: function (ms) {
      var d = new Date();
      var c = null;

      do {
        c = new Date();
      }
      while (c - d < ms);
    },
    emptyResponse: "{\"results\": [], \"previousDataUri\": null, \"responseDetails\": null, \"request\": \"\", \"resultCount\": 0, \"status\": 200, \"futureDataUri\": null}",
    assetUrl: "http://simile.mit.edu/timeline/api/",
    imgUrl: "images/",
    iconPostfix: "-circle.png",
    blankArtifactImg: "<div style=\"padding-left:5px;margin-top:5px;\"><img src=\"/images/blank-arftifacts.gif\"></div>",
    tlEffectiveWidth: 750
  };

  //Eternos Timeline Date
  var ETLDate = Class.create({
    initialize: function (date, format) {
      this.inDate = date;
      this.inFormat = format || 'natural';
      this.getOutDate();
    },
    getOutDate: function () {
      if (this.inFormat == 'natural') {
        this.outDate = this.inDate.getFullYear() + '-' + this.inDate.getMonth()+1 + '-' + this.inDate.getDate();
      } else if (this.inFormat == 'gregorian') {
        this.outDate = Timeline.DateTime.parseGregorianDateTime(this.inDate.substr(0, 4));
      } else {
        this.outDate = mysqlDateToDate(this.inDate);
      }
    }
  });

  //Eternos Timeline Selector
  var ETLMonthSelector = Class.create({
    initialize: function (domID) {
      this.parent = $(domID);
      this.activeDate = new Date();
      this.advanceMonths = new Array();
      this.pastMonths = new Array();
			this.template = that.templates.monthSelectorTemplate();
      
      this.populate();
    },
    _initContent: function () {
      this.activeMonth = this.activeDate.getMonthName();
      this.activeYear = this.activeDate.getFullYear();
    },
    _write: function () {
      this.parent.innerHTML = this.template.evaluate({month: this.activeMonth, year: this.activeYear});
    },
    disableClick: function () {
			
    },
    enableClick: function () {
      Event.observe($('month_selector_down'), 'click', function(event) { that.monthSelector.stepMonth('down'); event.stop(); });
			Event.observe($('month_selector_up'), 'click', function(event) { that.monthSelector.stepMonth('up'); event.stop(); });
    },
    populate: function () {
      this._initContent();
      this._write();
			this.enableClick();
    },
    stepMonth: function (param) {
      this.activeDate.stepMonth(param);
      this.disableClick();
      this.populate();
      var params = {
        startDate: this.activeDate.startingMonth(),
        endDate: this.activeDate.endingMonth(),
        options: that.timeline.options
      }
			// Better place for this?
			that.timeline.eventsLoading(this.activeDate);
      that.timeline.searchEvents(params);
    }
  });

  //Eternos Timeline Artifact Section
  var ETLArtifactSection = Class.create({
    initialize: function (domID) {
      this.parent = $(domID);
      this.numShowed = 18;
      this.timeOut = 3;
      this.title = "Artifacts";
      this.template = that.templates.artifactTemplates.artifacts();
      this.loadingTemplate = that.templates.loadingTemplate();
      this.boxTemplate = that.templates.artifactTemplates.artifactBox();
      this.blankImg = this.items = new Array();

      this.showLoading();
    },
    _clearContent: function () {
      this.content = "";
    },
    _itemsToS: function (activeDate) {
			var targetDate = activeDate.startingMonth();
			var ul_class;
			var realthis = this;
			
			console.log("Displaying artifacts for: " + activeDate);
			
			// Skip any items that don't have thumbnail or don't fall on target month
			this.items.findAll(function(i) {
				return (i !== undefined) && (i.attributes.thumbnail_url !== undefined) &&
					(mysqlDateToDate(i.start_date).startingMonth() === targetDate);
			}).each(function(item, i) {
				ul_class = (i >= that.numShowed) ? "class=\"hidden-artifact-item\" style=\"display:none\"" : "class=\"visible-artifact-item\"";
        realthis.content += realthis.boxTemplate.evaluate({
           num: i,
           style: ul_class,
           url: item.attributes.url,
           thumbnail_url: item.attributes.thumbnail_url
       	});
      });
    },
    _write: function () {
      if (this.content === '' || this.items.length < 1) {
        this.content = ETLUtil.blankArtifactImg;
      }
      this.parent.innerHTML = this.template.evaluate({
        title: this.title,
        artifacts: this.content
      });
    },
    randomize: function () {
      var v = $$('li.visible-artifact-item');
      var h = $$('li.hidden-artifact-item');
      new PeriodicalExecuter(function (pe) {
        if (h.length > 0 && v.length > 0) {
          var i = Math.floor(Math.random() * v.length);
          var j = Math.floor(Math.random() * h.length);
          var tmp = v[i].childElements()[0].childElements()[0].src;

          v[i].pulsate({
            pulses: 1,
            duration: 1.5
          });
          v[i].childElements()[0].childElements()[0].src = h[j].childElements()[0].childElements()[0].src;
          h[j].childElements()[0].childElements()[0].src = tmp;
        }
      },
      this.timeOut);
    },
    addItem: function (item) {
      this.items.push(item);
    },
    addItems: function (items) {
      for (var i = 0; i < items.length; i++) {
        this.addItem(items[i]);
      }
    },
    populate: function (activeDate) {
      this._clearContent();
      this._itemsToS(activeDate);
      this._write();
    },
    showLoading: function () {
      this._clearContent();
      this.content = this.loadingTemplate.evaluate({type: " Artifacts"});
      this._write();
    },
    updateTitle: function (title) {
      this.title = title;
      this._write();
    }
  });

  //Eternos Timeline Event Section
  var ETLEventSection = Class.create({
    initialize: function (domID) {
      this.parent = $(domID);
      this.title = "Events";
      this.loading = that.templates.loadingTemplate().evaluate({type: " Events"});
      this.template = that.templates.eventListTemplates.events();
      this.content = "";
      this.images = new Array();

      this.populate();
      this.showLoading();
    },
    _clearContent: function () {
      this.content = "";
    },
    _write: function () {
      this.parent.innerHTML = this.template.evaluate({
        title: this.title,
        events: this.content
      });
			that.templates.eventListTemplates.createEventItemTooltips();
    },
    populate: function (content) {
			var html = content || '';
			this.content = html;
      this._write();
    },
    showLoading: function () {
      this.populate(this.loading);
    },
    updateTitle: function(title){
      this.title = title;
      this._write();
    }
  });

  //Eternos Timeline Event Item(s)
  var ETLEventItems = Class.create({
    initialize: function (items) {
      this.items = items;
      this.first = s = ETEvent.createSource(items[0]);
      this.type = s.type;
      this.start_date = s.start_date;
      this.end_date = s.end_date;
      this.attributes = s.attributes;
      this.num = items.length;
      this.items = items;
      this.html = '';
      this.hiddenItemTemplate = that.templates.eventListTemplates.hiddenItem();
      this.itemWithTooltipTemplate = that.templates.eventListTemplates.eventItemWithTooltip();
			this.tooltipItemTemplate = that.templates.eventListTemplates.eventItemTooltipItem();
			this.inlineEventsTemplate = that.templates.eventListTemplates.inlineEvents();
    },
    _setTitle: function () {
      if (this.num > 1) {
        this.title = this.num + " " + this.first.display_text_plural;
      } else if (this.num == 1) {
        this.title = this.first.display_text;
      }
    },
    _setHtml: function () {
      // Need to format the link so all content will be displayed
      if (this.first.isArtifact()) {
        this.html = this._getArtifactItemHtml();
      } else {
        this.html = this._getInlineItemHtml();
      }
    },
    _getLinkUrl: function (item) {
      if (item.isArtifact()) {
        return item.attributes.url;
      } else {
				// For Lightview inline popups
				// References div with id = '#id'
				//return '#' + item.attributes.id;
				return item.dateDetailsPath(that.memberID);
			}
    },
    // Determine 'rel' attribute for Lightview link html
    _getLinkRel: function () {
      if (this.first.isArtifact()) {
        // Lightview auto-detects content so just need to know if gallery or not
        return (this.num > 1) ? 'gallery[' + this.first.attributes.id + ']' : '';
      } else {
        return 'iframe';
      }
    },
    _getArtifactItemHtml: function () {
      var other_items = '';
      if (this.num > 1) {
        for (var i = 1; i < this.num; i++) {
          other_items += this.hiddenItemTemplate.evaluate({
            link_url: this._getLinkUrl(this.items[i]),
            link_rel: this._getLinkRel()
          });
        }
      }
			return this.itemWithTooltipTemplate.evaluate({
        title: this.title,
				link_url: this._getLinkUrl(this.first),
        link_rel: this._getLinkRel(),
        hidden_items: other_items,
        tooltip_content: this._getTooltipContents()
      });
    },
    _getInlineItemHtml: function () {
      return this.itemWithTooltipTemplate.evaluate({
        title: this.title,
				link_url: this._getLinkUrl(this.first),
        link_rel: this._getLinkRel(),
        tooltip_content: this._getTooltipContents()
				//inline_content: this._getInlineContents()
      })
    },
    _getTooltipContents: function () {
      var html = '';
      this.items.each(function (item) {
				html += this.tooltipItemTemplate.evaluate({content: item.getPreviewHtml()});
      }, this);
      return html;
    },
		_getInlineContents: function() {
			return this.inlineEventsTemplate.evaluate({id: this.first.attributes.id, 
				content: 'TODO'});
		},
    populate: function () {
      this._setTitle();
      this._setHtml();
      return this.html;
    }
  });


  //Eternos Timeline Event Source (Timeline.DefaultEventSource.Event)
	// FIXME: Duplicates ETLEventSource class functionality
	
  var ETLTimelineEvent = Class.create({
    initialize: function (event) {
      var date = new ETLDate(event.start_date, 'rev').outDate;
      this.start_date = this.start_end = this.earliest = this.latest = date;
      this.title = event.title;
      this.type = event.type;
			this.event = null;
			
      this._toTLEventSource();
    },
    _setIcon: function () {
      var icon_s = ETEvent.getSourceIcon(this.type)
      this.icon = ETLUtil.assetUrl + ETLUtil.imgUrl + icon_s + ETLUtil.iconPostfix;
    },
    _toTLEventSource: function () {
      this._setIcon();
      this.event = new Timeline.DefaultEventSource.Event({
        start: this.start_date,
        end: this.end_date,
        latestStart: this.latest,
        earliestEnd: this.earliest,
        instant: true,
        //text: this.title,
				text: '',
        description: this.type,
        icon: this.icon
      });
    }
  });

  //Eternos Timeline Event Collection
  var ETLEventCollection = Class.create({
    initialize: function () {
      this.sources = new Array(); // Event sources
      this.dates = new Array(); // Date collection (by day)
      this.rawItems = new Array();
      this.items = new Array();
      this.html = ''
      this.groupTemplate = that.templates.eventListTemplates.eventGroup();
    },
		// Add event source to collection keyed by event date
    addSource: function (s) {
      var source = ETEvent.createSource(s);
			var day = source.eventDateString();
			
      this.sources.push(source);
      
			if (!this.dates.include(day)) {
        this.rawItems[day] = new Array(source);
        this.dates.push(day);
      } else {
        this.rawItems[day].push(source);
      }
    },
    populate: function (targetDate) {
			var td = targetDate || that.monthSelector.activeDate;
      var items, items_html;
      var event;
      var date;
      var year = td.getFullYear();
      var month = td.getMonth() + 1;
			
			console.log("Populating with events from " + month + "/" + year);

			// Clear any old html
			this.html = '';
			
      // Sort items by descending array
      this.dates.sort(orderDatesDescending);

      // Only use events that fall in the active date month
      var active = this.dates.select(function (d) {
        return (d !== undefined && parseInt(d.substr(0, 4)) === year && parseInt(d.substr(5, 2), 10) === month);
      });
      active.each(function (d) {
        var val = this.rawItems[d];
        items_html = ''
        items = this._groupItems(val);
				
       	items.each(function(group, index) {
          event = new ETLEventItems(group);
          this.items.push(event);
          items_html += event.populate();
        }, this);
        this.html += this.groupTemplate.evaluate({
          date: this._eventDate(d),
          body: items_html
        });
      },
      this);
			
			return this.html;
    },
		// Group event items by type in arrays
    _groupItems: function (items) {
      var types = [];
      var results = new Array();

      for (var i = 0; i < items.length; i++) {
				idx = types.indexOf(items[i].type);
				if (idx !== -1) {
          results[idx].push(items[i]);
        } else {
					types.push(items[i].type);
          results[types.length-1] = new Array(items[i]);
        }
      }
      return results;
    },
    _eventDate: function (date) {
      var d = mysqlDateToDate(date);
      return d.toLocaleDateString();
    }
  });

  //Eternos Timeline Event Parser
  var ETLEventParser = Class.create({
    initialize: function (events) {
      this.eventItems = new ETLEventCollection();
      this.jsonEvents = events.evalJSON();
      this._populate();
    },
    _populate: function () {
      this.doParsing();
      this.populateResults();
    },
    _mergeEvents: function (events) {
			console.log("Merging events");
      //var merged = this.jsonEvents.results.concat(events.results);
      //this.jsonEvents.results = merged;
			this.jsonEvents = events;
    },
    pushEvents: function (events) {
      this._mergeEvents(events.evalJSON());
      this._populate();
    },
    doParsing: function () {
      for (var i = 0; i < this.jsonEvents.results.length; i++) {
				if (ETEvent.isArtifact(this.jsonEvents.results[i].type)) {
          that.artifactSection.addItem(this.jsonEvents.results[i]);
        } 
        this.eventItems.addSource(this.jsonEvents.results[i]);
      }
    },
    populateResults: function (date) {
			var targetDate = date || that.monthSelector.activeDate;
			
      that.artifactSection.populate(targetDate);
      that.artifactSection.randomize();

      that.eventSection.populate(this.eventItems.populate(targetDate));

      //that.timeline.populate();
    }
  });

  //Eternos Timeline Search. init: timeline object and {startDate: 'sring date', endDate: 'string date', options: Object}
  var ETLSearch = Class.create({
    initialize: function (timeline, params) {
      var date = new Date();

      this.searchUrl = "/timeline/search/js/";
      //this.startDate = '2008-01-01'; 
      //this.endDate = '2010-01-01'; 
			this.startDate = params.startDate || new ETLDate(date).outDate;
      this.endDate = params.endDate || new ETLDate(date).outDate;
      this.options = Object.toQueryString(params.options);
      this.complete = false;
			this.timeline = timeline;
			
      this._getFullSearchUrl();
      this._getJSON(this.fullSearchUrl);
    },
    _getFullSearchUrl: function () {
      this.fullSearchUrl = this.searchUrl + that.memberID + '/' + this.startDate + '/' + this.endDate + '/' + this.options
    },
    _getJSON: function (url) {
			var timeline = this.timeline;
			
      new Ajax.Request(url, {
        method: 'get',
        onSuccess: function (transport) {
          var response = transport.responseText || "";
					timeline.onSearchSuccess(response);
        },
        onFailure: function () {
          timeline.onSearchError();
        },
        onLoading: function () {
          timeline.onSearching();
        }
      });
    }
  });
	
  // Eternos Timeline Base
	// params:
	//	memberID
	//	startDate
	//	endDate
	//	options:
	//		fake: true|false
	//		max_results
  var ETLBase = Class.create({
		// Basic min-max date cache object for search results cacheing
    initialize: function (domID, params) {
      that.memberID = params.memberID;
      that.resizeTimerID = null;

			this.searchCache = {
				searched: [],
				
				hashDate: function(d) {
					return d.getFullYear() + d.getFullMonth();
				},
				addDates: function(sd, ed) {
					var stepDate, endDate;
					if (ed < sd || ed === undefined) { return; }
		
					stepDate = new ETLDate(sd, 's').outDate;
					endDate = new ETLDate(ed, 's').outDate;
					do {
						console.log("Adding " + this.hashDate(stepDate) + " to search date cache");
						this.searched[this.hashDate(stepDate)] = true;
						stepDate.stepMonth('up');
					} while (stepDate <= endDate);
				},
				hasDates: function(sd, ed) {
					var stepDate, endDate;
					if (ed < sd || ed === undefined) { return false; }
					
					stepDate = new ETLDate(sd, 's').outDate;
					endDate = new ETLDate(ed, 's').outDate;
					console.log("Checking search cache for dates " + stepDate + " => " + endDate);
					
					var found = false;
					do {
						if (this.searched[this.hashDate(stepDate)]) {
							found = true;
							break;
						}
						stepDate.stepMonth('up');
					} while (stepDate <= endDate);
					
					return found;
				}
			};

      var date = new Date();
			
      this.domID = domID;
      this.params = params;
      this.memberID = params.memberID;
      this.startDate = params.startDate || new ETLDate(date);
      this.endDate = params.endDate || new ETLDate(date);
      this.options = params.options;
      this.rawEvents = new ETLEventParser(ETLUtil.emptyResponse);
			// Timeline instance vars
      this.timeline	 = null;
			this.memberAge	= 0;
			this.firstBandPixels = 0;
			this.theme	= null;
			this.bandInfos = [];
			this.currentDate = null;
      this.tlMinDate 	= null;
      this.tlMaxDate = null;
      this.centerDate = null;

			SimileAjax.History.enabled = false;
      this._getMemberAge();
      this._setReqDates();
      this._setupTheme();
      this._setupEvents();
      this._setupBands(this);

      this.init(true);
    },
    _getMemberAge: function(){
       this.memberAge = (new Date(parseInt(this.endDate), 01, 01)).getFullYear() - (new Date(parseInt(this.startDate), 01, 01)).getFullYear();
       this.firstBandPixels = ETLUtil.tlEffectiveWidth/(this.memberAge/10);
    },
    _setupTheme: function () {
      this.theme = Timeline.ClassicTheme.create();
    },
    _setupEvents: function () {
      this.eventSources = new Timeline.DefaultEventSource();
      if (this.rawEvents != undefined) {
        var item;
        for (var i = 0; i < this.rawEvents.eventItems.items.length; i++) {

          //item = new ETLTimelineEvent(this.rawEvents.eventItems.items[i]);
          //this.eventSources.add(item.event);
          item = this.rawEvents.eventItems.items[i];
          for(var i=0;i<this.rawEvents.eventItems.items.length;i++){
		        item = new ETLTimelineEvent(this.rawEvents.eventItems.items[i]);
		        this.eventSources.add(item.event);
					}
        }
      }
    },
    _setupBands: function (obj) {
      //var date = new Date();
      
      this.bandInfos = [ Timeline.createBandInfo({
        width: "8%",
        intervalUnit: Timeline.DateTime.DECADE,
        intervalPixels: this.firstBandPixels,
        date: this.centerDate,
        showEventText: false,
        theme: this.theme
      }), Timeline.createBandInfo({
        width: "76%",
        intervalUnit: Timeline.DateTime.DAY,
        intervalPixels: 100,
        date: this.centerDate,
        eventSource: this.eventSources,
        theme: this.theme
      }), Timeline.createBandInfo({
        width: "8%",
        intervalUnit: Timeline.DateTime.MONTH,
        intervalPixels: 500,
        date: this.centerDate,
        overview: true,
        theme: this.theme
      }), Timeline.createBandInfo({
        width: "8%",
        intervalUnit: Timeline.DateTime.YEAR,
        overview: true,
        date: this.centerDate,
        intervalPixels: 500,
        theme: this.theme
      })];

      //this.bandInfos[0].syncWith = 1;
      this.bandInfos[2].syncWith = 1;
      this.bandInfos[3].syncWith = 2;

      this.bandInfos[0].highlight = false;
      this.bandInfos[1].highlight = true;
      this.bandInfos[2].highlight = true;
      this.bandInfos[3].highlight = true;

      var start_date = new ETLDate(obj.startDate, 'gregorian').outDate;
      var end_date = new ETLDate(obj.endDate, 'gregorian').outDate;

      this.bandInfos[0].etherPainter = new Timeline.YearCountEtherPainter({
        startDate: start_date,
        multiple: 5,
        theme: this.theme
      });
      this.bandInfos[0].decorators = [
      new Timeline.SpanHighlightDecorator({
        startDate: start_date,
        endDate: end_date,
        startLabel: "birth",
        endLabel: "",
        color: "#5AAAC7",
        opacity: 50,
        theme: this.theme
      })];
      this.bandInfos[1].decorators = [
      new Timeline.SpanHighlightDecorator({
        startDate: start_date,
        color: "#B2CAD7",
        theme: this.theme
      })];
    },
    _handleWindowResize: function () {
      if (that.resizeTimerID == null) {
        that.resizeTimerID = new PeriodicalExecuter(function (pe) {
          that.resizeTimerID = null;
        },
        0.5)
      }
    },
    _handleBandScrolling: function () {
      var tlMinDate = this.tlMinDate;
      var tlMaxDate = this.tlMaxDate;

      this.timeline.getBand(1).addOnScrollListener(function (band) {
        //console.log("MAX timeline...band: "+tlMaxDate.monthRange(0,'')+"..."+band.getMaxVisibleDate().monthRange(0,''));
        //console.log("MIN timeline...band: "+tlMinDate.monthRange(0,'')+"..."+band.getMinVisibleDate().monthRange(0,''));
        that.timeline.timeline.hideBackupMessage();

        if (that.timeline._monthIsChanged(band.getCenterVisibleDate())){
          d = band.getCenterVisibleDate();
          that.timeline.centerDate = d
          that.timeline._updateTitles(d);
        }

        var start_date;
        var end_date;
        if (band.getMaxVisibleDate() > tlMaxDate) {
          start_date = tlMaxDate.monthRange(0, '');
          end_date = tlMaxDate.monthRange(2, 'next');
          tlMaxDate.setMonth(tlMaxDate.getMonth() + 2);

          that.timeline.searchEvents({
            startDate: start_date,
            endDate: end_date,
            options: that.timeline.options
          });
        } else if (band.getMinVisibleDate() < tlMinDate) {
          start_date = tlMinDate.monthRange(2, 'prev');
          end_date = tlMinDate.monthRange(0, '');
          tlMinDate.setMonth(tlMinDate.getMonth() - 2);
          that.timeline.searchEvents({
            startDate: start_date,
            endDate: end_date,
            options: that.timeline.options
          });
        }
        //console.log(start_date+"---"+end_date);
      });
      //console.log("Updated date: "+this.tlMaxDate);
    },
    _setReqDates: function () {
      this.currentDate = new Date();
      this.tlMinDate = new Date();
      this.tlMaxDate = new Date();
      this.centerDate = new Date();
      this.tlMinDate.setMonth(this.tlMinDate.getMonth() - 1);
      this.tlMaxDate.setMonth(this.tlMaxDate.getMonth() + 1);
			this.eventsLoading(this.currentDate);
    },
    _monthIsChanged: function(date){
      return (this.centerDate.getMonth() != date.getMonth());
    },
    _getTitleFromDate: function(date, type){
      return (type + " from " + date.getMonthName() + " " + date.getFullYear())
    },
    _updateTitles: function(d){
      that.artifactSection.updateTitle(this._getTitleFromDate(d, "Artifacts"));
      that.eventSection.updateTitle(this._getTitleFromDate(d, "Events"));      
    },
		_loadCached: function() {
			this.rawEvents.populateResults();
		},
    _create: function () {
      this.timeline = Timeline.create($(this.domID), this.bandInfos);
      this.timeline.addCustomMethods();
    },
    init: function (first_init) {
      //first_init parameter:
      //true, include default search for first timeline init, and false vice versa
      this._create();
      this._handleWindowResize();
      this._handleBandScrolling();
      if (first_init) {
        this.assignObject();
        this.searchEvents();
      }
    },
    assignObject: function () {
      that.timeline = this;
    },
    onSearching: function () {
      this.timeline.showLoadingMessage();
    },
    hideLoading: function () {
      this.timeline.hideLoadingMessage();
    },
    showError: function () {
      this.hideLoading();
      //TODO:
    },
		onSearchSuccess: function(results) {
			this.hideLoading();
			this.pushRawEvents(results);
		},
		// Update events titles & show loading html
		eventsLoading: function(d) {
			// Is this the correct way to create a date object from string?
			console.log("loading events & artifacts for: " + d)
			this._updateTitles(d);
			that.artifactSection.showLoading();
			that.eventSection.showLoading();
		},
    showBubble: function (elements) {},
    searchEvents: function (params) {
      //var params = {startDate: this.startDate, endDate: this.endDate, options: this.options}
      var p = Object.extend({
				// Make sure entire months are searched since we cache results by month
        startDate: this.currentDate.stepMonth('down').startingMonth(),
        endDate: this.currentDate.stepMonth('up').endingMonth(),
        options: this.options
      }, params);
			
			// Don't repeat searches for same dates
			if (this.searchCache.hasDates(p.startDate, p.endDate)) {
				this._loadCached();
			} else {
				// Add dates to cache so we don't repeat ajax call
				this.searchCache.addDates(p.startDate, p.endDate);
				// Start Ajax search process - callbacks will handle response
      	new ETLSearch(this, p);
			}
    },
    pushRawEvents: function (events) {
      this.unprocessedEvents = events;
      this.rawEvents.pushEvents(this.unprocessedEvents);
      this.populate();
    },
    populate: function () {
      this._setupEvents();
      this._setupBands(this);
      this.init(false);
    }
  });

  var draw = function () {
    that.monthSelector = new ETLMonthSelector(options.month_selector_id);
    that.artifactSection = new ETLArtifactSection(options.artifact_section_id);
    window._eventSection = that.eventSection = new ETLEventSection(options.events_section_id);
    that.base = new ETLBase(options.timeline_section_id, options.timeline);
  }

  // Set public methods now
  me.draw = draw;
  me.api = api;
	
  // Return 'class' object with only public methods exposed.
  return me;
};
