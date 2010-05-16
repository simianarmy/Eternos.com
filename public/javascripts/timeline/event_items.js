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
		var i, count, item, listId = this._getItemID(),
			view_all_url, html = '';
		var collectionIds = new Array();
		var winHeight = getWinHeight();

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
		} else {
			// Images & the rest handled below
			if (this.first.isArtifact()) {
				count = Math.min(this.MaxArtifactTooltipItems, this.num);
				html = '<div class="tooltip_arti_container">';
			} else {
				count = Math.min(this.MaxTooltipItems, this.num);
				html = '<div class="tooltip_all_container">';
			}
			for (i = 0; i < count; i++) {
				item = this.items[i];
				if (item.attributes.collection_id) {
					collectionIds.push(item.attributes.collection_id);
				}
				item.menuLinks = this._itemMenuLinks(item);
				html += ETemplates.eventListTemplates.eventItemTooltipItem.evaluate(
				Object.extend({
					details_win_height: winHeight,
					content: item.getPreviewHtml()
				},
				this._itemMenuLinks(item)));
			}
			// Add link to view all
			if (count < this.num) {
				// Collect all album ids for gallery url
				if (this.first.isArtifact() && (collectionIds.size() > 0)) {
					html += ETemplates.albumViewLinkTemplate.evaluate({
						url: '/image_gallery?album_id=' + encodeURIComponent(collectionIds.uniq().join(','))
					});
				} else {
					html += '<br/><a href="' + this._getLinkUrl() + '" class="lightview" rel="iframe">View All</a>';
				}
			}
		}
		html += '</div>';
		this.tooltipHtml = html;
		return this.tooltipHtml;
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
