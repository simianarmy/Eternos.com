// $Id$
//
// Timeline javascript module
// required Date' prototypes
Date.prototype.numDays = function () {
	return this.getDaysInMonth(this.getFullYear(), this.getMonth());
}
Date.prototype.getFullMonth = function () {
  var m = this.getMonth() + 1 + "";
  return (m.length < 2) ? "0" + m : m;
}
// Returns YYYY-MM-DD string with day set to beginning of the month
Date.prototype.startingMonth = function () {
  return this.getFullYear() + "-" + this.getFullMonth() + "-01";
}
// Returns YYYY-MM-DD string with day set to end of the month
Date.prototype.endingMonth = function () {
  return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.numDays();
}
// Return YYYY-MM-DD string representation of the date
Date.prototype.toMysqlDateString = function () {
	return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.getDate();
}
Date.prototype.getMonthName = function () {
  var nm = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  var nu = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  return nm[this.getMonth()];
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
Date.prototype.equalsDay = function(other) {
	return this.clone().clearTime().equals(other.clone().clearTime());
}
// isMonthAfter
// Returns true iff  date's month is > passed dated
Date.prototype.isMonthAfter = function(d) {
	return this.clone().moveToFirstDayOfMonth().clearTime() > d.clone().moveToFirstDayOfMonth().clearTime();
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
//function parses mysql datetime string and returns javascript Date object
//input has to be in this format: 2007-06-05
var mysqlDateToDate = function (date) {
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
String.prototype.toMysqlDateFormat = function() {
	return this.replace(MysqlDateRE, "$1 $2 $3").split(' ').join('-');
}
String.prototype.toISODate = function() {
	var dt = Date.parseExact(this, "yyyy-MM-ddTHH:mm:ssZ");
	if (!dt) {
		dt = this.toDate();
	}
	return dt;
}

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
      this.outDate = this.inDate.toISODate();
    }
		return this.outDate;
  }
});

function getWinHeight() {
	return win_dimension()[1] * 0.8;
};

// UI action event handlers
var ETUI = function() {
	// Private funcs
	// fetch tooltip contents for an element
	function getTooltip(id) {
		return tooltipGenerator.generate(id);
	};
	// Create the Tooltip object on the element identified by ID
	function createTooltip(element, id, tipOptions) {
		var tipContents;
				
		if ((tipContents = getTooltip(id)) == null) { return false; }

		tipOptions.title = tipContents.title;
		// Trick to determine tooltip width (for text or images)
		if (!ETEvent.isMedia(tipContents.type)) {
			tipOptions.width = 'auto';
		}
		new Tip(element, tipContents.body, Object.extend(ETemplates.DefaultTooltipOptions, tipOptions));
		element.prototip.show();

		return true;
	};
	return {
		createEventListItemObservers: function() {
			$$('a.event_list_inline_item').each(function(el) {
				el.observe('mouseover', function(e) {
					el.fire('event_list_item:hover');
				});
			});
		},
		onEventListItemMouseOver: function(element) {
			var tipContents, parts, ttopts;
			
			if (element.prototip != null) { 
				console.log("event item already has prototip attribute");
				return true;
			}
			// get the event id from the container div id
			parts = element.id.split(':');
			if (createTooltip(element, parts[1], ETemplates.eventTooltipOptions)) {
				// Add observer to hide it on click
				element.observe('click', function(e) {
					element.prototip.hide();
					return true;
				});
			}
		},
		// Destroy tooltips and observers in order to prevent memory leaks
		onEventSectionLoading: function() {
			$$('a.event_list_inline_item').each(function(el) {
				if (el.prototip) {
					el.prototip.remove();
				}
				el.stopObserving();
			});
		},
		createTimelineEventIconObservers: function() {
			$$('.timeline-event-icon').each(function(el) {
				if (el.observingMouseOver === undefined) {
					el.observe('mouseover', function(e) {
						el.fire('event_icon:hover');
					});
					el.observingMouseOver = true;
				} else {
					console.log("timeline icon mouseover observer already created");
				}
			});
		},
		onEventIconMouseOver: function(element) {
			var tipContents;
			
			if (element.prototip != null) { 
				console.log("timeline icon already has prototip attribute");
				return true;
			} 
			console.log('creating tooltip on ' + element.id);
			ev = Timeline.EventUtils.decodeEventElID(element.id).evt;
			
			createTooltip(element, ev.getEventID(), ETemplates.timelineTooltipOptions);
		},
		createSearchClickHandlers: function(timeline) {
			// Setup previous, future events link click handlers when there are no events to display
			if (el = $('prev_event_search')) {
				el.observe('click', function(e) {
					timeline.searchClosestEvents('past');
				});
			}
			if (el = $('next_event_search')) {
				el.observe('click', function(e) {
					timeline.searchClosestEvents('future');
				});
			}
		}
	}
}();

// Eternos Timeline Event Items html generator
var ETLEventItems = Class.create({
  initialize: function (items, opts) {
		this.MaxMediaTooltipItems	= 5;
		this.MaxTooltipItems = 10;
		
		// Sort items by datetime
		// OPTIMIZE! Too slow!
		items.sort(function(a, b) {
			// Access attributes manually for speed
			return a.getEventDateObj().compareTo(b.getEventDateObj());
		});
    this.items = items;
		this.options = opts || {};
    this.first = items[0];
		this.id = this.first.getID();
    this.type = this.first.type;
    this.start_date = this.first.getEventDate();
    this.end_date = this.first.getEventEndDate();
    
    this.num = items.length;
    this.items = items;
		this.title = this.first.getDisplayTitle(this.num);
		this.icon = this.first.getIcon();
		
    this.hiddenItemTemplate 			= ETemplates.eventListTemplates.hiddenItem;
    this.itemWithTooltipTemplate 	= ETemplates.eventListTemplates.eventItemWithTooltip;
    this.tooltipItemTemplate 			= ETemplates.eventListTemplates.eventItemTooltipItem;
    this.inlineEventsTemplate 		= ETemplates.eventListTemplates.inlineEvents;
    this.tooltipTitleTemplate 		= ETemplates.eventListTemplates.tooltipTitle;
		this.eventDetailsLinkTemplate = ETemplates.eventListTemplates.detailsLink;
  },
	_getItemIDs: function() {
		return this.items.collect(function(i) {
			return i.attributes.id;
		});
	},
  _setHtml: function () {
    // Need to format the link so all content will be displayed
    if (this.first.isArtifact()) {
      return this._getArtifactItemHtml();
    } else {
      return this._getInlineItemHtml();
    }
  },
	// Popup link code for all items
  _getLinkUrl: function () {
		var item = this.first;
    if (item.isArtifact()) {
      this.detailsUrl = item.getURL();
    } else { 
      this.detailsUrl = this.eventDetailsLinkTemplate.evaluate({
				memberId: this.options.memberID,
				eventType: this.type,
				eventIds: encodeURIComponent(this._getItemIDs())
			});
    }
		return this.detailsUrl;
  },
	// Popup link code for individual item
	_getItemDetailsUrl: function(item) {
		if (item.isArtifact()) {
			return item.getURL();
		} else {
			return this.eventDetailsLinkTemplate.evaluate({
				memberId: this.options.memberID,
				eventType: item.type,
				eventIds: item.getID()});
		}
	},
  // Determine 'rel' attribute for Lightview link html
  _getLinkRel: function () {
    if (this.first.isArtifact()) {
      // Lightview auto-detects content so just need to know if gallery or not
      this.detailsLinkRel = (this.num > 1) ? 'gallery[' + this.first.getID() + ']' : '';
    } else {
      this.detailsLinkRel = 'iframe';
    }
		return this.detailsLinkRel;
  },
  _getArtifactItemHtml: function () {
	/*
    var other_items = '';
    if (this.num > 1) {
      for (var i = 1; i < this.num; i++) {
        other_items += this.hiddenItemTemplate.evaluate({
          link_url: this._getLinkUrl(),
          link_rel: this._getLinkRel()
        });
      }
    }
*/
    return this.itemWithTooltipTemplate.evaluate({
			list_item_id: this.id,
      b_title: this.title,
			title: this.tooltipTitleTemplate.evaluate({
				icon: this.icon, title: this.title}),
      link_url: this._getLinkUrl(),
      link_rel: this._getLinkRel()
/*
      hidden_items: other_items,
      tt_content: this.getTooltipContents()
*/
    });
  },
  _getInlineItemHtml: function () {
		return ETemplates.eventListTemplates.eventGroupItem.evaluate({
			list_item_id: this.id,
      title: this.getTooltipTitle(),
      link_url: this._getLinkUrl(),
      link_rel: this._getLinkRel(),
			details_win_height: getWinHeight()
		});
	/*
    return this.itemWithTooltipTemplate.evaluate({
			list_item_id: this.id,
      title: this._getTooltipTitle(),
      link_url: this._getLinkUrl(),
      link_rel: this._getLinkRel(),
			details_win_height: getWinHeight(),
      tt_content: this._getTooltipContents()
    });
*/
  },
	_getInlineContents: function () {
    return this.inlineEventsTemplate.evaluate({
      id: this.first.getID(),
      content: 'TODO'
    });
  },
	getTooltipTitle: function() {
		return this.tooltipTitleTemplate.evaluate({
			icon: this.icon, title: this.title});
	},
	// Generates tooltip html for all types.  Used by both event list & timeline icons
  getTooltipContents: function () {
		var i, count, item;
		
		if (this.num == 0) {
			return '';
		}
		if (this.first.isMedia()) {
			count = Math.min(this.MaxMediaTooltipItems, this.num);
		} else {
			count = Math.min(this.MaxTooltipItems, this.num);
		}
    this.tooltipHtml = '<div class="tooltip_container">';
		for (i=0; i<count; i++) {
			item = this.items[i];
      this.tooltipHtml += this.tooltipItemTemplate.evaluate({
				event_details_link: this._getItemDetailsUrl(item),
				details_win_height: getWinHeight(),
        content: item.getPreviewHtml()
      });
    }
		// Add link to view all
		if (count < this.num) {
			this.tooltipHtml += '<br/><a href="#">View All</a>';
		}
		this.tooltipHtml += '</div>';
    return this.tooltipHtml;
  },
  populate: function () {
    return this._setHtml();
  }
});

// Helper module to allow onmouseover-time creation of tooltip html
// Maps event id => ETLEventItems object

var tooltipGenerator = function() {
	var eventItemsMap = {};
	
	// Map id to ETLEventItems class object
	function add(eventId, evItemsObj) {
		eventItemsMap[eventId] = evItemsObj;
	};
	function generate(eventId) {
		var itemsObj, results = {};
		if (itemsObj = eventItemsMap[eventId]) {
			results = {
				title: itemsObj.getTooltipTitle(),
				body: itemsObj.getTooltipContents(),
				type: itemsObj.type
			};
		}
		return results;
	};
	return {
		add: add,
		generate: generate
	}
}();


//Eternos Timeline Event Source (Timeline.DefaultEventSource.Event)

var ETLTimelineEvent = Class.create({
  initialize: function (events) {
		var icon_s;
    var date = events.start_date.toISODate();
    this.start_date = this.earliest = date;
		this.end_date = this.latest = events.end_date;
    this.title = events.title;
    this.type = events.type;
		this.id = events.id,
		this.num = events.num;
		
    icon_s = events.icon;
    this.icon = ETemplates.utils.assetUrl + ETemplates.utils.imgUrl + icon_s + ETemplates.utils.iconPostfix;

    this.event = new Timeline.DefaultEventSource.Event({
      start: this.start_date,
      end: this.end_date,
      latestStart: this.latest,
      earliestEnd: this.earliest,
			durationEvent: (this.start_date != this.end_date),
      instant: true,
      icon: this.icon,
			classname: 'tl_event',
			caption: 'Click to view details',
			eventID: this.id
			// for all possible attributes, see http://code.google.com/p/simile-widgets/wiki/Timeline_EventSources
    });
		// Set icon size for event using frequency = size trick
		// Used here:
		 // Timeline.OriginalEventPainter /public/javascripts/timeline/timeline_js/scripts/original-painter.js:473
		this.event.iconSize = ETemplates.getIconSize(this.num);
		//console.log("Added timeline event with tooltip id " + this.id);
  }
});

// ETimeline 'class'
var ETimeline = function (opts) {
  // Private instance of this object for private methods to use
  var that = this;
  var me = new Object();
  var options = Object.extend(opts, {});
  var api = '0.1';

  // Private instances & functions
  
  that.options = options;
  that.monthSelector = null;
	that.utils = ETemplates.utils;

  //Eternos Timeline Selector
  var ETLMonthSelector = Class.create({
    initialize: function (domID) {
      this.parent 					= $(domID);
      this.activeDate 			= new Date();
      this.advanceMonths 		= new Array();
      this.pastMonths 			= new Array();
      this.template 				= ETemplates.dateSelectorTemplate;
			this.monthUpDisabled	= false;
			this.yearUpDisabled		= false;
			this.parent.innerHTML = this.template.evaluate({
        month: this.activeDate.getMonthName(),
        year: this.activeDate.getFullYear()
      });
			this._enableNavButtons();
    },
    _populate: function () {
      $('display_month').innerHTML = this.activeDate.getMonthName();
			$('display_year').innerHTML = this.activeDate.getFullYear();
			
			if (!this._canClickNextMonth()) {
				this._disableClick('month_selector_up');
				this.monthUpDisabled = true;
			} else if (this.monthUpDisabled) {
				this._enableClick('month_selector_up');
				this.monthUpDisabled = false;
			}
			if (!this._canClickNextYear()) {
				this._disableClick('year_selector_up');
				this.yearUpDisabled = true;
			} else if (this.yearUpDisabled) {
				this._enableClick('year_selector_up');
				this.yearUpDisabled = false;
			}
    },
		_canClickNextMonth: function() {
			return this.activeDate.clone().addMonths(1).moveToFirstDayOfMonth().compareTo(Date.today()) !== 1;
		},
		_canClickNextYear: function() {
			return this.activeDate.clone().addYears(1).moveToFirstDayOfMonth().compareTo(Date.today()) !== 1;
		},
    _disableClick: function (id) {
			new Effect.Opacity(id, { from: 1.0, to: 0.4 })
		},
		_enableClick: function (id) {
			new Effect.Opacity(id, { from: 0.4, to: 1.0 })
		},
    _enableNavButtons: function () {
      $('month_selector_down').observe('click', function (event) {
	      event.stop();
        this.stepDate(this.activeDate.clone().addMonths(-1));
      }.bind(this));
			$('year_selector_down').observe('click', function (event) {
				event.stop();
				this.stepDate(this.activeDate.clone().addYears(-1));
			}.bind(this));
			$('month_selector_up').observe('click', function (event) {
				event.stop();
				if (this._canClickNextMonth()) {
        	this.stepDate(this.activeDate.clone().addMonths(1));
      	}
			}.bind(this)); 
			$('year_selector_up').observe('click', function (event) {
				event.stop();
				if (this._canClickNextYear()) {
					this.stepDate(this.activeDate.clone().addYears(1));
				}
			}.bind(this));
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
    stepDate: function (newDate) {
			if (newDate.isMonthAfter(Date.today())) {
				// Don't allow stepping into the future
				return;
			}
			console.log("Date selector stepping from " + this.activeDate + " to " + newDate);
			this.setDate(newDate);
			that.timeline.onNewDate(newDate);
    }
  });

  //Eternos Timeline Artifact Section
  var ETLArtifactSection = Class.create({
    initialize: function (domID) {
			this.MaxDisplayCount = 18;
			// Set this to true|false
			this.doRandomize = false;
			
      this.parent 		= $(domID);
      this.timeOut 		= 3;
      this.title 			= "Artifacts";
			this.items 			= [];
      this.template 	= ETemplates.artifactTemplates.artifacts;
      this.loadingTemplate = ETemplates.loadingTemplate;
      this.boxTemplate = ETemplates.artifactTemplates.artifactBox;
      this.blankImg = this.items = this.currentItems = new Array();
			
      this.showLoading();
    },
		// Returns collection of artifacts for the given date
		// Skip any items that don't have thumbnail or don't fall on target month
		_itemsInDate: function(date) {
			var targetDate = date.startingMonth();
			
			this.currentItems = this.items.findAll(function (i) {
        return (i !== undefined) && (i.attributes.thumbnail_url !== undefined) && (i.getEventDateObj().startingMonth() === targetDate);
      });
			return this.currentItems;
		},
    _itemsToS: function (activeDate) {
			var i, numDisplay;
      var s = '', ul_class;
			var item, artis = this._itemsInDate(activeDate).randomize();
			
      console.log("Displaying artifacts for: " + activeDate);

			numDisplay = Math.min(artis.length, this.MaxDisplayCount);
			for (i=0; i<numDisplay; i++) {
				item = artis[i];
				console.log("Adding artifact #" + i + ": type: " + item.type);
        
				ul_class = "class=\"visible-artifact-item\"";
        s += this.boxTemplate.evaluate({
					id: item.getID(),
          num: i,
          style: ul_class,
          url: item.getURL(),
          thumbnail_url: item.getThumbnailURL(),
					title: item.getTitle(),
					caption: item.getText()
        });
			}
			return s;
    },
    _write: function (content) {
			var c = content || '';
      if (c === '' || this.items.length < 1) {
        c = (div = $('artifact_info')) ? div.innertHTML : '';//that.utils.blankArtifactImg;
      }
      this.parent.innerHTML = this.template.evaluate({
        title: this.title,
        artifacts: c
      });
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
						// This is f'd up - title attibutes get lost, and we start seeing 
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
		//	load_busy(this.parent);
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
      this.loading = ETemplates.loadingTemplate;
      this.template = ETemplates.eventListTemplates.events;
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
      ETUI.createEventListItemObservers();
			ETUI.createSearchClickHandlers(that.timeline);
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
		//	load_busy(this.parent);
    },
    updateTitle: function (title) {
      this.title = title;
      this._write();
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
      this.groupTemplate 	= ETemplates.eventListTemplates.eventGroup;
			this.noEventsTemplate = ETemplates.eventListTemplates.noEvents;
    },
    // Add event source to collection keyed by event date
    addSource: function (source) {
      this.sources.push(source);
			this.latestSources.push(source);
			
			this._groupSourceByDate(this.rawItems, this.dates, source);
    },
    populate: function (targetDate) {
      var td = targetDate || that.monthSelector.activeDate;
      var currentItems;
			var itemsHtml;
			var html = '';
      var event;
      var activeDates;
			
      console.log("Populating with events from " + td);

      // Only use events that fall in the active date month
      activeDates = this.dates.select(function (d) {
				return td.equalsYearMonth(d.toDate());
      });
      activeDates.sort(orderDatesDescending).each(function (d, rowIndex) {
        itemsHtml = '';
        currentItems = this._groupItemsByType(this.rawItems[d]);

        currentItems.each(function (group, index) {
          event = new ETLEventItems(group, {memberID: that.memberID});
					tooltipGenerator.add(event.id, event);
          this.items.push(event);
          itemsHtml += event.populate();
        }.bind(this));

        html += this.groupTemplate.evaluate({
          date: this._eventDate(d),
					odd_or_even: ((rowIndex % 2) === 0 ? 'even' : 'odd'),
          body: itemsHtml
        });
      }.bind(this));

			if (html === '') {
				html = this.noEventsTemplate.evaluate();
			}
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
			var ev;
			
			this.latestSources.each(function(s) {
				grouped = this._groupSourceByDate(grouped, dates, s);
			}.bind(this));
			dates.each(function(d) {
				this._groupItemsByType(grouped[d]).each(function(items) {
					results.push(ev = new ETLEventItems(items, {memberID: that.memberID}));
					tooltipGenerator.add(ev.id, ev);
				});
			}.bind(this));
			return results;
		},
		// Search dates array for closest date to passed date, past or future
		getClosestDate: function(date, direction) {
			var dt = date.toMysqlDateString();
			var closest = null;
			
			this.dates.sort(); // sort dates ascending
			for (var i=0; i<this.dates.length; i++) {
				if (direction === 'past') {
					if (this.dates[i] <= dt) { 
						closest = this.dates[i];
					} else {
						break;
					}
				} else {
					if (this.dates[i] >= dt) {
						closest = this.dates[i];
						break;
					}
				}
			}
			if (closest) {
				alert('closest date = ' + closest);
				closest = closest.toDate();
			} 
			return closest;
		},
		_groupSourceByDate: function (res, dates, source) {
			var day = this._formatEventDate(source.getEventDate());
			
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
      var type, types = [];
      var results = new Array();

      for (var i = 0; i < items.length; i++) {
				type = items[i].getDisplayType();
        idx = types.indexOf(type);
        if (idx !== -1) {
          results[idx].push(items[i]);
        } else {
          types.push(type);
          results[types.length - 1] = new Array(items[i]);
        }
      }
      
      //--results.each(function(item){console.log(item.length)});
      return results;
    },
		// Returns event's date occurrence, as date string
		_formatEventDate: function(date) {
			if (typeof date === 'date') {
				return date.toMysqlDateString();
			} else if (typeof date === 'string') {
				return date.toMysqlDateFormat();
			}
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
    },
    _mergeEvents: function (events) {
      console.log("Merging events");
      //var merged = this.jsonEvents.results.concat(events.results);
      //this.jsonEvents.results = merged;
      this.jsonEvents = events;
			
			console.log("got " + events.resultCount + " results");
			//console.dir(this.jsonEvents);
    },
		// Takes JSON object containing timeline search results
		// Parses & adds results to internal collections
    addEvents: function (events) {
      this._mergeEvents(events.evalJSON());
			this._populate();
    },
		// Returns latest parsed results objects array.
		getEventGroups: function() {
			return this.eventItems.getLatestEventGroups();
		},
		// Returns nearest existing event date to date
		getClosestEventDate: function(date, past_or_future) {
			return this.eventItems.getClosestDate(date, past_or_future);
		},
    doParsing: function () {
			var event;
			
			this.eventItems.clearLatest();
      this.jsonEvents.results.each(function(res) {
				event = ETEvent.createSource(res);
        if (event.isArtifact()) {
					// Skip artifacts with missing source
					if (event.attributes.url == null) { return; }
          that.artifactSection.addItem(event);
        } else if (ETEvent.isArtifact(event.getDisplayType())) {
					// Skip image attachments (already included in artifacts)
					return;
				}
        this.eventItems.addSource(event);
      }.bind(this));
    },
    populateResults: function (date) {
      var targetDate = date || that.base.centerDate;

			// Make sure month selector is synched up
			that.monthSelector.setDate(targetDate);
      that.artifactSection.populate(targetDate);
      that.eventSection.populate(this.eventItems.populate(targetDate));
    }
  });

  //Eternos Timeline Search. init: timeline object and {startDate: 'sring date', endDate: 'string date', options: Object}
  var ETLSearch = Class.create({
    initialize: function (timeline, params) {
      var date = new Date();

      this.searchUrl = "/timeline/search/js";
      //this.startDate = '2008-01-01'; 
      //this.endDate = '2010-01-01'; 
      this.startDate = params.startDate || new ETLDate(date).getOutDate();
      this.endDate = params.endDate || new ETLDate(date).getOutDate();
      this.options = Object.toQueryString(params.options);
      this.complete = false;
      this.timeline = timeline;
			this.onComplete = params.onComplete;
			
      this._getFullSearchUrl();
      this._getJSON(this.fullSearchUrl);
    },
    _getFullSearchUrl: function () {
      this.fullSearchUrl = [this.searchUrl, that.memberID, this.startDate, this.endDate, this.options].join('/');
    },
    _getJSON: function (url) {
			var that = this;
      
      new Ajax.Request(url, {
        method: 'get',
        onComplete: function (transport) {
          var response = transport.responseText || "";
					that.onComplete.apply(that.timeline, [response]);
        },
        onFailure: function (err) {
					$('notice').innerHTML = 'Search error!'
					console.log(err.inspect);
          that.timeline.onSearchError();
        },
        onLoading: function () {
          that.timeline.onSearching();
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

        stepDate = new ETLDate(sd, 's').getOutDate();
        endDate = new ETLDate(ed, 's').getOutDate();
        do {
          console.log("Adding " + this.hashDate(stepDate) + " to search date cache");
          searched[this.hashDate(stepDate)] = true;
          stepDate.addMonths(1);
        } while (stepDate <= endDate);
      },
      hasDates: function (sd, ed) {
        var stepDate, endDate;
        if (ed < sd || ed === undefined) {
          return false;
        }

        stepDate = new ETLDate(sd, 's').getOutDate();
        endDate = new ETLDate(ed, 's').getOutDate();

        var found = false;
        do {
					console.log("Checking search cache for date " + this.hashDate(stepDate));
          if (searched[this.hashDate(stepDate)]) {
            found = true;
            break;
          }
          stepDate.addMonths(1);
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
	    var date = new Date();
      that.memberID = params.memberID;

      this.domID = domID;
			this.resizeTimerID = null;
      this.params = params;
      this.memberID = params.memberID;
      this.startDate = params.startDate;
      this.endDate = params.endDate;
			this.birthDate = params.startDate.toDate();
      this.options 	= params.options;
			this.searchInProgress	= this.seeking = false;
			this.disableSearch = false;
			this.inScrollTo = false;
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
      this.memberAge = this.endDate.toDate().getFullYear() - this.startDate.toDate().getFullYear();
      this.firstBandPixels = that.utils.tlEffectiveWidth / (this.memberAge / 10);
			console.log("Member age: " + this.memberAge);
			console.log("age pixels: " + this.firstBandPixels);
    },
    _setupTheme: function () {
			//this.defaultTheme = Timeline.ClassicTheme.create();
      this.theme = Timeline.ClassicTheme.create();
			// Have to set start date?
			//this.theme.autoWidth = true;
			this.theme.timeline_start = new Date(Date.UTC(1800, 0, 1));
			this.theme.timeline_stop  = new Date().moveToLastDayOfMonth(); // Force stop scrolling past today
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
        intervalPixels: 70, //100
        date: this.centerDate,
        eventSource: this.eventSource,
        theme: this.theme
      }), Timeline.createBandInfo({
        width: "8%",
        intervalUnit: Timeline.DateTime.MONTH,
        intervalPixels: 250,
        date: this.centerDate,
        overview: true,
        theme: this.theme
      }), Timeline.createBandInfo({
        width: "8%",
        intervalUnit: Timeline.DateTime.YEAR,
				intervalPixels: 100,
        overview: true,
        date: this.centerDate,
        theme: this.theme
      })];

      this.bandInfos[0].syncWith = 1;
      this.bandInfos[2].syncWith = 1;
      this.bandInfos[3].syncWith = 1;

      this.bandInfos[0].highlight = false;
      this.bandInfos[1].highlight = true;
      this.bandInfos[2].highlight = true;
      this.bandInfos[3].highlight = true;

      var start_date = new ETLDate(this.startDate, 'gregorian').getOutDate();
      var end_date = new ETLDate(this.endDate, 'gregorian').getOutDate();

			console.log("band start, end dates: " + start_date + " - " + end_date);
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
			Timeline._Band.prototype._onMouseUp = function(B,A,C) {
				this.setDragging(false);
				this._keyboardInput.focus();
				console.log("onMouseUp");
				
				that.timeline._onScroll();
      };
			this.timeline.getBand(1).addOnScrollListener(this._onMouseScroll.bind(this));
    },
		_handleUIEvents: function() {
			// Hide tooltip on any click
			document.observe('click', function(e) { Tips.hideAll(); });
			// Handle event list mouseovers
			document.observe('event_list_item:hover', function(e) {
				ETUI.onEventListItemMouseOver(e.element());
			});
			document.observe('event_icon:hover', function(e) {
				ETUI.onEventIconMouseOver(e.element());
			});
		},
    _setReqDates: function () {
      this.currentDate = new Date();
      this.tlMinDate = new Date();
      this.tlMaxDate = new Date();
      this.centerDate = new Date();
      this.tlMinDate.setMonth(this.tlMinDate.getMonth() - 1);
      this.tlMaxDate.setMonth(this.tlMaxDate.getMonth() + 1);
      this._eventsLoading(this.currentDate);
    },
		_setCenterDate: function (date) {
			this.currentDate = this.centerDate = date;
		},
    _getTitleFromDate: function (date, type) {
      return (type + " from " + date.getMonthName() + " " + date.getFullYear())
    },
		_onScroll: function() {
			var band;
			var tlMinDate;
      var tlMaxDate;
			var currCenterDate;
			
			//this.timeline.hideBackupMessage();
			
			band = this.timeline.getBand(1);
			currCenterDate = this.centerDate;
			this._setCenterDate(band.getCenterVisibleDate());
		
			if (this.disableSearch) { return; }
			
			tlMinDate = band.getMinVisibleDate();
			tlMaxDate = band.getMaxVisibleDate();
			
			// Snap to max date if scrolled past it
			if (tlMinDate > this.theme.timeline_stop) {
				this.scrollTo(this.theme.timeline_stop);
			} else if (tlMaxDate > this.tlMaxDate) {
        this.tlMaxDate.addMonths(1);
				
				this.updateEvents({
          startDate: tlMinDate,
          endDate: tlMaxDate
        });
      } else if (tlMinDate < this.tlMinDate) {
        this.tlMinDate.addMonths(-1);

        this.updateEvents({
          startDate: tlMinDate,
          endDate: tlMaxDate
        });
      } else if (!currCenterDate.equalsYearMonth(band.getCenterVisibleDate())) {
				console.log("onmouseup to new month: " + this.centerDate);
				this.updateEvents({startDate: this.centerDate});
      } else {
				// Recreate tooltips on every scroll, timleline loses them somehow if you scroll too far
				this.redraw();
			}
		},
		_onMouseScroll: function () {
				if (!this.timeline._dragging && !this.inScrollTo) {
					console.log("onMouseScroll");
					//this._updateTitles(band.getCenterVisibleDate());
					this._onScroll();
				}
		},
		// Takes array of dates & determines which date to scroll to based on search type
		_getScrollToDate: function(dates) {
			dates.sort();
			return (this.seeking === 'future') ? dates[0] : dates.pop();
		},
    _updateTitles: function (d) {
      that.artifactSection.updateTitle(this._getTitleFromDate(d, "Artifacts"));
      that.eventSection.updateTitle(this._getTitleFromDate(d, "Events"));
			that.monthSelector.update(d);
    },
    _loadCached: function () {
			this.scrollTo(this.centerDate);
    },
    _create: function () {
			var li;
			var a;
			
      this.timeline = Timeline.create($(this.domID), this.bandInfos);

			//this.timeline.addCustomMethods();
			/* ============ BEGIN 
			 * modified by: dimas 17 Aug 09
			 * this 9 lines below are custom methods
			 */
			Timeline._Impl.prototype.addCustomMethods = function() {
				var containerDiv = this._containerDiv;
				var doc = containerDiv.ownerDocument;

				var message = SimileAjax.Graphics.createMessageBubble(doc);
				message.containerDiv.className = "timeline-message-container";
				containerDiv.appendChild(message.containerDiv);

				message.contentDiv.className = "timeline-message";
				message.contentDiv.innerHTML = "Please backup your accounts first";

				this.showBackupMessage = function() { message.containerDiv.style.display = "block"; };
				this.hideBackupMessage = function() { message.containerDiv.style.display = "none"; };
			};
			/*
			 * ============== END */
			// Setup click handler for timeline events
			Timeline.OriginalEventPainter.prototype._showBubble = function(x, y, evt) {
				// Should fire click() on matching event list target link
				if ((li = ETemplates.event_list_item(evt.getEventID())) !== undefined) {
					if ((li !== null) && (a = li.down().down('a.event_list_inline_item')) !== undefined) {
						Tips.hideAll();
						Lightview.show({
						 	href: a.href,
						  rel: a.rel,
							options: {
								caption: 'Timeline Details',
								topclose: true, 
								width: 650,
								height: getWinHeight()
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
			  //--console.log(event.num);
				this.eventSource.add((new ETLTimelineEvent(event)).event);
      }.bind(this));
			// Force timeline to redraw so that events show up
			this.eventSource._listeners.invoke('onAddMany');
			this.redraw();
    },
		// Update events titles & show loading html
    _eventsLoading: function (d) {
			// Before [re]creating DOM, remove existing in-memory observers & Tips
			ETUI.onEventSectionLoading();
	
      console.log("loading events & artifacts for: " + d)
      this._updateTitles(d);
      that.artifactSection.showLoading();
      that.eventSection.showLoading();
    },
		// Required due to bug in timeline that kills tooltips after they go out of bounds
		redraw: function() {
			ETUI.createTimelineEventIconObservers();
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
 			this._handleUIEvents();
				
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
    onSearchError: function () {
			this.searchInProgress = false;
      this.hideLoading();
			this.rawEvents.populateResults(this.currentDate);
      //TODO: display errors
    },
    onEventSearchSuccess: function (results) {
			this.searchInProgress = false;
      this.hideLoading();
			// Add to timeline, events & artifacts
      this.parseSearchResults(results);
    },
		onProximitySearchSuccess: function (results) {
			this.searchInProgress = false;
			this.hideLoading();
			this.parseProximitySearchResults(results);
		},
		// On date nav button click or past/future events search
		onNewDate: function(newDate) {
			this.scrollTo(newDate, {populate: false});
			this.updateEvents({startDate: newDate});
		},
		// shows loading box & performs search
		updateEvents: function(params) {
			this._eventsLoading(params.startDate);
			this.searchEvents(params);
		},
		// Search events prior to current display month
		searchClosestEvents: function(past_or_future) {
			this.seeking = past_or_future;
		
			// Search for nearest event
			// If we get a result, do a full search on that result's date
			this.updateEvents({
					startDate: this.centerDate,
					endDate: this.centerDate,
        	range: false,
					onComplete: this.onProximitySearchSuccess,
					options: { proximity: past_or_future }
      });
		},
    searchEvents: function (params) {
      //var params = {startDate: this.startDate, endDate: this.endDate, options: this.options}
			var p = Object.extend({
				startDate: this.currentDate,
				endDate: this.currentDate,
        options: this.options,
				range: true,
				onComplete: this.onEventSearchSuccess
      }, params);

			// Convert dates to string
			// Make sure entire months are searched since we cache results by month
			if (p.range) {
				p.startDate = p.startDate.addMonths(-1).startingMonth();
				p.endDate = p.endDate.addMonths(1).endingMonth();
			} else {
				p.startDate = p.startDate.toMysqlDateString();
				p.endDate = p.endDate.toMysqlDateString();
			}
      // Don't repeat searches for same dates
      if (p.range && this.searchCache.hasDates(p.startDate, p.endDate)) {
        this._loadCached();
      } else {
				if (!this.searchInProgress) {
					// Add dates to cache so we don't repeat ajax call
					this.searchCache.addDates(p.startDate, p.endDate);

					// Start Ajax search process - callbacks will handle response
					this.searchInProgress = true;
					new ETLSearch(this, p);
				}
      }
    },
    parseSearchResults: function (results) {
			var groupedEvents;
			var newDate;
			
			// Parse json results & save
      this.rawEvents.addEvents(results);
			this.rawEvents.populateResults(this.currentDate);
			
			// Add to timeline event sources
			groupedEvents = this.rawEvents.getEventGroups();
			if (groupedEvents.length > 0) {
				this._addEvents(groupedEvents);
				// Center timeline on latest new event or 1st or last
				newDate = this._getScrollToDate(groupedEvents.pluck('start_date')).toDate();
				// auto scroll within the search results month if necessary
				if (!newDate.equalsDay(this.currentDate) && (newDate.equalsYearMonth(this.currentDate))) {
					console.log("auto scrolling to " + newDate);
					this.scrollTo(newDate);
				}
			}
			// Hides any tooltip on click (required to hide on tooltip element link click)
			$$('a').each(function (e) {
				e.observe('click', function(e) { Tips.hideAll(); });
			});
			this.seeking = null;
    },
		parseProximitySearchResults: function (results) {
			var parsed = results.evalJSON();
			var evt;
			var dates = [];
			var date;
			
			// Get closest date
			if (parsed && (parsed.resultCount > 0)) {
				for (var i=0; i<parsed.results.length; i++) {
					dates.push(ETEvent.createSource(parsed.results[i]).getEventDate());
				}
				// Use 1st result since we just want the date
				date = this._getScrollToDate(dates).toDate();
				console.log('got proximity date = ' + date)
				this._setCenterDate(date); // confusing
				this.updateEvents({startDate: date, endDate: date});
			} else {
				console.log('no results from proximity search');
				this.rawEvents.populateResults(this.currentDate);
			}
		},
		scrollTo: function(date, opts) {
			opts = Object.extend({populate: true}, opts);
			
			console.log("Scrolling to date " + date);
			this.inScrollTo = true;
			this.timeline.getBand(1).setCenterVisibleDate(date);
			this._setCenterDate(date);
			this._updateTitles(date);
			if (opts.populate) {
				this.rawEvents.populateResults(date);
				this.redraw();
			}
			this.inScrollTo = false;
		}
  });

  var draw = function () {
    that.monthSelector = new ETLMonthSelector(options.month_selector_id);
    that.artifactSection = new ETLArtifactSection(options.artifact_section_id);
    that.eventSection = new ETLEventSection(options.events_section_id);
    that.base = new ETLBase(options.timeline_section_id, options.timeline);
  }

  // Set public methods now
  me.draw = draw;
  me.api = api;

  // Return 'class' object with only public methods exposed.
  return me;
};
