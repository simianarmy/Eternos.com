// $Id$

var ETemplates = {
	// This should be in templates.js
	utils: function() {
		return {
			emptyResponse: "{\"results\": [], \"previousDataUri\": null, \"responseDetails\": null, \"request\": \"\", \"resultCount\": 0, \"status\": 200, \"futureDataUri\": null}",
			assetUrl: "/javascripts/timeline/",
			imgUrl: "icons/",
			iconPostfix: "",
			blankArtifactImg: "<div style=\"padding-left:5px;margin-top:5px;\"><img src=\"/images/blank-arftifacts.gif\"></div>",
			tlEffectiveWidth: 750
		}
		}(),
		DefaultTooltipOptions: {
			width: '400px',
			border: 6,
			borderColor: '#74C5FF',
			fixed: true,
			hideOthers: true,
			viewport: true,
			closeButton: true,
			hideOn: { element: 'tip', event: 'mouseout' }
		},
		eventTooltipOptions: {
			hook: {
				target: 'topMiddle',
				tip: 'bottomMiddle'
			},
			stem: 'bottomMiddle',
		},
		timelineTooltipOptions: {
			hook: {
				target: 'bottomRight',
				tip: 'topLeft'
			},
			stem: 'topLeft'
		},
		// Events section templates
		eventListTemplates: {
			events: function () {
				return new Template('<div id="events_header"><p class="details_box_title">#{title}</p></div>' + 
				'<div id="events_list">#{events}</div>');
			}(),
			eventGroup: function () {
				return new Template('<div class="event_list_group_#{odd_or_even}"><div class="event_list_date">#{date}</div>' + 
				'<ul class="event_list_group">#{body}</ul><div style="clear:both"></div></div>');
			}(),
			hiddenItem: function () {
				return new Template('<a href="#{link_url}" class="lightview" rel="#{link_rel}"></a>');
			}(),
			eventGroupItem: function() {
				return new Template('<li class="event_list_item">' +
				'<div class="event_list_item_container">' +
				'<a id="evli:#{list_item_id}" href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">#{title}</a>' + 
				'</div><div style="clear:both"></div></li>');
			}(),
			eventItemWithTooltip: function () {
				return new Template('<li class="event_list_item">' +
				'<div class="event_list_item_container">' +
				'<a id="evli:#{list_item_id}" href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">#{title}</a>#{hidden_items}' + 
				'<div id="evlitt:#{list_item_id}" class="tooltip_container" style="display:none"><p/>#{tt_content}</div></div><div style="clear:both"></div></li>');
			}(),      
			eventItemTooltipItem: function () {
				return new Template('<div class="event_preview_item_container tooltip_container"><a href="#{event_details_link}" onclick="Tips.hideAll(); return true;" class="lightview tooltip_item" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}" rel="iframe">#{content}</a></div><br/>');
			}(),
			inlineEvents: function() {
				return new Template('<div id="#{id}">#{content}</div>');
			}(),
			tooltipTitle: function(){
				return new Template("<img style='width:12px;height:12px;' src='/javascripts/timeline/icons/#{icon}'>&nbsp;#{title}");
			}(),
			detailsLink: function() {
				return new Template('tl_details/#{memberId}/#{eventType}/#{eventIds}');
			}(),
			noEvents: function() {
				return new Template('<div class="event_list_group_even">' + 
				'No events for this month.&nbsp;&nbsp;' + 
				'<a class="event_preview_item_container" href="#" id="prev_event_search">Previous events</a>&nbsp;&nbsp;<a href="#" id="next_event_search" class="event_preview_item_container">Next events</a>' +
				'</div>');
			}()
		},
		tooltipTemplates: {
			activity_stream_item: function() {
				return new Template('<div class="tooltip_as">#{message}#{author}#{time}#{source}#{media}</div>');
			}(),
			image: function() {
				return new Template('<img src="#{img_url}"><br/>#{caption}<br/>');
			}(),
			feed: function() {
				return new Template('<div class="tooltip_feed">#{preview}#{message}#{source}#{time}</div>');
			}(),
			single_line_small: function() {
				return new Template('<br/><span class="event_time">#{text}</span>');
			}()
		},
		// Artifacts section templates
		artifactTemplates: {
			artifacts: function () {
				return new Template("<div class=\"artibox-top\"><p class=\"details_box_title\">#{title}</p></div>" + "<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" + "<img src=\"/images/artibox-bottom.gif\" /></div>");
			}(),
			artifactBox: function () {
				return new Template('<li id="etl-artifact-item-#{num}" #{style}><a id="art:#{id}" href="#{url}" class="lightview etl-artifact-link" rel="set[artifacts]" title="#{caption} :: :: slideshow: true, autosize: true"><img src="#{thumbnail_url}" class="arti-thumb"/></a></li>');
			}()
		},
		dateSelectorTemplate: function() {
			return new Template('<a id="month_selector_down"" href="#" class="btn-left"></a><span id="display_month" class="subtitle6">#{month}</span><a id="month_selector_up" href="#" class="btn-right"></a><a id="year_selector_down" href="#" class="btn-left"></a><span id="display_year" class="subtitle7">#{year}</span><a id="year_selector_up" href="#" class="btn-right"><div style="clear: both"></div>');
		}(),
		eventSelectorTemplate: function() {
			return new Template('<a id="prev_event" href="" class="btn-left"></a><span class="subtitle7">&nbsp;Most&nbsp;Recent&nbsp;</span><a id="next_event" href="#" class="btn-right">');
		}(),
		loadingTemplate: function() {
			return new Template("<div><span>Loading #{type}...</span></div>");
		}(),
		event_list_item: function(id) {
			return $("evli:" + id);
		}(),
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
