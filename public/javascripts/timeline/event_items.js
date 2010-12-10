// $Id$

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
		/*
		return ETemplates.eventListTemplates.eventItemWithTooltip.evaluate({
			list_item_id: this._getItemID(),
			b_title: this.title,
			title: this.getTooltipTitle(),
			link_url: this._getLinkUrl(),
			link_rel: this._getLinkRel()
			
      //hidden_items: other_items,
      //tt_content: this.getTooltipContents()
		});
		*/
		return this._getInlineItemHtml();
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
		var i, idx, count, item, listId = this._getItemID(),
			view_all_url, html = '';
		var collectionIds = new Array();

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
		} else if (this.first.isComment()) {
			html = '<div class="tooltip_all_container">' + 
				this._generateCommentTooltipContents();
		} else {
			// Images & the rest handled below.
			// Determine max items to display and container type
			if (this.first.isArtifact()) {
				count = Math.min(this.MaxArtifactTooltipItems, this.num);
				html = '<div class="tooltip_arti_container">';
			} else {
				count = Math.min(this.MaxTooltipItems, this.num);
				html = '<div class="tooltip_all_container">';
			}
			// Generate html for each event source in the collection
			for (idx=0; idx<count; idx++) {
				item = this.items[idx];
				item.firstItem = (idx === 0); // can't pass to getPreviewHtml??
				if (item.attributes.collection_id) {
					collectionIds.push(item.attributes.collection_id);
				}
				item.menuLinks = this._itemMenuLinks(item);
				html += ETemplates.eventListTemplates.eventItemTooltipItem.evaluate(
					Object.extend({
						details_win_height: getWinHeight(),
						content: item.getPreviewHtml()
					},
					this._itemMenuLinks(item))
				);
			}
			// Add link to view all
			if (count < this.num) {
				// Collect all album ids for gallery url
				if (this.first.isArtifact() && (collectionIds.size() > 0)) {
					html += ETemplates.albumViewLinkTemplate.evaluate({
						url: '/image_gallery?album_id=' + encodeURIComponent(collectionIds.uniq().join(','))
					});
				} else {
					html += ETemplates.albumViewLinkTemplate.evaluate({
						url: this._getLinkUrl()
					});
				}
			}
		}
		html += '</div>';
		this.tooltipHtml = html;
		return this.tooltipHtml;
	},
	// Custom content tooltip generator for comments
	_generateCommentTooltipContents: function() {
		var html = '';
		var threads = new Array();
		var i, comment, tid;
		
		for (idx=0; idx<this.num; idx++) {
			comment = this.items[idx];
			// Get the comment's thread id and check if its thread has already been created
			tid = ETERNOS.commentsManager.gen_key(comment);
			if (threads.include(tid)) {
				ETDebug.log("comment's thread already generated...skipping");
				continue;
			}
			// Generate the comments full thread
			html += this._generateCommentThreadContents(tid, comment);
			
			// Save thread to list so that we don't repeat it
			threads.push(tid);
		}
		return html;
	},
	_generateCommentThreadContents: function(thread_id, comment) {
		// Now we need the thread's original parent.  From that we can fetch 
		// the full comments list.
		var html = '<div class="comment_thread">';
		var root = ETERNOS.commentsManager.getCommentRoot(comment);
		if (root) {
			html += ETemplates.eventListTemplates.eventItemTooltipItem.evaluate(
				Object.extend({
					details_win_height: getWinHeight(),
					content: root.getPreviewHtml()
				},
				this._itemMenuLinks(root))
			);
		}
		html += '</div>';
		return html;
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
