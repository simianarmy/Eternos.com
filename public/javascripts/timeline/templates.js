// $Id$


var ETemplates = function() {
	var that = {};

	// Template function helper
	function tooltipItemViewLink(inner) {
		return '<a href="#{event_details_link}" onclick="ETemplates.ajaxDisplayTooltipItemDetails(this, \'item_details\', \'#{event_details_link}\'); return false;">' + 
			inner + '</a>';
	};
	
	var tooltipItemHoverHTML = '<div class="tip-hover-menu"><ul id="tip-hover-menu-items">' +
			'<li><a href="#{event_edit_link}" onclick="ETemplates.ajaxDisplayTooltipItemDetails(this, \'item_details\', \'#{event_edit_link}\'); return false;">' +
			'<img src="/images/page-edit-icon-16.png" border="0" alt="Edit Item">Edit</a></li>' + 
			'<li><a href="#{event_delete_link}" onclick="ETemplates.ajaxDeleteTooltipItem(this, \'#{event_delete_link}\'); return false;"><img src="/images/delete-icon-16.png" alt="Delete Item" border="0">Delete</a></li></ul>' + 
		'</div>';

	// Public functions
	
	that.ajaxDisplayTooltipItemDetails = function (parent, el, url) {
		new Ajax.Updater(el, url, {
			method: 'get',
			evalScripts:true,
			onLoading: function() { spinner.load(parent.up('.tooltip_container')); },
			onSuccess: function(transport) {
				new Effect.ScrollTo(el);
				new Effect.Highlight(el, { queue: 'end' });
			},
			onComplete: function() { 
				spinner.unload();
				Tips.hideAll();  
			}
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
	};
	that.ajaxDeleteTooltipItem = function (parent, url) {
		var container_el;
		if (confirm('Permanently delete this item?')) {
			container_el = parent.up('.tooltip_container');
			
			new Ajax.Request(url, {
				method: 'get',
				evalScripts:true,
				onLoading: function() { spinner.load(container_el); },
				onSuccess: function(transport) {
					new Effect.Fade(container_el);
					that.showNotice('Item successfully deleted', 5);
					window.timeline.reload();
				},
				onComplete: function() {
					spinner.unload();
				}
			});
		}
	};
	
	that.showNotice = function(msg, fade_delay) {
		showFlash('tl_flash_notice', msg, fade_delay);
	};
	that.showError = function(msg, fade_delay) {
		showFlash('tl_flash_error', msg, fade_delay);
	};
	that.hideError = function() {
		$('tl_flash_error').update();
	};
	function showFlash(id, msg, fade_delay) {
		$(id).innerHTML = msg;
		$(id).appear();
		if (fade_delay) {
			setTimeout(function() { new Effect.Fade(id); }, fade_delay*1000);
		}
	};
	
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
		if (type === 'web_video') {
			return '480px';
		} else {
			return '350px';
		}
	};
	that.defaultTooltipOptions = function() {
		return {
			style: 'timeline_preview_default'
		};
	};
	that.videoTooltipOptions = function() {
		return {
			style: 'timeline_preview_default'
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
			return new Template('<h1>#{title}</h1>' + '<ul class="events">#{events}</ul>');
		} (),
		// Event day row
		eventGroup: function() {
			return new Template('<li class="events-#{odd_or_even}"><strong>#{date}</strong>#{body}<p class="event-images">#{images}</p></li>');
		} (),
		eventGroupArtifact: function() {
			return new Template('<a href="#{url}" class="lightview etl-artifact-link" rel="set[evarti_#{date}]" title="#{caption} :: :: slideshow: true, autosize: true"><img src="#{thumbnail}" class="events_artifact" border="0"/></a>');
		} (),
		// Event day row images 
		eventGroupImages: function() {
			return new Template('#{images}<br/><em>Event Images</em> #{view_all_images_link}');
		} (),
		hiddenItem: function() {
			return new Template('<a href="#{link_url}" class="lightview" rel="#{link_rel}"></a>');
		} (),
		// Event day row template
		eventGroupItem: function() {
			// Old: clickable tooltip link with lightview to multiple-item iframe
			// return new Template('<div class="fb-posts">#{caption}<p><em>#{title}</em><a id="evli_#{list_item_id}" href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">View</a></p></div><p class="event-images">#{images}<br/><em>Event Images</em> <a href="#{view_all_images_link}">View All</a></p>');
			// New: non-clickable tooltip-only link
			// New: images for item in separate template
			return new Template('<div class="fb-posts">#{caption_DISABLED_FOR_NOW_}<p><em>#{title}</em><a id="evli_#{list_item_id}" href="#{link_url}" class="event_list_inline_item">View</a></p></div>');
		} (),
		// For image events?
		eventItemWithTooltip: function() {
			// fucking redesigns...
			return new Template('<li class="event_list_item">' + '<div class="event_list_item_container">' + '<a id="evli_#{list_item_id}" href="#{link_url}" class="lightview event_list_inline_item" rel="#{link_rel}" title=":: Timeline Details :: topclose: true, width: 650, height: #{details_win_height}">#{title}</a>#{hidden_items}' + '<div id="evlitt_#{list_item_id}" class="tooltip_container" style="display:none"><p/>#{tt_content}</div></div><div class="clearboth"></div></li>');
		} (),
		// No idea what this does anymore...
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
			return new Template('<div id="#{id}" class="event_preview_item_container tooltip_media_container">#{playlist}</div>');
		} (),
		mediaPlaylistItem: function() {
			return new Template('<div class="tooltip_container">' +
				'<div class="tooltip_item tooltip_video"><a href="#{url}" class="player" style="background-image:url(#{thumbnail_url})"><img src="/images/play.png"></a><strong>#{title}</strong><br/><br/>#{description}<em>#{duration}</em><br/>#{time}</div>' +
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
			return new Template('<div class="event_list_group_even">No events for this month. <p><br/><a id="prev_event_search" href="javascript: void(0);">Show events before this month</a> | <a id="next_event_search" href="#">Show events after this month</a></div>');
		} ()
	};
	that.tooltipTemplates = {
		activity_stream_item: function() {
			return new Template('<div class="tooltip_as">' + tooltipItemViewLink('#{author}#{message}#{media}') + 
				'#{time}#{source}<div class="comment_thread">#{comments}</div>#{likes}</div>');
		} (),
		comment: function() {
			return new Template('<div class="comment_thread_item"><div class="comment_text">#{thumb}<font style="font-weight: bold">#{author} said:</font> #{comment}</div><div class="clearboth"></div></div>');
		} (),
		facebook_comment: function() {
			return new Template('<div class="comment_thread_item"><div class="comment_text">#{thumb}<font style="font-weight: bold">#{author} said:</font> #{comment}#{time}</div><div class="clearboth"></div></div>');
		} (),
		facebook_video: function() {
			return new Template('<a href="#{video_url}" class="lightview"><img src="#{thumbnail_url}" border="0"/></a><br/>#{title}<br/>#{video_source}<br/>#{description}');
		} (),
		facebook_link: function() {
			return new Template('<a href="#{url}" target="_new">#{title}</a><br/>#{caption}<br/>#{description}');
		} (),
		image: function() {
			return new Template('<div class="tooltip_img"><a href="#{img_url}" class="lightview"><img src="#{thumbnail_url}"></a><br/>#{caption}<div class="comment_thread">#{comments}</div></div>');
		} (),
		feed: function() {
			return new Template('<div class="tooltip_feed"><a href="#{screencap_url}" class="lightview" onclick="Tips.hideAll(); return true;"><img src="#{preview_thumb}" width="100" height="100" style="float: left"/></a>' +
				tooltipItemViewLink('#{message}') + '#{source}#{time}</div>');
		} (),
		video: function() {
			return new Template('<div class="tooltip_video"><a class="video_thumb lightview" href="##{id}" rel="inline" title="#{title}"><img src="#{thumbnail_url}" width="#{thumb_width}" height="#{thumb_height}" alt="Click to view" style="float:left"></a><div class="video_player" id="#{id} url="#{video_url} rel="{hidden: true, autoPlay: true, filename: false}"></div>#{message}#{duration}#{time}</div><div class="comment_thread">#{comments}</div><div class="clearboth"></div>');
		} (),
		audio: function() {
			return new Template('<div class="tooltip_audio"><ul class="graphic"><li><a href="#{url}" duration="#{duration}" id="#{id}">#{title} (#{duration_s})</a><br/>#{filename}<br/>#{description}<div class="comment_thread">#{comments}</div></li></ul></div>');
		} (),
		email: function() {
			return new Template('<div class="tooltip_email">' + tooltipItemViewLink('#{subject}') +
				'#{time}</div>');
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
			return new Template('<h1>#{title}</h1><p class="artifacts">#{artifacts}</p>');
		} (),
		artifactBox: function() {
			return new Template('<a id="art:#{id}" href="#{url}" class="lightview etl-artifact-link #{style}" rel="set[artifacts]" title="#{caption} :: :: slideshow: true, autosize: true"><img src="#{thumbnail_url}"/></a>');
		} ()
	};
	that.eventSelectorTemplate = function() {
		return new Template('<a id="prev_event" href="" class="btn-left"></a><span class="subtitle7">&nbsp;Most&nbsp;Recent&nbsp;</span><a id="next_event" href="#" class="btn-right">');
	} ();
	that.loadingTemplate = function() {
		return new Template("<div><span>Loading #{type}...</span></div>");
	} ();
	that.getEventListItemEl = function(id, type) {
		return $("evli_" + id);
	} ();
	that.albumViewLinkTemplate = function(url) {
		return new Template('<br/><a href="#{url}" class="lightview" rel="iframe" title=":: Photo Album :: topclose: true, width: 800, height: 800">View All</a>');
	} ();
	that.tooltipTemplateID = function(id, type) {
		return type + '-evli_' + id;
	};
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
