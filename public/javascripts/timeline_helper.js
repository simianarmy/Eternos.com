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
// Compares date to other date & returns true iff year & month are the same
Date.prototype.equalsYearMonth = function(other) {
	return (this.getYear() === other.getYear()) && (this.getFullMonth() === other.getFullMonth());
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
// Fisher-Yates randomization
Array.prototype.randomize = function() {
	var i = this.length;
	var j, tempi, tempj;
	
	if ( i === 0 ) return false;
	while ( --i ) {
	     j = Math.floor( Math.random() * ( i + 1 ) );
	     tempi = this[i];
	     tempj = this[j];
	     this[i] = tempj;
	     this[j] = tempi;
	 }
	return this;
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
String.prototype.toDate = function() {
	return mysqlDateToDate(this);
}

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

  var ETLUtil = function() {
		return {
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
		}
  };
	that.utils = ETLUtil();
	
  //Eternos Timeline Date
  var ETLDate = Class.create({
    initialize: function (date, format) {
      this.inDate = date;
      this.inFormat = format || 'natural';
      this.getOutDate();
    },
    getOutDate: function () {
      if (this.inFormat == 'natural') {
        this.outDate = this.inDate.getFullYear() + '-' + this.inDate.getMonth() + 1 + '-' + this.inDate.getDate();
      } else if (this.inFormat == 'gregorian') {
        this.outDate = Timeline.DateTime.parseGregorianDateTime(this.inDate.substr(0, 4));
      } else if (typeof this.inDate === 'string') {
        this.outDate = this.inDate.toDate();
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

      this._populate();
    },
    _initContent: function () {
      this.activeMonth = this.activeDate.getMonthName();
      this.activeYear = this.activeDate.getFullYear();
    },
    _write: function () {
      this.parent.innerHTML = this.template.evaluate({
        month: this.activeMonth,
        year: this.activeYear
      });
    },
		_populate: function () {
      this._initContent();
      this._write();
      this.enableClick();
    },
    disableClick: function () {
		},
    enableClick: function () {
      Event.observe($('month_selector_down'), 'click', function (event) {
        that.monthSelector.stepMonth('down');
        event.stop();
      });
      Event.observe($('month_selector_up'), 'click', function (event) {
        that.monthSelector.stepMonth('up');
        event.stop();
      });
    },
		setDate: function(date) {
			this.activeDate = date;
		},
		update: function(date) {
			if (date) {
				this.setDate(date);
			}
			this._populate();
		},
    stepMonth: function (param) {
      this.activeDate.stepMonth(param);
      this.disableClick();
      this._populate();
      var params = {
        startDate: this.activeDate.startingMonth(),
        endDate: this.activeDate.endingMonth(),
        options: that.timeline.options
      }
      // Better place for this?
			that.timeline.scrollTo(this.activeDate);
      that.timeline.eventsLoading(this.activeDate);
      that.timeline.searchEvents(params);
    }
  });

  //Eternos Timeline Artifact Section
  var ETLArtifactSection = Class.create({
    initialize: function (domID) {
			// Set this to true|false
			this.doRandomize = false;
			
      this.parent = $(domID);
      this.numShowed = 18;
      this.timeOut = 3;
      this.title = "Artifacts";
      this.template = that.templates.artifactTemplates.artifacts();
      this.loadingTemplate = that.templates.loadingTemplate();
      this.boxTemplate = that.templates.artifactTemplates.artifactBox();
      this.blankImg = this.items = this.currentItems = new Array();
			
      this.showLoading();
    },
		// Returns collection of artifacts for the given date
		// Skip any items that don't have thumbnail or don't fall on target month
		_itemsInDate: function(date) {
			var targetDate = date.startingMonth();
			
			this.currentItems = this.items.findAll(function (i) {
        return (i !== undefined) && (i.attributes.thumbnail_url !== undefined) && (mysqlDateToDate(i.start_date).startingMonth() === targetDate);
      });
			return this.currentItems;
		},
    _itemsToS: function (activeDate) {
      var ul_class;
			var realthis = this;
      var s = '';

      console.log("Displaying artifacts for: " + activeDate);

			$A(this._itemsInDate(activeDate).randomize()).each(function (item, i) {
        ul_class = (i >= realthis.numShowed) ? "class=\"hidden-artifact-item\" style=\"display:none\"" : "class=\"visible-artifact-item\"";
        s += realthis.boxTemplate.evaluate({
					id: item.attributes.id,
          num: i,
          style: ul_class,
          url: item.attributes.url,
          thumbnail_url: item.attributes.thumbnail_url,
					title: item.attributes.title,
					caption: item.attributes.description
        });
      });
			return s;
    },
    _write: function (content) {
			var c = content || '';
      if (c === '' || this.items.length < 1) {
        c = that.utils.blankArtifactImg;
      }
      this.parent.innerHTML = this.template.evaluate({
        title: this.title,
        artifacts: c
      });
			//that.templates.artifactTemplates.setClickHandlers(this.currentItems);
    },
    randomize: function () {
			var i, j, tmp, tmp_title;
      var v = $$('li.visible-artifact-item');
      var h = $$('li.hidden-artifact-item');
			if (v.length === 0 || h.length === 0) { return; }
			
			if (this.doRandomize) {
				new PeriodicalExecuter(function (pe) {
					if (v.length > 0 && h.length > 0) {
						i = Math.floor(Math.random() * v.length);
						j = Math.floor(Math.random() * h.length);
						tmp = v[i]; // <a><img>...</a>
						tmp_title = v[i].down().title;
						
						v[i].pulsate({
							pulses: 1,
							duration: 1.5
						});
						// TODO: Fix me
						// This is fed up - title attibutes get lost, and we start seeing 
						// a lot of duplicates in artifacts
						console.log("Swapping artifact with html: " + h[j].innerHTML);
						v[i].update(h[j].innerHTML);
						if (h[j].down().title !== '') { // correct some weirdness
							console.log("setting title attribute: " + h[j].down().title);
							v[i].down().writeAttribute({title: h[j].down().title});
						}
						console.log("Swapping artifact with html: " + tmp.innerHTML);
						h[j].update(tmp.innerHTML);
						//console.log("setting title attribute: " + tmp_title);
						//h[j].down().writeAttribute({title: tmp_title});
					}
				}.bind(this), this.timeOut);
			}
    },
    addItem: function (item) {
      this.items.push(item);
    },
    addItems: function (items) {
			this.items.concat(items);
    },
    populate: function (activeDate) {      
      this._write(this._itemsToS(activeDate));
			this.randomize();
    },
    showLoading: function () {
      this._write(this.loadingTemplate.evaluate({
        type: " Artifacts"
      }));
			load_busy(this.parent);
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
      this.loading = that.templates.loadingTemplate();
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
      this.populate(this.loading.evaluate({
        type: " Events"
    	}));
			load_busy(this.parent);
    },
    updateTitle: function (title) {
      this.title = title;
      this._write();
    }
  });

  //Eternos Timeline Event Item(s)
  var ETLEventItems = Class.create({
    initialize: function (items) {
      this.items = items;
      this.first = s = ETEvent.createSource(items[0]);
			this.id = s.attributes.id;
      this.type = s.type;
      this.start_date = s.start_date;
      this.end_date = s.end_date;
      this.attributes = s.attributes;
      this.num = items.length;
      this.items = items;
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
        return this._getArtifactItemHtml();
      } else {
        return this._getInlineItemHtml();
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
				list_item_id: this.id,
        title: this.title,
        link_url: this._getLinkUrl(this.first),
        link_rel: this._getLinkRel(),
        hidden_items: other_items,
        tt_content: this._getTooltipContents()
      });
    },
    _getInlineItemHtml: function () {
      return this.itemWithTooltipTemplate.evaluate({
				list_item_id: this.id,
        title: this.title,
        link_url: this._getLinkUrl(this.first),
        link_rel: this._getLinkRel(),
        tt_content: this._getTooltipContents()
        //inline_content: this._getInlineContents()
      })
    },
    _getTooltipContents: function () {
      var html = '';
      this.items.each(function (item) {
        html += this.tooltipItemTemplate.evaluate({
          content: item.getPreviewHtml()
        });
      },
      this);
      return html;
    },
    _getInlineContents: function () {
      return this.inlineEventsTemplate.evaluate({
        id: this.first.attributes.id,
        content: 'TODO'
      });
    },
    populate: function () {
      this._setTitle();
      return this._setHtml();
    }
  });

  //Eternos Timeline Event Source (Timeline.DefaultEventSource.Event)
  // FIXME: Duplicates ETLEventSource class functionality
  var ETLTimelineEvent = Class.create({
    initialize: function (event) {
			var icon_s;
      var date = new ETLDate(event.start_date, 'rev').outDate;
      this.start_date = this.earliest = date;
			this.end_date = this.latest = event.end_date;
      this.title = event.title;
      this.type = event.type;
			this.id = event.attributes.id;
			
      icon_s = ETEvent.getSourceIcon(this.type)
      this.icon = that.utils.assetUrl + that.utils.imgUrl + icon_s + that.utils.iconPostfix;
 
      this.event = new Timeline.DefaultEventSource.Event({
        start: this.start_date,
        end: this.end_date,
        latestStart: this.latest,
        earliestEnd: this.earliest,
				durationEvent: (this.start_date != this.end_date),
        instant: true,
        icon: this.icon,
				classname: 'tl_event',
				// Trick to associate an event's timeline DIV with its associated tooltip content
				// tooltip container id stored in title attribute
				caption: this.id,
				// Supposed to be link for bubble title text, but using it for click handler target
				eventID: this.id
				// for all possible attributes, see http://code.google.com/p/simile-widgets/wiki/Timeline_EventSources				
      });
			console.log("Added timeline event with tooltip id " + this.id);
    }
  });

  //Eternos Timeline Event Collection
  var ETLEventCollection = Class.create({
    initialize: function () {
      this.sources 				= [];
			this.latestSources	= [];
      this.dates 					= [];
      this.rawItems 			= [];
      this.items 					= [];
      this.groupTemplate 	= that.templates.eventListTemplates.eventGroup();
    },
    // Add event source to collection keyed by event date
    addSource: function (s) {
      var source = ETEvent.createSource(s);
      var day = source.eventDateString();

      this.sources.push(source);
			this.latestSources.push(source);
			
			this._groupSourceByDate(this.rawItems, this.dates, source);
    },
    populate: function (targetDate) {
      var td = targetDate || that.monthSelector.activeDate;
      var current_items;
			var items_html;
			var html = '';
      var event;
      var activeDates;
      console.log("Populating with events from " + td.getFullMonth());

      // Only use events that fall in the active date month
      activeDates = this.dates.select(function (d) {
				return td.equalsYearMonth(d.toDate());
      });
      activeDates.sort(orderDatesDescending).each(function (d) {
        items_html = '';
        current_items = this._groupItemsByType(this.rawItems[d]);

        current_items.each(function (group, index) {
          event = new ETLEventItems(group);
          this.items.push(event);
          items_html += event.populate();
        }.bind(this));

        html += this.groupTemplate.evaluate({
          date: this._eventDate(d),
          body: items_html
        });
      }.bind(this));

      return html;
    },
		clearLatest: function () {
			this.latestSources = [];
		},
		// return grouped event sources 
		getLatestEventGroups: function() {
			var grouped = new Array();
			var dates 	= [];
			var results	= [];
			
			this.latestSources.each(function(s) {
				grouped = this._groupSourceByDate(grouped, dates, s);
			}.bind(this));
			dates.each(function(d) {
				this._groupItemsByType(grouped[d]).each(function(items) {
					results.push(new ETLEventItems(items));
				});
			}.bind(this));
			return results;
		},
		_groupSourceByDate: function (res, dates, source) {
			var day = source.eventDateString();
			
			if (!dates.include(day)) {
				res[day] = new Array(source);
				dates.push(day);
			} else {
				res[day].push(source);
			}
			return res;
		},
    // Group event items by type in arrays
    _groupItemsByType: function (items) {
      var types = [];
      var results = new Array();

      for (var i = 0; i < items.length; i++) {
        idx = types.indexOf(items[i].type);
        if (idx !== -1) {
          results[idx].push(items[i]);
        } else {
          types.push(items[i].type);
          results[types.length - 1] = new Array(items[i]);
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
		// Takes JSON object containing timeline search results
		// Parses & adds results to internal collections
    pushEvents: function (events) {
      this._mergeEvents(events.evalJSON());
      this._populate();
    },
		// Returns latest parsed results objects array.
		getEventGroups: function() {
			return this.eventItems.getLatestEventGroups();
		},
    doParsing: function () {
			this.eventItems.clearLatest();
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
      that.eventSection.populate(this.eventItems.populate(targetDate));
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

  // Produces a search cache object that stores/retrieves search dates
  // by year-month. 
  // For use by ETLBase
  var searchCache = function () {
    var searched = [];

    return {
      hashDate: function (d) {
        return d.getFullYear() + d.getFullMonth();
      },
      addDates: function (sd, ed) {
        var stepDate, endDate;
        if (ed < sd || ed === undefined) {
          return;
        }

        stepDate = new ETLDate(sd, 's').outDate;
        endDate = new ETLDate(ed, 's').outDate;
        do {
          console.log("Adding " + stepDate + " to search date cache");
          searched[this.hashDate(stepDate)] = true;
          stepDate.stepMonth('up');
        } while (stepDate <= endDate);
      },
      hasDates: function (sd, ed) {
        var stepDate, endDate;
        if (ed < sd || ed === undefined) {
          return false;
        }

        stepDate = new ETLDate(sd, 's').outDate;
        endDate = new ETLDate(ed, 's').outDate;
        console.log("Checking search cache for dates " + stepDate + " => " + endDate);

        var found = false;
        do {
          if (searched[this.hashDate(stepDate)]) {
            found = true;
            break;
          }
          stepDate.stepMonth('up');
        } while (stepDate <= endDate);

        return found;
      }
    };
  };

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
      
      var date = new Date();

      this.domID = domID;
			this.resizeTimerID = null;
      this.params = params;
      this.memberID = params.memberID;
      this.startDate = params.startDate || new ETLDate(date);
      this.endDate = params.endDate || new ETLDate(date);
      this.options = params.options;
      this.rawEvents = new ETLEventParser(that.utils.emptyResponse);
			
      // Timeline instance vars
      this.timeline = null;
      this.memberAge = 0;
      this.firstBandPixels = 0;
      this.theme = null;
			this.eventSource = new Timeline.DefaultEventSource();
			
      this.currentDate = null;
      this.tlMinDate = null;
      this.tlMaxDate = null;
      this.centerDate = null;
      this.searchCache = searchCache();

      this.init(true);
    },
    _getMemberAge: function () {
      this.memberAge = (new Date(parseInt(this.endDate), 01, 01)).getFullYear() - (new Date(parseInt(this.startDate), 01, 01)).getFullYear();
      this.firstBandPixels = that.utils.tlEffectiveWidth / (this.memberAge / 10);
    },
    _setupTheme: function () {
      this.theme = Timeline.ClassicTheme.create();
    },
    _setupBands: function () {
      //var date = new Date();
      this.bandInfos = [Timeline.createBandInfo({
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
        eventSource: this.eventSource,
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

      var start_date = new ETLDate(this.startDate, 'gregorian').outDate;
      var end_date = new ETLDate(this.endDate, 'gregorian').outDate;

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
			var t = this;
      Event.observe(window, 'resize', function() {
				if (t.resizeTimerID == null) {
					t.resizeTimerID = window.setTimeout(function() {
						t.resizeTimerID = null;
						t.timeline.layout();
					}, 500);
      	}
			});
    },
    _handleBandScrolling: function () {
      var tlMinDate = this.tlMinDate;
      var tlMaxDate = this.tlMaxDate;
			var currCenterDate;
			
      this.timeline.getBand(1).addOnScrollListener(function (band) {
        //console.log("MAX timeline...band: "+tlMaxDate.monthRange(0,'')+"..."+band.getMaxVisibleDate().monthRange(0,''));
        //console.log("MIN timeline...band: "+tlMinDate.monthRange(0,'')+"..."+band.getMinVisibleDate().monthRange(0,''));
        that.timeline.timeline.hideBackupMessage();
				
				currCenterDate = that.timeline.centerDate;
				that.timeline._setCenterDate(band.getCenterVisibleDate());
				
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
        } else if (!currCenterDate.equalsYearMonth(band.getCenterVisibleDate())) {
					console.log("Timeline scrolled to new month: " + that.timeline.centerDate);
					that.timeline.updateEvents();
        } else {
					// Recreate tooltips on every scroll, timleline loses them somehow if you scroll too far
					that.timeline.redraw();
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
		_setCenterDate: function (date) {
			this.currentDate = this.centerDate = date;
			that.monthSelector.setDate(date);
		},
    _getTitleFromDate: function (date, type) {
      return (type + " from " + date.getMonthName() + " " + date.getFullYear())
    },
    _updateTitles: function (d) {
      that.artifactSection.updateTitle(this._getTitleFromDate(d, "Artifacts"));
      that.eventSection.updateTitle(this._getTitleFromDate(d, "Events"));
			that.monthSelector.update(d);
    },
    _loadCached: function () {
      this.rawEvents.populateResults(this.centerDate);
			this.redraw();
    },
    _create: function () {
			var li;
			var a;
			
      this.timeline = Timeline.create($(this.domID), this.bandInfos);
      this.timeline.addCustomMethods();

			// Setup click handler for timeline events
			Timeline.OriginalEventPainter.prototype._showBubble = function(x, y, evt) {
				console.log("Clicked on event");
				console.dir(evt);
				// Should fire click() on matching event list target link
				if ((li = ETemplates.event_list_item(evt.getEventID())) !== undefined) {
					if ((a = li.down().down('a.event_list_inline_item')) !== undefined) {
						Lightview.show({
						 	href: a.href,
						  rel: a.rel,
							options: {
								fullscreen: true
							}
						});
					}
			 	}
			}
    },
		// Add search results to timeline event source
		_addEvents: function (events) {
			var tooltip_el;
			
			events.each(function(event) {
				this.eventSource.add((new ETLTimelineEvent(event)).event);
      }.bind(this));
			// Force timeline to redraw so that events show up
			this.eventSource._listeners.invoke('onAddMany');
			this.redraw();
    },
		// Required due to bug in timeline that kills tooltips after they go out of bounds
		redraw: function() {
			console.log("[re]creating timeline tooltips")
			that.templates.eventListTemplates.createTimelineTooltips();
		},
    init: function () {
      SimileAjax.History.enabled = false;
      this._getMemberAge();
      this._setReqDates();
      this._setupTheme();
      this._setupBands();
      this._create();
      this._handleWindowResize();
      this._handleBandScrolling();
 
      this.assignObject();
      this.searchEvents();
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
    onSearchSuccess: function (results) {
      this.hideLoading();
			// Add to timeline, events & artifacts
      this.parseSearchResults(results);
    },
    // Update events titles & show loading html
    eventsLoading: function (d) {
      console.log("loading events & artifacts for: " + d)
      this._updateTitles(d);
      that.artifactSection.showLoading();
      that.eventSection.showLoading();
    },
		updateEvents: function() {
			this.eventsLoading(this.centerDate);
			this.searchEvents();
		},
    showBubble: function (elements) {},
    searchEvents: function (params) {
      //var params = {startDate: this.startDate, endDate: this.endDate, options: this.options}
      var p = Object.extend({
        // Make sure entire months are searched since we cache results by month
        startDate: this.currentDate.stepMonth('down').startingMonth(),
        endDate: this.currentDate.stepMonth('up').endingMonth(),
        options: this.options
      },
      params);

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
    parseSearchResults: function (results) {
			var latestDate = null;
			var groupedEvents;
			
			// Parse json results & save
      this.rawEvents.pushEvents(results);
			// Add to timeline event sources
			groupedEvents = this.rawEvents.getEventGroups();
			if (groupedEvents.length > 0) {
				this._addEvents(groupedEvents);
				// Center timeline on latest new event
				groupedEvents.pluck('start_date').each(function(d) {
					if (latestDate == null || d > latestDate) {
						latestDate = d;
					}
				});
				this.scrollTo(latestDate.toDate());
			}
    },
		scrollTo: function(date) {
			this.timeline.getBand(1).setCenterVisibleDate(date);
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