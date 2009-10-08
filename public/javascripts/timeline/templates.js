// $Id$

var DefaultTooltipOptions = {
  width: '400px',
  border: 6,
  borderColor: '#74C5FF',
	fixed: true,
  hideOthers: true,
  viewport: true
};
var eventTooltipOptions = {
	hook: {
    target: 'topRight',
    tip: 'bottomLeft'
  },
  stem: 'bottomLeft',
  fixed: true,
	hideOn: { element: 'tip', event: 'mouseout' }
};
var timelineTooltipOptions = {
	hook: {
    target: 'bottomRight',
    tip: 'topLeft'
  },
  stem: 'topLeft'
};

var ETemplates = {
		// Events section templates
		eventListTemplates: {
			events: function () {
				return new Template('<div id="events_header"><p class="details_box_title">#{title}</p></div>' + 
					'<div id="events_list">#{events}</div>');
			},
			eventGroup: function () {
				return new Template('<div class="event_list_group_#{odd_or_even}"><div class="event_list_date">#{date}</div>' + 
					'<ul class="event_list_group">#{body}</ul><div style="clear:both"></div></div>');
			},
			hiddenItem: function () {
				return new Template('<a href="#{link_url}" class="lightview" rel="#{link_rel}"></a>');
			},
			eventItemWithTooltip: function () {
				return new Template('<li id="evli:#{list_item_id}" class="event_list_item">' +
					'<div class="event_list_item_container">' +
					'<a href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">#{title}</a>#{hidden_items}' + 
					'<div class="tooltip_container"><p/>#{tt_content}</div></div><div style="clear:both"></div></li>');
			},      
			eventItemTooltipItem: function () {
				return new Template('<div class="event_preview_item_container tooltip_container"><a href="#{event_details_link}" onclick="Tips.hideAll(); return true;" class="lightview tooltip_item" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}" rel="iframe">#{content}</a></div><br/>');
			},
			inlineEvents: function() {
				return new Template('<div id="#{id}">#{content}</div>');
			},
			tooltipTitle: function(){
			  return new Template("<img style='width:12px;height:12px;' src='/javascripts/timeline/icons/#{icon}'>&nbsp;#{title}");
			},
			detailsLink: function() {
				return new Template('tl_details/#{memberId}/#{eventType}/#{eventIds}');
			},
			noEvents: function() {
				return new Template('<div class="event_list_group_even">' + 
					'No events for this month.&nbsp;&nbsp;' + 
					'<a class="event_preview_item_container" href="#" id="prev_event_search">Previous events</a>&nbsp;&nbsp;<a href="#" id="next_event_search" class="event_preview_item_container">Next events</a>' +
					'</div>');
			},
			createEventItemTooltips: function() {
				// Create tooltip for each event list link
				// var title;      
				$$('a.event_list_inline_item').each(function (element) {
	        s = element.next('div.tooltip_container');
	        s.hide();
          DefaultTooltipOptions.title = element.innerHTML;
					if (DefaultTooltipOptions.title.match('Image')) {
						DefaultTooltipOptions.width = 'auto';
					}
	        new Tip(element, s, Object.extend(DefaultTooltipOptions, eventTooltipOptions));
					// Add observer to hide it on click
					element.observe('click', function(e) {
						element.prototip.hide();
						return true;
					});
	      });
			},
			createTimelineTooltips: function() {
				var ev;
				
				// Create tooltip for each timeline point
				$$('.timeline-event-icon').each(function(element) {
					ev = Timeline.EventUtils.decodeEventElID(element.id).evt;
					DefaultTooltipOptions.title = ev.collection._getTooltipTitle();
					if (ev.collection.first.isArtifact()) {
						DefaultTooltipOptions.width = 'auto';
					}
					new Tip(element, ev.collection._getTooltipContents(), Object.extend(DefaultTooltipOptions, timelineTooltipOptions));
				});
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
		},
		// Artifacts section templates
		artifactTemplates: {
			artifacts: function () {
				return new Template("<div class=\"artibox-top\"><p class=\"details_box_title\">#{title}</p></div>" + "<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" + "<img src=\"/images/artibox-bottom.gif\" /></div>");
			},
			artifactBox: function () {
				return new Template('<li id="etl-artifact-item-#{num}" #{style}><a id="art:#{id}" href="#{url}" class="lightview etl-artifact-link" rel="set[artifacts]" title="#{caption} :: :: slideshow: true, autosize: true"><img src="#{thumbnail_url}" class="arti-thumb"/></a></li>');
			}
		},
		dateSelectorTemplate: function() {
			return new Template('<a id="month_selector_down"" href="#" class="btn-left"></a><span class="subtitle6">#{month}</span><a id="month_selector_up" href="#" class="btn-right"></a><a id="year_selector_down" href="#" class="btn-left"></a><span class="subtitle7">#{year}</span><a id="year_selector_up" href="#" class="btn-right"><div style="clear: both"></div>');
		},
		eventSelectorTemplate: function() {
			return new Template('<a id="prev_event" href="" class="btn-left"></a><span class="subtitle7">&nbsp;Most&nbsp;Recent&nbsp;</span><a id="next_event" href="#" class="btn-right">');
		},
		loadingTemplate: function() {
		  return new Template("<div><span>Loading #{type}...</span></div>");
		},
		event_list_item: function(id) {
			return $("evli:" + id);
		},
		// For Eternos custom event sizing based on frequency
		// n = frequency of event
		getIconSize: function(n) {
		  var r;
		  if (n <= 1) {
		    r=16;
		  } else if (n <= 5) {
		    r=20;
		  } else if (n <= 10) {
		    r=25;
		  } else {
		    r=30;
		  }
		  return r;
		}
};
