// $Id$

var DefaultTooltipOptions = {
  width: '400px',
  border: 6,
  borderColor: '#74C5FF',
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
			eventItemWithTooltipOLD: function () {
				return new Template('<li id="evli:#{list_item_id}" class="event_list_item"><div class="event_list_item_container"><a  href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: :: fullscreen: true">#{title}</a>#{hidden_items}' + 
					'<div class="tooltip_container"><span class="tooltip_title"><b>#{title}</b></span><p/><br/>#{tt_content}</div>#{inline_content}</li>');
			},
			eventItemWithTooltip: function () {
				return new Template('<li id="evli:#{list_item_id}" class="event_list_item"><div class="event_list_item_container"><a  href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: :: fullscreen: true">#{title}</a>#{hidden_items}' + 
					'<div class="tooltip_container"><p/>#{tt_content}</div>#{inline_content}</li>');
			},      
			eventItemTooltipItem: function () {
				return new Template('<div class="event_preview_item_container">#{content}</div>');
			},
			inlineEvents: function() {
				return new Template('<div id="#{id}">#{content}</div>');
			},
			tooltipTitle: function(){
			  return new Template("<img style='width:12px;height:12px;' src='/javascripts/timeline/icons/#{icon}'> &nbsp;&nbsp;#{title}");
			},
			createEventItemTooltips: function() {
				// Create tooltip for each event list link
				// var title;      
				$$('a.event_list_inline_item').each(function (element) {
	        s = element.next('div.tooltip_container');
	        s.hide();
          DefaultTooltipOptions.title = element.innerHTML;
	        new Tip(element, s, DefaultTooltipOptions);
	      });
			},
			createTimelineTooltips: function() {
				var item_id;
				var element;
				var title;
				// Create tooltip for each timeline point
				$$('.tl_event[title]').each(function(e) {
					item_id = e.readAttribute('title');
					if (li = $("evli:" + item_id)) {
						// This is pretty weak...
						if (li.childElements().length > 0) {
							element = li.childElements()[0];
							if (tt = element.down('div.tooltip_container')) {
								DefaultTooltipOptions.title = element.down('a.event_list_inline_item').innerHTML;
								//console.log("Adding tooltip to event id " + item_id);
								// MUST use innerHTML instead of element, b/c of duplicate tooltips effect  
								// (in event list) will cause the 1st tooltip to cancel the other one out
								new Tip(e, tt.innerHTML, DefaultTooltipOptions);
							}
						}
					}
				});
			},
		},
		// Artifacts section templates
		artifactTemplates: {
			artifacts: function () {
				return new Template("<div class=\"artibox-top\"><div class=\"title5\">#{title}</div></div>" + "<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" + "<img src=\"/images/artibox-bottom.gif\" /></div>");
			},
			artifactBox: function () {
				return new Template('<li id="etl-artifact-item-#{num}" #{style}><a id="art:#{id}" href="#{url}" class="lightview etl-artifact-link" rel="set[artifacts]" title="#{caption} :: :: slideshow: true, autosize: true"><img src="#{thumbnail_url}" class="thumnails2"/></a></li>');
			},
		},
		dateSelectorTemplate: function() {
			return new Template("<a id=\"month_selector_down\" href=\"\" class=\"btn-left\"></a><span class=\"subtitle6\">#{month}</span><a id=\"month_selector_up\" href=\"\" class=\"btn-right\"></a><a id=\"year_selector_down\" href=\"\" class=\"btn-left\"></a><span class=\"subtitle7\">#{year}</span><a id=\"year_selector_up\" href=\"\" class=\"btn-right\"></a><div style=\"clear: both\"></div>");
		},
		loadingTemplate: function() {
		  return new Template("<div><span>Loading #{type}...</span></div>");
		},
		event_list_item: function(id) {
			return $("evli:" + id);
		}
};
