// $Id$
//
// Timeline javascript module
// required Date' prototypes
Date.prototype.numDays = function() {
	return this.getDaysInMonth(this.getFullYear(), this.getMonth());
};
Date.prototype.getFullMonth = function() {
	var m = this.getMonth() + 1 + "";
	return (m.length < 2) ? "0" + m : m;
};
// Returns YYYY-MM-DD string with day set to beginning of the month
Date.prototype.startingMonth = function() {
	return this.getFullYear() + "-" + this.getFullMonth() + "-01";
};
// Returns YYYY-MM-DD string with day set to end of the month
Date.prototype.endingMonth = function() {
	return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.numDays();
};
// Return YYYY-MM-DD string representation of the date
Date.prototype.toMysqlDateString = function() {
	return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.getDate();
};
Date.prototype.getMonthName = function() {
	var nm = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	var nu = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
	return nm[this.getMonth()];
};

Date.prototype.monthRange = function(num, dir) {
	var set_up = function(d) {
		d.setMonth(d.getMonth() + num);
	};
	var set_down = function(d) {
		d.setMonth(d.getMonth() - num);
	};

	dir == 'next' ? set_up(this) : set_down(this);
	var rv = this.getFullYear() + "-" + this.getFullMonth() + "-" + this.getDate();
	dir == 'next' ? set_down(this) : set_up(this);

	return rv;
};
// Compares date to other date & returns true iff year & month are the same
Date.prototype.equalsYearMonth = function(other) {
	return (this.getYear() === other.getYear()) && (this.getFullMonth() === other.getFullMonth());
};
Date.prototype.equalsDay = function(other) {
	return this.clone().clearTime().equals(other.clone().clearTime());
};
// isMonthAfter
// Returns true iff  date's month is > passed dated
Date.prototype.isMonthAfter = function(d) {
	return this.clone().moveToFirstDayOfMonth().clearTime() > d.clone().moveToFirstDayOfMonth().clearTime();
};

// required Array' prototypes 
Array.prototype.unique = function() {
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
};
// Fisher-Yates randomization
Array.prototype.randomize = function() {
	var i = this.length;
	var j, tempi, tempj;

	if (i === 0) return false;
	while (--i) {
		j = Math.floor(Math.random() * (i + 1));
		tempi = this[i];
		tempj = this[j];
		this[i] = tempj;
		this[j] = tempi;
	}
	return this;
};

//Date parsing regex & sort function
var MysqlDateRE = /^(\d{4})\-(\d{2})\-(\d{2})T?.*/;
var mysqlTimeToDate = function(datetime) {
	//function parses mysql datetime string and returns javascript Date object
	//input has to be in this format: 2007-06-05 15:26:02
	var regex = /^([0-9]{2,4})-([0-1][0-9])-([0-3][0-9]) (?:([0-2][0-9]):([0-5][0-9]):([0-5][0-9]))?$/;
	var parts = datetime.replace(regex, "$1 $2 $3 $4 $5 $6").split(' ');
	return new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4], parts[5]);
};
//function parses mysql datetime string and returns javascript Date object
//input has to be in this format: 2007-06-05
var mysqlDateToDate = function(date) {
	var parts = date.replace(MysqlDateRE, "$1 $2 $3").split(' ');
	return new Date(parts[0], parts[1] - 1, parts[2]);
};
var orderDatesDescending = function(x, y) {
	x = x.replace(MysqlDateRE, "$1$2$3");
	y = y.replace(MysqlDateRE, "$1$2$3");
	if (x > y) return -1;
	if (x < y) return 1;
	return 0;
};
String.prototype.toDate = function() {
	return mysqlDateToDate(this);
};
String.prototype.toMysqlDateFormat = function() {
	return this.replace(MysqlDateRE, "$1 $2 $3").split(' ').join('-');
};
String.prototype.toISODate = function() {
	var dt = Date.parseExact(this, "yyyy-MM-ddTHH:mm:ssZ");
	if (!dt) {
		dt = this.toDate();
	}
	return dt;
};
// Timeline-wide debug flag
var DEBUG = false;
var DEBUG_BOX = false; // show debug in box
// Timeline debug module
var ETDebug = function() {
	function onpage(msg) {
		if (DEBUG_BOX) {
			$('debug_box').innerHTML += msg + ' ';
			log(msg);
		}
	};
	function log(msg) {
		if (DEBUG) {
			console.log(msg);
		}
	};
	function dump(msg) {
		if (DEBUG) {
			console.dir(msg);
		}
	};
	return {
		onpage: onpage,
		log: log,
		dump: dump
	};
} ();

//Eternos Timeline Date
var ETLDate = Class.create({
	initialize: function(date, format) {
		this.inDate = date;
		this.inFormat = format || 'natural';
		this.getOutDate();
	},
	getOutDate: function() {
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

// Helper module to allow onmouseover-time creation of tooltip html
// Maps event id => ETLEventItems object
var tooltipGenerator = function() {
	var eventItemsMap = {};

	// data is object containing id & type attributes
	function key(data) {
		return parseInt(data.id + data.type, 16); // Convert to hex num
	}
	// Map id to ETLEventItems class object
	function add(evItemsObj) {
		eventItemsMap[key(evItemsObj)] = evItemsObj;
	};



	function value(data) {
		return eventItemsMap[key(data)];
	};



	function generate(key) {
		var itemsObj, results = {};
		if ((itemsObj = eventItemsMap[key]) != null) {
			results = {
				title: itemsObj.getTooltipTitle(),
				body: itemsObj.getTooltipContents(),
				type: itemsObj.type
			};
		}
		return results;
	};
	return {
		key: key,
		value: value,
		add: add,
		generate: generate
	};
} ();

// UI action event handlers
var ETUI = function() {
	
	// Private funcs
	// fetch tooltip contents for an element
	function getTooltip(id) {
		return tooltipGenerator.generate(id);
	};
	// Create the Tooltip object on the element identified by ID
	function createTooltip(element, id, tipOptions) {
		var tipContents, player, leftOffset, width;
		// Deep copy options for modifications
		var tipOpts = Object.extend({}, tipOptions);

		if ((tipContents = getTooltip(id)) == null) {
			return false;
		}
		// Save offset coordinates from top left of screen
		element.lastCumulativeOffset = element.cumulativeOffset();
		element.tipType = tipContents.type;

		// Determine tooltip position relative to icon (left or right) so that 
		// it says in viewport
		// viewport: true option in Tip doesn't help
		if ((tipOpts.hook.target != null) && (tipOpts.hook.target === 'bottomRight')) {
			leftOffset = element.lastCumulativeOffset.left;
			width = win_dimension()[0];

			if (leftOffset > (width / 2)) {
				Object.extend(tipOpts, ETemplates.timelineTooltipOptionsLeft());
			}
		}
		tipOpts.width = ETemplates.defaultTooltipWidth(tipContents.type);
		tipOpts.title = tipContents.title;
		// Add tootip options based on element type
		tipOpts = Object.extend(
			(ETEvent.isVideo(element.tipType) ? ETemplates.videoTooltipOptions() : ETemplates.defaultTooltipOptions()),
			tipOpts);
		
		
		new Tip(element, tipContents.body, tipOpts);
		element.prototip.show();

		postprocessTooltip(element, id);
		return true;
	};
	// Perform any necessary pre-processing for new tooltips
	function preprocessTooltip(el, tipType) {

	};
	// Perform any necessary post-processing for new tooltips
	function postprocessTooltip(el, id) {
		// Video contents need player initialized & playlist assigned
		if (ETEvent.isVideo(el.tipType)) {
			TooltipMedia.setupVideoPlayback(id);
		} else if (ETEvent.isAudio(el.tipType)) {
			TooltipMedia.setupAudioPlayback(id);
		} else {
			// Add observer to hide it on click
			el.observe('click', function(e) {
				el.prototip.hide();
				return true;
			});
		}
	};
	

	// Finds event object associated with  element id
	function getEventFromElementID(elID) {
		return Timeline.EventUtils.decodeEventElID(elID).evt;
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
			var tipContents, id, ttOpts = ETemplates.eventTooltipOptions();
			// get the event id from the container div id
			id = (element.id.split('_'))[1];

			if (element.prototip != null) {
				ETDebug.log("event item already has prototip attribute");
				// Flowplayer object sometimes unloads even when the tooltip does not, 
				// so see if the video objects need to be recreated.  
				if (ETEvent.isVideo(element.tipType)) {
					ETDebug.log("destroying tooltip to kill flash players");
					element.prototip.remove();
				} else {
					return true;
				}
			}
			return createTooltip(element, id, ttOpts);
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
		// May be possible to hook Timeline paint function to add observer
		createTimelineEventIconObservers: function() {
			$$('.tl_event').each(function(el) {
				if (el.observingMouseOver === undefined) {
					el.observe('mouseover', function(e) {
						el.fire('event_icon:hover');
					});
					el.observingMouseOver = true;
				}
			});
		},
		onEventIconMouseOver: function(element) {
			var event = getEventFromElementID(element.id);

			if (element.prototip != null) {
				ETDebug.log("timeline icon already has prototip attribute");
				// If tooltip target changed position from last display, we must recreate it
				if (element.cumulativeOffset().left !== element.lastCumulativeOffset.left) {
					ETDebug.log("target position changed, recreating");
					element.prototip.remove();
				} else if (ETEvent.isVideo(element.tipType)) {
					ETDebug.log("destroying tooltip to kill flash players");
					element.prototip.remove();
					//setupVideoPlayback(event.getEventID());
				} else {
					return true;
				}
			}
			ETDebug.log('creating tooltip on ' + element.id);

			return createTooltip(element, event.getEventID(), event.isInstant() ? ETemplates.timelineTooltipOptions() : ETemplates.timelineDurationTooltipOptions());
		},
		createSearchClickHandlers: function(timeline) {
			// Setup previous, future events link click handlers when there are no events to display
			if ((el = $('prev_event_search')) != null) {
				el.observe('click', function(e) {
					timeline.searchClosestEvents('past');
				});
			}
			if ((el = $('next_event_search')) != null) {
				el.observe('click', function(e) {
					timeline.searchClosestEvents('future');
				});
			}
		}
	};
} ();

// Eternos Timeline Event Items html generator
var ETLEventItems = Class.create({
	initialize: function(items, opts) {
		this.MaxArtifactTooltipItems = 10;
		this.MaxTooltipItems = 50;

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

		// Add object to tooltip cache
		tooltipGenerator.add(this);
	},
	_getItemIDs: function() {
		return this.items.collect(function(i) {
			return i.attributes.id;
		});
	},
	_getItemID: function() {
		return tooltipGenerator.key({
			id: this.id,
			type: this.type
		});
	},
	// Popup link code for all items
	_getLinkUrl: function() {
		var item = this.first;
		if (item.isArtifact()) {
			this.detailsUrl = item.getURL();
		} else {
			this.detailsUrl = ETemplates.eventListTemplates.detailsLink.evaluate({
				memberId: this.options.memberID,
				eventType: this.type,
				eventIds: encodeURIComponent(this._getItemIDs())
			});
		}
		return this.detailsUrl;
	},
	// show url for 1+ item
	_getItemDetailsUrl: function(item) {
		return ETemplates.eventListTemplates.detailsLink.evaluate({
			memberId: this.options.memberID,
			eventType: item.type,
			eventIds: item.getID()
		});
	},
	_getItemCaptions: function() {
		var caption = '', captions = new Array();
		this.items.each(function(i) {
			if ((caption = i.getCaption()) != null) {
				captions.push(caption);
			}
		});
		if (captions.size() > 0) {
			caption = captions.join('<p>&nbsp;</p>');
		}
		return caption;
	},
	// Determine 'rel' attribute for Lightview link html
	_getLinkRel: function() {
		if (this.first.isArtifact()) {
			// Lightview auto-detects content so just need to know if gallery or not
			this.detailsLinkRel = (this.num > 1) ? 'gallery[' + this.first.getID() + ']' : '';
		} else {
			this.detailsLinkRel = 'iframe';
		}
		return this.detailsLinkRel;
	},
	_getArtifactItemHtml: function() {
		return ETemplates.eventListTemplates.eventItemWithTooltip.evaluate({
			list_item_id: this._getItemID(),
			b_title: this.title,
			title: ETemplates.eventListTemplates.tooltipTitle.evaluate({
				icon: this.icon,
				title: this.title
			}),
			link_url: this._getLinkUrl(),
			link_rel: this._getLinkRel()
			/*
      hidden_items: other_items,
      tt_content: this.getTooltipContents()
*/
		});
	},
	_getInlineItemHtml: function() {
		return ETemplates.eventListTemplates.eventGroupItem.evaluate({
			list_item_id: this._getItemID(),
			title: this.getTooltipTitle(),
			caption: this._getItemCaptions(),
			//link_url: /this._getLinkUrl(),
			link_url: 'javascript:void(0);', 
			link_rel: this._getLinkRel(),
			details_win_height: getWinHeight()
		});
	},
	_getInlineContents: function() {
		return ETemplates.eventListTemplates.inlineEvents.evaluate({
			id: this.first.getID(),
			content: 'TODO'
		});
	},
	_getMediaItemsPlaylistHtml: function() {
		var html = '';
		this.items.each(function(i) {
			html += ETemplates.eventListTemplates.mediaPlaylistItem.evaluate(
			Object.extend({
				url: i.getURL(),
				thumbnail_url: i.getThumbnailURL(),
				title: i.getTitle(),
				description: i.attributes.description,
				time: i.getEventTimeHtml(),
				duration: i.attributes.duration_to_s
			},
			this._itemMenuLinks(i)));
		}.bind(this));
		return html;
	},
	_itemMenuLinks: function(item) {
		return {
			event_details_link: this._getItemDetailsUrl(item),
			event_edit_link: this._getItemDetailsUrl(item),
			//item.getEditURL(),
			event_delete_link: item.getDeleteURL()
		};
	},
	// Determines if items are artifacts
	isArtifacts: function() {
		return this.first.isArtifact();
	},
	getTooltipTitle: function() {
		return ETemplates.eventListTemplates.tooltipTitle.evaluate({
			icon: this.icon,
			title: this.title
		});
	},
	// Generates tooltip html for all types.  Used by both event list & timeline icons
	// TODO:  create a Tooltip module / classes
	getTooltipContents: function() {
		var i, count, item, listId = this._getItemID(),
			view_all_url, html = '';
		var collectionIds = new Array();
		var winHeight = getWinHeight();

		if (this.num == 0) {
			// this should never happen
			return '';
		}
		// Media tooltip requires more work
		if (this.first.isVideo()) {
			// Builds tooltip html for media items - creates playlist & viewer
			return ETemplates.eventListTemplates.mediaTooltip.evaluate({
				id: ETemplates.tooltipTemplateID(listId, 'media'),
				playlist: this._getMediaItemsPlaylistHtml()
			});
		} else {
			// Images & the rest handled below
			if (this.first.isArtifact()) {
				count = Math.min(this.MaxArtifactTooltipItems, this.num);
				html = '<div class="tooltip_arti_container">';
			} else {
				count = Math.min(this.MaxTooltipItems, this.num);
				html = '<div class="tooltip_all_container">';
			}
			for (i = 0; i < count; i++) {
				item = this.items[i];
				if (item.attributes.collection_id) {
					collectionIds.push(item.attributes.collection_id);
				}
				item.menuLinks = this._itemMenuLinks(item);
				html += ETemplates.eventListTemplates.eventItemTooltipItem.evaluate(
				Object.extend({
					details_win_height: winHeight,
					content: item.getPreviewHtml()
				},
				this._itemMenuLinks(item)));
			}
			// Add link to view all
			if (count < this.num) {
				// Collect all album ids for gallery url
				if (this.first.isArtifact() && (collectionIds.size() > 0)) {
					html += ETemplates.albumViewLinkTemplate.evaluate({
						url: '/image_gallery?album_id=' + encodeURIComponent(collectionIds.uniq().join(','))
					});
				} else {
					html += '<br/><a href="' + this._getLinkUrl() + '" class="lightview" rel="iframe">View All</a>';
				}
			}
		}
		html += '</div>';
		this.tooltipHtml = html;
		return this.tooltipHtml;
	},
	populate: function() {
		// Need to format the link so all content will be displayed
		if (this.first.isArtifact()) {
			return this._getArtifactItemHtml();
		} else {
			return this._getInlineItemHtml();
		}
	}
});

// Returns new Timeline.DefaultEventSource.Event object
var ETimelineEvent = function(events) {
	var icon_s = events.icon;
	var icon = ETemplates.utils.assetUrl + ETemplates.utils.imgUrl + icon_s + ETemplates.utils.iconPostfix;
	var sdate = events.start_date.toDate();
	var edate = (events.end_date != null) ? events.end_date.toDate() : null;
	var isDuration = (sdate !== edate);

	var ev = new Timeline.DefaultEventSource.Event({
		start: sdate,
		end: edate,
		latestStart: sdate,
		earliestEnd: edate,
		durationEvent: isDuration,
		instant: !isDuration,
		icon: icon,
		classname: 'tl_event',
		caption: 'Click to view details',
		eventID: tooltipGenerator.key({
			id: events.id,
			type: events.type
		}) // Not numeric!
		// for all possible attributes, see http://code.google.com/p/simile-widgets/wiki/Timeline_EventSources
	});
	// this.title = events.title;
	// 	this.type = events.type;
	// 	this.id = events.id,
	// 	this.num = events.num;
	// Set icon size for event using frequency = size trick
	// Used here:
	// Timeline.OriginalEventPainter /public/javascripts/timeline/timeline_js/scripts/original-painter.js:473
	ev.iconSize = ETemplates.getIconSize(events.num);

	return ev;
};

// ETimeline 'class'
var ETimeline = function(opts) {
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
		initialize: function(domID) {
			this.parent = $(domID);
			this.activeDate = new Date();
			this.advanceMonths = new Array();
			this.pastMonths = new Array();
			this.monthUpDisabled = false;
			this.yearUpDisabled = false;
			this._enableNavButtons();
		},
		_populate: function() {
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
		_disableClick: function(id) {
			new Effect.Opacity(id, {
				from: 1.0,
				to: 0.4
			});
		},
		_enableClick: function(id) {
			new Effect.Opacity(id, {
				from: 0.4,
				to: 1.0
			});
		},
		_enableNavButtons: function() {
			$('month_selector_down').observe('click', function(event) {
				event.stop();
				this.stepDate(this.activeDate.clone().addMonths(-1));
			}.bind(this));
			$('year_selector_down').observe('click', function(event) {
				event.stop();
				this.stepDate(this.activeDate.clone().addYears(-1));
			}.bind(this));
			$('month_selector_up').observe('click', function(event) {
				event.stop();
				if (this._canClickNextMonth()) {
					this.stepDate(this.activeDate.clone().addMonths(1));
				}
			}.bind(this));
			$('year_selector_up').observe('click', function(event) {
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
		stepDate: function(newDate) {
			if (newDate.isMonthAfter(Date.today())) {
				// Don't allow stepping into the future
				return;
			}
			ETDebug.log("Date selector stepping from " + this.activeDate + " to " + newDate);
			this.setDate(newDate);
			that.timeline.onNewDate(newDate);
		}
	});

	//Eternos Timeline Artifact Section
	var ETLArtifactSection = Class.create({
		initialize: function(domID) {
			this.MaxDisplayCount 	= 9;
			this.pixPerRow				= 3;
			// Set this to true|false
			this.doRandomize = false;

			this.parent = $(domID);
			this.timeOut = 3;
			this.title = "Artifacts";
			this.items = [];
			this.template = ETemplates.artifactTemplates.artifacts;
			this.loadingTemplate = ETemplates.loadingTemplate;
			this.boxTemplate = ETemplates.artifactTemplates.artifactBox;

			this.showLoading();
		},
		// Returns collection of artifacts for the given date
		// Skip any items that don't have thumbnail or don't fall on target month
		_itemsInDate: function(date) {
			var targetDate = date.startingMonth();

			ETDebug.log("Looking for artifacts in collection of " + this.items.size() + " items matching date: " + targetDate);
			return this.items.findAll(function(i) {
				return (i !== undefined) && (i.attributes.thumbnail_url !== undefined) && (i.getEventDateObj().startingMonth() === targetDate);
			});
		},
		_itemsToS: function(activeDate) {
			var i, j, rows, numDisplay;
			var s = '',
				ul_class;
			var item, artis = this._itemsInDate(activeDate);

			if ((numDisplay = Math.min(artis.length, this.MaxDisplayCount)) > 0) {
				artis.randomize();
			}
			ETDebug.log("Displaying " + numDisplay + " artifacts for: " + activeDate);

			for (i=0, j=0; i<numDisplay; i++) {
				item = artis[i];
				ETDebug.log("Adding artifact #" + i + ": type: " + item.type);

				s += this.boxTemplate.evaluate({
					id: item.getID(),
					num: i,
					style: 'artifact-thumbnail',
					url: item.getURL(),
					thumbnail_url: item.getThumbnailURL(),
					title: item.getTitle(),
					caption: item.getText()
				});
				// In rows of pixPerRow
				if (((j+1) % this.pixPerRow) == 0) {
					s += '<br/>';
				}
			}
			return s;
		},
		_write: function(content) {
			var c = content || '';
			if (c === '' || this.items.length < 1) {
				c = (div = $('artifact_info')) ? div.innertHTML : ''; //that.utils.blankArtifactImg;
			}
			this.parent.innerHTML = this.template.evaluate({
				title: this.title,
				artifacts: c
			});
		},
		// Adds artifact event object to internal collection, returns 
		// true if added.
		addItem: function(item) {
			// Skip artifacts with missing source or if already added
			ETDebug.log("add artifact: " + item.type);
			if ((item.getURL() == null) || this.contains(item)) {
				ETDebug.log("not added");
				return false;
			}
			this.items.push(item);
			return true;
		},
		addItems: function(items) {
			this.items.concat(items);
		},
		empty: function() {
			this.items.clear();
		},
		// Returns true if items list contains item with the same source url
		contains: function(item) {
			return this.items.detect(function(i) {
				return item.getURL() === i.getURL();
			});
		},
		populate: function(activeDate) {
			this._write(this._itemsToS(activeDate));
		},
		showLoading: function() {
			this._write(this.loadingTemplate.evaluate({
				type: " Artifacts"
			}));
			//	load_busy(this.parent);
		},
		updateTitle: function(title) {
			this.title = title;
			this._write();
		}
		/*
		, randomize: function() {
			var i, j, tmp, tmp_title;
			var v = $$('li.visible-artifact-item');
			var h = $$('li.hidden-artifact-item');
			if (v.length === 0 || h.length === 0) {
				return;
			}

			if (this.doRandomize) {
				new PeriodicalExecuter(function(pe) {
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
						ETDebug.log("Swapping artifact with html: " + h[j].innerHTML);
						v[i].update(h[j].innerHTML);
						if (h[j].down().title !== '') { // correct some weirdness
							ETDebug.log("setting title attribute: " + h[j].down().title);
							v[i].down().writeAttribute({
								title: h[j].down().title
							});
						}
						ETDebug.log("Swapping artifact with html: " + tmp.innerHTML);
						h[j].update(tmp.innerHTML);
						//ETDebug.log("setting title attribute: " + tmp_title);
						//h[j].down().writeAttribute({title: tmp_title});
					}
				}.bind(this), this.timeOut);
			}
		}
		*/
	});

	//Eternos Timeline Event Section
	var ETLEventSection = Class.create({
		initialize: function(domID) {
			this.parent = $(domID);
			this.title = "Events";
			this.loading = ETemplates.loadingTemplate;
			this.template = ETemplates.eventListTemplates.events;
			this.content = "";
			this.images = new Array();

			this.populate();
			this.showLoading();
		},
		_clearContent: function() {
			this.content = "";
		},
		_write: function() {
			this.parent.innerHTML = this.template.evaluate({
				title: this.title,
				events: this.content
			});
			ETUI.createEventListItemObservers();
		},
		populate: function(content) {
			this.content = content || '';
			this._write();
		},
		showLoading: function() {
			this.populate(this.loading.evaluate({
				type: " Events"
			}));
			//	load_busy(this.parent);
		},
		updateTitle: function(title) {
			this.title = title;
			this._write();
		}
	});

	//Eternos Timeline Event Collection
	var ETLEventCollection = Class.create({
		initialize: function() {
			this.reset();
			this.groupTemplate = ETemplates.eventListTemplates.eventGroup;
			this.noEventsTemplate = ETemplates.eventListTemplates.noEvents;
		},
		reset: function() {
			this.sources = [];
			this.durations = {};
			this.latestSources = [];
			this.latestDurations = [];
			this.dates = [];
			this.rawItems = [];
			this.items = [];
		},
		empty: function() {
			this.reset();
		},
		// Add event source to collection keyed by event date
		addSource: function(source) {
			this.sources.push(source);

			if (source.isDuration()) {
				// Check duration cache for existing value, skip if found
				if (!this.durations[tooltipGenerator.key(source)]) {
					this.durations[tooltipGenerator.key(source)] = source;
					this.latestDurations.push(source);
				}
			} else {
				this.latestSources.push(source);
				this._groupSourceByDate(this.rawItems, this.dates, source);
			}
		},
		// Generates html for events list section
		// TODO: HTML generation should be handled in ETLEventSection class.
		populate: function(targetDate) {
			var td = targetDate || that.monthSelector.activeDate;
			var currentItems;
			var itemsHtml;
			var html = '';
			var events;
			var activeDates;
			var dateItems = new Array();
			
			ETDebug.log("Populating with events from " + td);

			// Only use events that fall in the active date month
			activeDates = this.dates.select(function(d) {
				return td.equalsYearMonth(d.toDate());
			});
			activeDates.sort(orderDatesDescending).each(function(d, rowIndex) {
				itemsHtml = '';
				dateItems.clear();
				currentItems = this._groupItemsByType(this.rawItems[d]);

				currentItems.each(function(group, index) {
					events = new ETLEventItems(group, {
						memberID: that.memberID
					});
					dateItems.push(events); // Save all items grouped by date
					
					// Skip image events - these get added by _getGroupImagesHtml()
					if (!events.isArtifacts()) {
						this.items.push(events);
						itemsHtml += events.populate();
					}
				}.bind(this));

				html += this.groupTemplate.evaluate({
					date: this._eventDate(d),
					odd_or_even: ((rowIndex % 2) === 0 ? 'even' : 'odd'),
					body: itemsHtml,
					images: this._getGroupImagesHtml(dateItems)
				});
			}.bind(this));

			if (html === '') {
				html = this.noEventsTemplate.evaluate();
			}
			return html;
		},
		clearLatest: function() {
			this.latestSources.clear();
			this.latestDurations.clear();
		},
		// Groups latest events grouped by type, day
		// Returns array of ETLEventItems
		getLatestEventGroups: function() {
			var grouped = new Array();
			var dates = [];
			var results = [];

			// Skip duration events, group all by dates
			this.latestSources.each(function(s) {
				grouped = this._groupSourceByDate(grouped, dates, s);
			}.bind(this));
			// Group by type per day
			dates.each(function(d) {
				this._groupItemsByType(grouped[d]).each(function(items) {
					results.push(new ETLEventItems(items, {
						memberID: that.memberID
					}));
				});
			}.bind(this));
			return results;
		},
		// Returns duration events as array of ETLEventItems
		getLatestDurationEvents: function() {
			return this.latestDurations.collect(
			function(value) {
				return new ETLEventItems([value], {
					memberID: that.memberID
				});
			});
		},
		// Search dates array for closest date to passed date, past or future
		getClosestDate: function(date, direction) {
			var dt = date.toMysqlDateString();
			var closest = null;

			this.dates.sort(); // sort dates ascending
			for (var i = 0; i < this.dates.length; i++) {
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
		_groupSourceByDate: function(res, dates, source) {
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
		_groupItemsByType: function(items) {
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
			//--results.each(function(item){ETDebug.log(item.length)});
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
		_eventDate: function(date) {
			var d = mysqlDateToDate(date);
			return d.toLocaleDateString();
		},
		// Generates & returns images preview section html
		_getGroupImagesHtml: function(dateItems) {
			// Collect all artifacts from date's collection
			var upTo, i, imageHtml;
			var images = new Array();
			dateItems.each(function(events) {
				images.push(events.items.select(function(item) {
					return item.isArtifact();
				}));
			});
			images = images.flatten();
			if (images.size() > 0) {
				// collect 1st 3 images
				upTo = Math.min(images.size(), 3);
				imageHtml = '';
				for (i=0; i<upTo; i++) {
					imageHtml += '<img src="' + images[i].getThumbnailURL() + '"/>';
				}
				return ETemplates.eventListTemplates.eventGroupImages.evaluate({
					images: imageHtml,
					view_all_images_link: this._getViewAllEventImagesLinkUrl()
				});
			} else {
				return '';
			}
		},
		_getViewAllEventImagesLinkUrl: function() {
			return '<a href="javascript: void(0);">View All</a>';
		}
	});

	//Eternos Timeline Event Parser
	var ETLEventParser = Class.create({
		initialize: function(events) {
			var ev = events || [];
			this.eventItems = new ETLEventCollection();
			this.addEvents(ev);
		},
		// Takes JSON object containing timeline search results
		// Parses & adds results to internal collections
		addEvents: function(events) {
			this.jsonEvents = events.evalJSON();
			ETDebug.log("Adding " + this.jsonEvents.resultCount + " events");
			this._parse();
		},
		// Returns latest parsed results objects array.
		getEventGroups: function() {
			return this.eventItems.getLatestEventGroups();
		},
		// Returns latest duration objects array
		getDurationEvents: function() {
			return this.eventItems.getLatestDurationEvents();
		},
		// Returns nearest existing event date to date
		getClosestEventDate: function(date, past_or_future) {
			return this.eventItems.getClosestDate(date, past_or_future);
		},
		_parse: function() {
			var event;

			this.eventItems.clearLatest();
			this.jsonEvents.results.each(function(res) {
				event = ETEvent.createSource(res);

				// Tricky part here - we add artifacts to the artifacts collection 
				// and to the events collection, but artifacts attached to events
				// must only be added to the artifacts collection.  
				// TODO: We need some attribute to easily determine event-attached artifacts
				if (event.isArtifact()) {
					ETDebug.log("adding event to artifacts");
					that.artifactSection.addItem(event);
					/*
					if (event.hasAttachedArtifact()) {
						// Don't add to items list if artifact is attached to event
						ETDebug.log("event has attached artifact, not adding to events");
						return;
					}
					*/
				} else if (event.hasAttachedArtifact()) {
					ETDebug.log("adding event with attached image to artifacts");
					that.artifactSection.addItem(event);
				}
				this.eventItems.addSource(event);
			}.bind(this));
		},
		populateResults: function(date) {
			var targetDate = date || that.base.centerDate;

			// Make sure month selector is synched up
			// TODO: this should not be here, event parser should not know about month selector
			that.monthSelector.setDate(targetDate);

			that.artifactSection.populate(targetDate);
			that.eventSection.populate(this.eventItems.populate(targetDate));

		},
		empty: function() {
			this.eventItems.empty();
			this.jsonEvents = {};
		}
	});

	//Eternos Timeline Search. init: timeline object and {startDate: 'sring date', endDate: 'string date', options: Object}
	var ETLSearch = Class.create({
		initialize: function(timeline, params) {
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
		_getFullSearchUrl: function() {
			this.fullSearchUrl = [this.searchUrl, that.memberID, this.startDate, this.endDate, this.options].join('/');
		},
		_getJSON: function(url) {
			var that = this;

			new Ajax.Request(url, {
				method: 'get',
				onComplete: function(transport) {
					var response = transport.responseText || "";
					that.onComplete.apply(that.timeline, [response]);
				},
				onFailure: function(err) {
					that.timeline.onSearchError();
				},
				onLoading: function() {
					that.timeline.onSearching();
				}
			});
		}
	});

	// Produces a search cache object that stores/retrieves search dates
	// by year-month. 
	// For use by ETLBase
	var searchCache = function() {
		var searched = [];

		return {
			hashDate: function(d) {
				return d.getFullYear() + d.getFullMonth();
			},
			addDates: function(sd, ed) {
				var stepDate, endDate;
				if (ed < sd || ed === undefined) {
					return;
				}

				stepDate = new ETLDate(sd, 's').getOutDate();
				endDate = new ETLDate(ed, 's').getOutDate();
				do {
					ETDebug.log("Adding " + this.hashDate(stepDate) + " to search date cache");
					searched[this.hashDate(stepDate)] = true;
					stepDate.addMonths(1);
				} while (stepDate <= endDate);
			},
			hasDates: function(sd, ed) {
				var stepDate, endDate;
				if (ed < sd || ed === undefined) {
					return false;
				}

				stepDate = new ETLDate(sd, 's').getOutDate();
				endDate = new ETLDate(ed, 's').getOutDate();

				var found = false;
				do {
					ETDebug.log("Checking search cache for date " + this.hashDate(stepDate));
					if (searched[this.hashDate(stepDate)]) {
						found = true;
						break;
					}
					stepDate.addMonths(1);
				} while (stepDate <= endDate);

				return found;
			},
			empty: function() {
				searched.clear();
			}
		};
	} ();

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
		initialize: function(domID, params) {
			var date = new Date();
			that.memberID = params.memberID;

			this.domID = domID;
			this.resizeTimerID = null;
			this.params = params;
			this.memberID = params.memberID;
			this.startDate = params.startDate;
			this.endDate = params.endDate;
			this.birthDate = params.startDate.toDate();
			this.options = params.options;
			this.searchInProgress = this.seeking = false;
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

			this.init(true);
		},
		_getMemberAge: function() {
			this.memberAge = this.endDate.toDate().getFullYear() - this.startDate.toDate().getFullYear();
			this.firstBandPixels = that.utils.tlEffectiveWidth / (this.memberAge / 10);
			ETDebug.log("Member age: " + this.memberAge);
			ETDebug.log("age pixels: " + this.firstBandPixels);
		},
		_setupTheme: function() {
			//this.defaultTheme = Timeline.ClassicTheme.create();
			this.theme = Timeline.ClassicTheme.create();
			// Have to set start date?
			//this.theme.autoWidth = true;
			this.theme.timeline_start = new Date(Date.UTC(1800, 0, 1));
			this.theme.timeline_stop = new Date().moveToLastDayOfMonth(); // Force stop scrolling past today
		},
		_setupBands: function() {
			//var date = new Date();
			this.bandInfos = [
				Timeline.createBandInfo({
				width: "8%",
				intervalUnit: Timeline.DateTime.DECADE,
				intervalPixels: this.firstBandPixels,
				date: this.centerDate,
				showEventText: false,
				theme: this.theme
			}), 
			Timeline.createBandInfo({
				width: "76%",
				intervalUnit: Timeline.DateTime.DAY,
				intervalPixels: 70,
				//100
				date: this.centerDate,
				eventSource: this.eventSource,
				theme: this.theme
			}), 
			Timeline.createBandInfo({
				width: "8%",
				intervalUnit: Timeline.DateTime.MONTH,
				intervalPixels: 250,
				date: this.centerDate,
				overview: true,
				theme: this.theme
			}), 
			Timeline.createBandInfo({
				width: "8%",
				intervalUnit: Timeline.DateTime.YEAR,
				intervalPixels: 100,
				overview: true,
				date: this.centerDate,
				theme: this.theme
			})];
			// Sync with Day band
			this.bandInfos[0].syncWith = 1;
			this.bandInfos[2].syncWith = 1;
			this.bandInfos[3].syncWith = 1;

			// Highlight month & year bands
			this.bandInfos[0].highlight = false;
			this.bandInfos[1].highlight = false;
			this.bandInfos[2].highlight = true;
			this.bandInfos[3].highlight = true;

			var start_date = new ETLDate(this.startDate, 'gregorian').getOutDate();
			var end_date = new ETLDate(this.endDate, 'gregorian').getOutDate();

			ETDebug.log("band start, end dates: " + start_date + " - " + end_date);
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
		// What exactly does this do??  Caused big bugs in IE
		/*
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
*/
		_handleBandScrolling: function() {
			Timeline._Band.prototype._onMouseUp = function(B, A, C) {
				this.setDragging(false);
				this._keyboardInput.focus();
				ETDebug.onpage("onMouseUp");

				that.timeline._onScroll();
			};
			// The line below causes infinite onScroll/redraw loop in IE...find alternative!
			//this.timeline.getBand(1).addOnScrollListener(this._onMouseScroll.bindAsEventListener(this));
		},
		_handleUIEvents: function() {
			// Hide tooltip on any click
			//document.observe('click', function(e) { Tips.hideAll(); });
			// Handle event list mouseovers
			document.observe('event_list_item:hover', function(e) {
				ETUI.onEventListItemMouseOver(e.element());
			});
			document.observe('event_icon:hover', function(e) {
				ETUI.onEventIconMouseOver(e.element());
			});
			ETUI.createSearchClickHandlers(this);
		},
		_setReqDates: function() {
			this.currentDate = new Date();
			this.tlMinDate = new Date();
			this.tlMaxDate = new Date();
			this.centerDate = new Date();
			this.tlMinDate.setMonth(this.tlMinDate.getMonth() - 1);
			this.tlMaxDate.setMonth(this.tlMaxDate.getMonth() + 1);
			this._eventsLoading(this.currentDate);
		},
		_setCenterDate: function(date) {
			this.currentDate = this.centerDate = date;
		},
		_getTitleFromDate: function(date, type) {
			return (date.getMonthName() + " " + date.getFullYear() + " " + type);
		},
		_onScroll: function() {
			var band;
			var tlMinDate;
			var tlMaxDate;
			var currCenterDate;

			band = this.timeline.getBand(1);
			currCenterDate = this.centerDate;
			this._setCenterDate(band.getCenterVisibleDate());

			if (this.disableSearch) {
				return;
			}

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
				ETDebug.log("onmouseup to new month: " + this.centerDate);
				this.updateEvents({
					startDate: this.centerDate
				});
			} else {
				// Recreate tooltips on every scroll, timleline loses them somehow if you scroll too far
				ETDebug.onpage("redrawing from _onScroll");
				this.redraw();
			}
		},
		// This gets called during any screen updates in IE
		// Need to guard against infinite loops bug in IE.
		_onMouseScroll: function() {
			if (!this.timeline._dragging && !this.inScrollTo) {
				ETDebug.onpage("_onMouseScroll");
				this._onScroll();
			}
		},
		// Takes array of dates & determines which date to scroll to based on search type
		_getScrollToDate: function(dates) {
			dates.sort();
			return (this.seeking === 'future') ? dates[0] : dates.pop();
		},
		_updateTitles: function(d) {
			that.artifactSection.updateTitle(this._getTitleFromDate(d, "Artifacts"));
			that.eventSection.updateTitle(this._getTitleFromDate(d, "Events"));
			that.monthSelector.update(d);
		},
		_loadCached: function() {
			this.scrollTo(this.centerDate);
		},
		_create: function() {
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

				this.showBackupMessage = function() {
					message.containerDiv.style.display = "block";
				};
				this.hideBackupMessage = function() {
					message.containerDiv.style.display = "none";
				};
			};
			/*
			 * ============== END */
			// Setup click handler for timeline events
			Timeline.OriginalEventPainter.prototype._showBubble = function(x, y, evt) {
				// Should fire click() on matching event list target link
				if ((li = ETemplates.getEventListItemEl(evt.getEventID())) !== undefined) {
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
			};
		},
		// Add search results to timeline event source
		_addEvents: function(events) {
			var tooltip_el;

			if ((events != null) && (events.length > 0)) {
				ETDebug.log("adding events to timeline");
				events.each(function(event) {
					ETDebug.dump(event);
					this.eventSource.add(ETimelineEvent(event));
				}.bind(this));
				// Force timeline to redraw so that events show up
				this.eventSource._listeners.invoke('onAddMany');
				this.redraw();
			}
		},
		// Update events titles & show loading html
		_eventsLoading: function(d) {
			// Before [re]creating DOM, remove existing in-memory observers & Tips
			ETUI.onEventSectionLoading();

			ETDebug.log("loading events & artifacts for: " + d);
			this._updateTitles(d);
			that.artifactSection.showLoading();
			that.eventSection.showLoading();
		},
		
		// Required due to bug in timeline that kills tooltips after they go out of bounds
		redraw: function() {
			ETDebug.onpage('in redraw');
			// Required flag for IE onScroll bug
			ETUI.createTimelineEventIconObservers();
		},
		init: function() {
			SimileAjax.History.enabled = false;
			this._getMemberAge();
			this._setReqDates();
			this._setupTheme();
			this._setupBands();
			this._create();
			// Causes horrible bug in IE where layout() constantly updates center date.
			// this._handleWindowResize();
			this._handleBandScrolling();
			this._handleUIEvents();

			this.assignObject();
			this.searchEvents();
		},
		assignObject: function() {
			that.timeline = this;
		},
		onSearching: function() {
			this.timeline.showLoadingMessage();
		},
		hideLoading: function() {
			this.timeline.hideLoadingMessage();
		},
		onSearchError: function() {
			this.searchInProgress = false;
			this.hideLoading();
			ETemplates.showError("An error occurred fetching your timeline data.  Please refresh the page.");
			this.rawEvents.populateResults(this.currentDate);
			//TODO: display errors
		},
		onEventSearchSuccess: function(results) {
			this.searchInProgress = false;
			this.hideLoading();
			ETemplates.hideError();
			// Add to timeline, events & artifacts
			this.parseSearchResults(results);
		},
		onProximitySearchSuccess: function(results) {
			this.searchInProgress = false;
			this.hideLoading();
			this.parseProximitySearchResults(results);
		},
		// On date nav button click or past/future events search
		onNewDate: function(newDate) {
			this.scrollTo(newDate, {
				populate: false
			});
			this.updateEvents({
				startDate: newDate
			});
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
				options: {
					proximity: past_or_future
				}
			});
		},
		searchEvents: function(params) {
			//var params = {startDate: this.startDate, endDate: this.endDate, options: this.options}
			var p = Object.extend({
				startDate: this.currentDate,
				endDate: this.currentDate,
				options: this.options,
				range: true,
				onComplete: this.onEventSearchSuccess
			},
			params);

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
			if (p.range && searchCache.hasDates(p.startDate, p.endDate)) {
				this._loadCached();
			} else {
				if (!this.searchInProgress) {
					// Add dates to cache so we don't repeat ajax call
					searchCache.addDates(p.startDate, p.endDate);

					// Start Ajax search process - callbacks will handle response
					this.searchInProgress = true;
					new ETLSearch(this, p);
				}
			}
		},
		parseSearchResults: function(results) {
			var groupedEvents;
			var newDate;

			ETDebug.log("Parsing search results: parseSearchResults");
			// Parse json results & save
			this.rawEvents.addEvents(results);
			this.rawEvents.populateResults(this.currentDate);

			// Add new duration events to timeline, each duration event only needs to be added once
			this._addEvents(this.rawEvents.getDurationEvents());
			// Add events (grouped by day,type) to timeline 
			if ((groupedEvents = this.rawEvents.getEventGroups()).length > 0) {
				this._addEvents(groupedEvents);
				// Center timeline on latest new event or 1st or last
				newDate = this._getScrollToDate(groupedEvents.pluck('start_date')).toDate();
				// auto scroll within the search results month if necessary
				if (!newDate.equalsDay(this.currentDate) && (newDate.equalsYearMonth(this.currentDate))) {
					ETDebug.log("auto scrolling to " + newDate);
					this.scrollTo(newDate);
				}
			}
			/*
			// Hides any tooltip on click (required to hide on tooltip element link click)
			$$('a').each(function (e) {
				e.observe('click', function(e) { Tips.hideAll(); });
			});
			*/
			this.seeking = null;
		},
		parseProximitySearchResults: function(results) {
			var parsed = results.evalJSON();
			var evt;
			var dates = [];
			var date;

			// Get closest date
			if (parsed && (parsed.resultCount > 0)) {
				for (var i = 0; i < parsed.results.length; i++) {
					dates.push(ETEvent.createSource(parsed.results[i]).getEventDate());
				}
				// Use 1st result since we just want the date
				date = this._getScrollToDate(dates).toDate();
				ETDebug.log('got proximity date = ' + date);
				this._setCenterDate(date); // confusing
				this.updateEvents({
					startDate: date,
					endDate: date
				});
			} else {
				ETDebug.log('no results from proximity search');
				this.rawEvents.populateResults(this.currentDate);
			}
		},
		scrollTo: function(date, opts) {
			opts = Object.extend({
				populate: true
			},
			opts);
			ETDebug.onpage("Scrolling to date " + date);

			this.inScrollTo = true;
			this.timeline.getBand(1).setCenterVisibleDate(date);
			this._setCenterDate(date);
			this._updateTitles(date);
			if (opts.populate) {
				ETDebug.onpage("scrollTo populating results");
				this.rawEvents.populateResults(date);
				this.redraw();
			}
			this.inScrollTo = false;
		},
		reload: function(opts) {
			opts = opts || {};
			searchCache.empty();
			that.artifactSection.empty();
			this.rawEvents.empty();
			this.eventSource.clear();
			if (opts.today) {
				this.onNewDate(new Date());
			} else {
				this.searchEvents({options: opts});
			}
		}
	});

	var draw = function() {
		that.monthSelector = new ETLMonthSelector(options.month_selector_id);
		that.artifactSection = new ETLArtifactSection(options.artifact_section_id);
		that.eventSection = new ETLEventSection(options.events_section_id);
		that.base = new ETLBase(options.timeline_section_id, options.timeline);
	};
	var reload = function(opts) {
		opts = Object.extend({no_cache: true}, opts||{});
		that.base.reload(opts);
	};
	// Set public methods now
	me.draw = draw;
	me.reload = reload;
	me.api = api;

	// Return 'class' object with only public methods exposed.
	return me;
};

// Helper to create & draw timeline 
function drawETimeline() {
	// Create timeline
  ETERNOS.timeline = new ETimeline({month_selector_id: 'month-selector',
    artifact_section_id: 'artifacts-header',
    events_section_id: 'events',
    timeline_section_id: 'my-timeline',
    timeline: {
      memberID: ETERNOS.user_id, 
      startDate: ETERNOS.tl_start_date, 
      endDate: ETERNOS.tl_end_date, 
      options: {
        max_results: 100,
        fake: ETERNOS.fake_timeline
      }
    }
  });
  ETERNOS.timeline.draw();
}
