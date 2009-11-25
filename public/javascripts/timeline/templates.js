// $Id$

function ajaxDisplayTooltipItemDetails(el, url) {
	new Ajax.Updater(el, url, {
		method: 'get',
		onLoading: function() { spinner.load(el); },
		onSuccess: function(transport) {
			new Effect.Highlight(el);
		},
		onComplete: function() { spinner.unload(); }
	});
	/*
	new Effect.SlideUp(el, {duration: 1.0});
	new Ajax.Request(url, {
		method: 'get',
		evalJS: true,
		onSuccess: function(transport){
		    new Effect.SlideDown(el, {
		      queue: 'end',
					duration: 1.0,
		      beforeSetup: function() {
						// TODO: Need way to eval dom for behaviors, otherwise this is useless!
		        $(el).innerHTML=transport.responseText;
		      }
		    });
		 }
	});
	*/
}

var ETemplates = function() {
	var that = {};

	var tooltipItemHoverHTML = '<div class="tip-hover-menu"><ul id="tip-hover-menu-items">' +
			'<li><a href="#{event_details_link}" onclick="ajaxDisplayTooltipItemDetails(\'item_details\', \'#{event_details_link}\'); return false;">' +
			'<img src="/images/page-edit-icon-16.png" border="0" alt="Edit Item">Edit</a></li>' + 
			'<li><a href="#{event_delete_link}"><img src="/images/delete-icon-16.png" alt="Delete Item" border="0">Delete</a></li></ul>' + 
		'</div>';
		
	that.utils = function() {
		return {
			emptyResponse: "{\"results\": [], \"previousDataUri\": null, \"responseDetails\": null, \"request\": \"\", \"resultCount\": 0, \"status\": 200, \"futureDataUri\": null}",
			assetUrl: "/javascripts/timeline/",
			imgUrl: "icons/",
			iconPostfix: "",
			blankArtifactImg: "<div style=\"padding-left:5px;margin-top:5px;\"><img src=\"/images/blank-arftifacts.gif\"></div>",
			tlEffectiveWidth: 750
		};
	}();
	that.defaultTooltipWidth =function(type) {
		if (type === 'photo') {
			return '120px';
		} else if (type === 'web_video') {
			return '340px';
		} else {
			return 'auto';
		}
	};
	that.defaultTooltipOptions = function() {
		return {
			border: 6,
			borderColor: '#74C5FF',
			hideOthers: true,
			viewport: true,
			closeButton: true,
			fixed: true,
			hideOn: {
				element: 'tip',
				event: 'mouseout'
			}
		};
	};
	that.eventTooltipOptions = function() {
		return {
			hook: {
				target: 'topMiddle',
				tip: 'bottomMiddle'
			},
			stem: 'bottomMiddle'
		};
	};
	that.timelineTooltipOptions = function() {
		return {
			hook: {
				target: 'bottomRight',
				tip: 'topLeft'
			},
			stem: 'topLeft'
		};
	};
	that.timelineTooltipOptionsLeft = function() {
		return {
			hook: {
				target: 'bottomLeft',
				tip: 'topRight'
			},
			stem: 'topRight'
		};
	};
	that.timelineDurationTooltipOptions = function() {
		return {
			hook: {
				tip: 'topLeft',
				mouse: true
			}
		};
	};
	// Events section templates
	that.eventListTemplates = {
		events: function() {
			return new Template('<div id="events_header"><p class="details_box_title">#{title}</p></div>' + '<div id="events_list">#{events}</div>');
		} (),
		eventGroup: function() {
			return new Template('<div class="event_list_group_#{odd_or_even}"><div class="event_list_date">#{date}</div>' + '<ul class="event_list_group">#{body}</ul><div style="clear:both"></div></div>');
		} (),
		hiddenItem: function() {
			return new Template('<a href="#{link_url}" class="lightview" rel="#{link_rel}"></a>');
		} (),
		eventGroupItem: function() {
			return new Template('<li class="event_list_item">' + '<div class="event_list_item_container">' + '<a id="evli:#{list_item_id}" href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">#{title}</a>' + '</div><div style="clear:both"></div></li>');
		} (),
		eventItemWithTooltip: function() {
			return new Template('<li class="event_list_item">' + '<div class="event_list_item_container">' + '<a id="evli:#{list_item_id}" href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">#{title}</a>#{hidden_items}' + '<div id="evlitt:#{list_item_id}" class="tooltip_container" style="display:none"><p/>#{tt_content}</div></div><div class="clear"></div></li>');
		} (),
		eventItemTooltipItem: function() {
			// Lightview popup on click
			return new Template('<div class="event_preview_item_container tooltip_container">' +
				// Lightview on click
				//'<a href="#{event_details_link}" onclick="Tips.hideAll(); return true;" class="lightview tooltip_item" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}" rel="iframe">#{content}</a>' +
				// Ajax-populate div on click
				//'<a href="#{event_details_link}" onclick="new Ajax.Updater(\'item_details\', \'#{event_details_link}\', {asynchronous:true, evalScripts:true, method:\'get\'}); return false;" class="tooltip_item">#{content}</a>' +
				'<div class="tooltip_item">#{content}</div>' +
				tooltipItemHoverHTML + '</div><br/>');
		} (),
		mediaTooltip: function() {
			return new Template('<div class="event_preview_item_container"><div id="playlist">#{playlist}</div></div>');
		} (),
		mediaPlaylistItem: function() {
			return new Template('<div class="tooltip_container">' +
				'<div class="playlist_item tooltip_item"><a href="#{url}"><img src="#{thumbnail_url}"/><strong>#{title}</strong><br/><br/>#{description}<em>#{duration}</em><br/>#{time}</a></div>' +
				tooltipItemHoverHTML + '</div>');
		} (),
		inlineEvents: function() {
			return new Template('<div id="#{id}">#{content}</div>');
		} (),
		tooltipTitle: function() {
			return new Template("<img style='width:12px;height:12px;' src='/javascripts/timeline/icons/#{icon}'>&nbsp;#{title}");
		} (),
		detailsLink: function() {
			return new Template('tl_details/#{memberId}/#{eventType}/#{eventIds}');
		} (),
		noEvents: function() {
			return new Template('<div class="event_list_group_even">' + 'No events for this month.</div>');
		} ()
	};
	that.tooltipTemplates = {
		activity_stream_item: function() {
			return new Template('<div class="tooltip_as">#{message}#{time}#{author}#{source}#{media}</div>');
		} (),
		image: function() {
			return new Template('<img src="#{img_url}"><br/>#{caption}<br/>');
		} (),
		feed: function() {
			return new Template('<div class="tooltip_feed">#{preview}#{message}#{source}#{time}</div>');
		} (),
		video: function() {
			return new Template('<div class="tooltip_video"><a class="video_thumb lightview" href="##{id}" rel="inline" title="#{title}"><img src="#{thumbnail_url}" width="#{thumb_width}" height="#{thumb_height}" alt="Click to view" style="float:left"></a><div class="video_player" id="#{id} url="#{video_url} rel="{hidden: true, autoPlay: true, filename: false}"></div>#{message}#{duration}#{time}</div><div class="clear"></div>');
		} (),
		address: function() {
			return new Template('<div class="tooltip_address">#{postal}<br/><span>Type: #{type}</span><br/><span>#{dates}</span></div>');
		} (),
		school: function() {
			return new Template('<div class="tooltip_school">#{name}<br/><br/><span>#{dates}</span></div>');
		} (),
		job: function() {
			return new Template('<div class="tooltip_job">#{company}<br/>#{title}<br/><span>#{dates}</span></div>');
		} (),
		family: function() {
			return new Template('<div class="tooltip_family">#{name}<br/>#{relationship}</div>');
		} (),
		medical: function() {
			return new Template('<div class="tooltip_medical">#{condition}<br/><span>#{dates}</span></div>');
		} (),
		medicalCondition: function() {
			return new Template('<div class="tooltip_medical">#{condition}<br/><span>#{dates}</span></div>');
		} (),
		single_line_small: function() {
			return new Template('<br/><span class="event_time">#{text}</span>');
		} ()
	};
	// Artifacts section templates
	that.artifactTemplates = {
		artifacts: function() {
			return new Template("<div class=\"artibox-top\"><p class=\"details_box_title\">#{title}</p></div>" + "<div class=\"artibox\"><ul id=\"etl-artifact-items\" style=\"list-style-type:none\">#{artifacts}</ul></div>" + "<img src=\"/images/artibox-bottom.gif\" /></div>");
		} (),
		artifactBox: function() {
			return new Template('<li id="etl-artifact-item-#{num}" #{style}><a id="art:#{id}" href="#{url}" class="lightview etl-artifact-link" rel="set[artifacts]" title="#{caption} :: :: slideshow: true, autosize: true"><img src="#{thumbnail_url}" class="arti-thumb"/></a></li>');
		} ()
	};
	that.eventSelectorTemplate = function() {
		return new Template('<a id="prev_event" href="" class="btn-left"></a><span class="subtitle7">&nbsp;Most&nbsp;Recent&nbsp;</span><a id="next_event" href="#" class="btn-right">');
	} ();
	that.loadingTemplate = function() {
		return new Template("<div><span>Loading #{type}...</span></div>");
	} ();
	that.event_list_item = function(id) {
		return $("evli:" + id);
	} ();
	// For Eternos custom event sizing based on frequency
	// n = frequency of event
	that.getIconSize = function(n) {
		var r;
		if (n <= 1) {
			r = 20;
		} else if (n <= 5) {
			r = 25;
		} else if (n <= 10) {
			r = 30;
		} else {
			r = 40;
		}
		return r;
	};
	return that;
}();
