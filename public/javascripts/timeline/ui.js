// $Id$
//
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
