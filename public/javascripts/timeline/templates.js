// $Id$

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
				return new Template('<li class="event_list_item"><div class="event_list_item_container"><a href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: :: fullscreen: true">#{title}</a>#{hidden_items}' + '<span>#{tooltip_content}</span>#{inline_content}</li>');
			},
			eventItemTooltipItem: function () {
				return new Template('<div class="event_preview_item_container">#{content}</div>');
			},
			inlineEvents: function() {
				return new Template('<div id="#{id}">#{content}</div>');
			}
		},
		// Artifacts section templates
		artifactTemplates: {
			artifacts: function () {
				return new Template("<div class=\"artibox-top\"><div class=\"title5\">#{title}</div></div>" + "<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" + "<img src=\"/images/artibox-bottom.gif\" /></div>");
			},
			artifactBox: function () {
				return new Template("<li id=\"etl-artifact-item-#{num}\" #{style}><a href=\"#{url}\" " + "class=\"lightview\" rel=\"set[artifacts]\" title=\":: :: slideshow: true, autosize: true, fullscreen: true\"><img src='#{thumbnail_url}' class='thumnails2'/></a>" + "</li>");
			}
		}
};