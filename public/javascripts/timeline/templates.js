// $Id$

var DefaultTooltipOptions = {
	fixed: true,
  width: 'auto',
  hideOthers: true,
  viewport: true,
  hook: {
    target: 'topRight',
    tip: 'bottomLeft'
  },
  stem: 'bottomLeft'
};

var ETemplates = {
		// Events section templates
		eventListTemplates: {
			events: function () {
				return new Template("<div class=\"storybox-top\"><div class=\"title5\">#{title}</div></div>" + "<div class=\"storybox\">#{events}</div><img src=\"/images/storybox-bottom.gif\" /></div>");
			},
			eventGroup: function () {
				return new Template('<div class="event_list_group"><div class="event_list_date">#{date}</div>' + '<div class="event_list_group_items"><ul>#{body}</ul></div></div>');
			},
			hiddenItem: function () {
				return new Template('<a href="#{link_url}" class="lightview" rel="#{link_rel}"></a>');
			},
			eventItemWithTooltip: function () {
				return new Template('<li class="event_list_item"><div class="event_list_item_container"><a href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: :: fullscreen: true">#{title}</a>#{hidden_items}' + 
					'<div id="#{tt_id}"><span class="tooltip_title"><b>#{title}</b></span><p/><br/>#{tt_content}</div>#{inline_content}</li>');
			},
			eventItemTooltipItem: function () {
				return new Template('<div class="event_preview_item_container">#{content}</div>');
			},
			inlineEvents: function() {
				return new Template('<div id="#{id}">#{content}</div>');
			},
			createEventItemTooltips: function() {
				// Create tooltip for each event list link
				var title;
				$$('a.event_list_inline_item').each(function (element) {
	        s = element.next('div');
	        s.hide();
				
	        new Tip(element, s, DefaultTooltipOptions);
	      });
			},
			createTimelineTooltips: function() {
				var tooltip_id;
				// Create tooltip for each timeline point
				$$('.tl_event[title]').each(function(e) {
					tooltip_id = e.readAttribute('title');
					if ($(tooltip_id)) {
						console.log("Adding tooltip to event id " + tooltip_id);
						// MUST use innerHTML instead of element, b/c of duplicate tooltips effect  
						// (in event list) will cause the 1st tooltip to cancel the other one out
						new Tip(e, $(tooltip_id).innerHTML, DefaultTooltipOptions);
					}
					/*
					Event.observe(e, 'click', function(ev) {
						ev.stop();
						if (details_link = $('event_details_link:' + tooltip_id)) {
							eval(details_link.href);
						}
					});
					*/
				});
			}
		},
		// Artifacts section templates
		artifactTemplates: {
			artifacts: function () {
				return new Template("<div class=\"artibox-top\"><div class=\"title5\">#{title}</div></div>" + "<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" + "<img src=\"/images/artibox-bottom.gif\" /></div>");
			},
			artifactBox: function () {
				return new Template("<li id=\"etl-artifact-item-#{num}\" #{style}><a href=\"#{url}\" " + "class=\"lightview\" rel=\"set[artifacts]\" title=\"#{caption} :: :: slideshow: true, autosize: true, fullscreen: true\"><img src='#{thumbnail_url}' class='thumnails2'/></a>" + "</li>");
			}
		},
		monthSelectorTemplate: function() {
			return new Template("<a href=\"\" id=\"month_selector_down\" class=\"btn-left\"></a><span class=\"subtitle6\">#{month}</span><span class=\"subtitle7\">#{year}</span><a href=\"\" id=\"month_selector_up\" class=\"btn-right\"></a>");
		},
		loadingTemplate: function() {
		  return new Template("<div><span>Loading #{type}...</span></div>");
		}
};
