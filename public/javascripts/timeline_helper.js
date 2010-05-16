// $Id$
//
// Timeline javascript module

// Load dependencies
SimileAjax.includeJavascriptFiles(document, '/javascripts/timeline/', ['events.js', 'templates.js', 'media.js', 'utils.js', 'ui.js', 'event_items.js', 'artifacts.js', 'date_selectors.js']);

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

	////////////////////////////////////////////////////////////////////////////////////////
	//
	// Eternos Timeline Event Section
	//
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

	////////////////////////////////////////////////////////////////////////////////////////
	//
	// Eternos Timeline Event Collection
	//
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
			// Generate html for each day with events
			activeDates.sort(orderDatesDescending).each(function(d, rowIndex) {
				itemsHtml = '';
				dateItems.clear();
				currentItems = this._groupItemsByType(this.rawItems[d]);

				// Generate html for each event type
				currentItems.each(function(group, index) {
					events = new ETLEventItems(group, {
						memberID: that.memberID
					});
					dateItems.push(events); // Save all items grouped by date
					
					// Skip image events - these get added by _getGroupImagesHtml()
					if (true || !events.isArtifacts()) {
						this.items.push(events);
						itemsHtml += events.populate();
					}
				}.bind(this));

				html += this.groupTemplate.evaluate({
					date: this._eventDate(d),
					odd_or_even: ((rowIndex % 2) === 0 ? 'even' : 'odd'),
					body: itemsHtml,
					images: '' // disabled for now this._getGroupImagesHtml(d)
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
		_getGroupImagesHtml: function(date) {
			// Collect all artifacts from date's collection
			var upTo, i, imageHtml;
			var images = that.artifactSection.itemsInDate(date);
			
			images = images.flatten();
			if (images.size() > 0) {
				// collect 1st 3 images
				upTo = Math.min(images.size(), 3);
				imageHtml = '';
				for (i=0; i<upTo; i++) {
					imageHtml += ETemplates.eventListTemplates.eventGroupArtifact.evaluate({
						date: date,
						url: images[i].getURL(),
						thumbnail: images[i].getThumbnailURL(),
						caption: images[i].getTitle() 
						});
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
			return '';
			//'<a href="javascript: void(0);">View All</a>';
		}
	});

	////////////////////////////////////////////////////////////////////////////////////////
	//
	// Eternos Timeline Event Parser
	//
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
					ETDebug.log("adding event with attached artifact to artifacts");
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

	////////////////////////////////////////////////////////////////////////////////////////
	//
	// Eternos Timeline Search. init: timeline object and {startDate: 'sring date', endDate: 'string date', options: Object}
	//
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
			var tl = this;
			ETDebug.log("onSearching");
			this.timeline.showLoadingMessage();
			// Make sure shit gets turned off in case of IE fuckup.
			// 10 secs. should be long enough
			setTimeout(function() { tl.hideLoading(); }, 10000);
		},
		hideLoading: function() {
			ETDebug.log('hideLoading');
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
	var getBase = function() {
		return that.base;
	}
	// Set public methods now
	me.draw = draw;
	me.reload = reload;
	me.api = api;
	me.getBase = getBase;

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
