// $Id$
//
// Timeline 'event' classes & constants

//Eternos Timeline Event Source base class
var ETLEventSource = Class.create({
	initialize: function(s) {
		//console.log("constructing ETLEventSource for " + s.type);
		this.type 								= s.type;
		this.attributes 					= s.attributes;
		this.attachment_type			= s.attachment_type;
		this.icon 								= s.icon;
		this.start_date_str 			= s.start_date;
		this.end_date_str 				= s.end_date;
		this.start_date_obj 			= this._getStartDateObj(); // Create this now for sorts
		this.end_date_obj					= this._getEndDateObj();
	},
	isArtifact: function() {
		return ETEvent.isArtifact(this.type); // || ETEvent.isArtifact(this.attachment_type);
	},
	isMedia: function() {
		return ETEvent.isMedia(this.type) || ETEvent.isMedia(this.attachment_type);
	},
	isDuration: function() {
		return (this.end_date_obj != null) && (this.start_date_obj !== this.end_date_obj);
	},
	getPreviewHtml: function() {
		return 'Click link to view';
	},
	getDisplayType: function() {
		return (this.attachment_type != null) ? this.attachment_type : this.type;
	},
	getID: function() {
		return this.attributes.id;
	},
	getIcon: function() {
		return ETEvent.getSourceIcon(this.getDisplayType());
	},
	getURL: function() {
		return this.attributes.url;
	},
	getThumbnailURL: function() {
		return this.attributes.thumbnail_url;
	}, 
	getTitle: function() {
		return this.attributes.title;
	},
	// Display title may be different than our type if attachment type is media
	getDisplayTitle: function(num) {
		var title = '', props = ETEvent.typeAttributes(this.getDisplayType());
		if (num > 1) {
    	title = num + '&nbsp;' + props.display_text_plural;
  	} else {
    	title = props.display_text;
		}
		return title;
  },
	getText: function() {
		return this.attributes.message || this.attributes.description;
	},
	// Returns event date as string
	getEventDate: function() {
		return this.start_date_str;
	},
	getEventEndDate: function() { 
		return this.end_date_str;
	},
	// Returns event date as Date
	getEventDateObj: function() {
		return this.start_date_obj;
	},
	// Returne rails action path for viewing event source collection by date
	eventDetailsPath: function(memberId) {
		return ['tl_details', memberId, this.type].join('/');
	},
	getEventTimeHtml: function(opts) {
		var time = '';
		opts = Object.extend({
			format: 'time'
		}, opts);
		
		if (this.start_date_obj) {
			time = opts.format === 'time' ? 
				this.start_date_obj.toLocaleTimeString() : 
				this.start_date_obj.toLocaleDateString();
		}
		if (this.end_date_obj) {
			time += ' to ';
			time += (opts.format === 'time') ? 
				this.end_date_obj.toLocaleTimeString() : 
				this.end_date_obj.toLocaleDateString();
		}
		if (time !== '') { 
			return this._getSmallTooltipLine(time)
		}
		return '';
	},
	getEventAuthorHtml: function() {
		var author 	= '';
		if (this.attributes.author) {
			author = '<br/><span class="event_author">Author: ' + this.attributes.author + '</span>';
		}
		return author;
	},
	_getStartDateObj: function() {
		return this._parseEventDateString(this.start_date_str);
	},
	_getEndDateObj: function() {
		return this._parseEventDateString(this.end_date_str);
	},
	// Parses event date from string into date object
	_parseEventDateString: function(date) {
		// TODO: Optimize - Date.parseExact is slow
		// try to parse iso datetime
		if (!date) { return; }
		return date.toISODate();
	},
	// Helper to generate 1-line tooltip contents
	_getSmallTooltipLine: function(text) {
		return ETemplates.tooltipTemplates.single_line_small.evaluate({text: text});
	}
});

// Photo event
var ETLPhotoEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.image;
		$super(s);
	},
	isArtifact: function() {
		return true;
	},
	getPreviewHtml: function() {
		var caption = '';
		if (this.attributes.caption !== undefined) {
			caption = this.attributes.caption;
		} else if (this.attributes.description !== undefined) {
			caption = this.attributes.description;
		}
		return this.previewTemplate.evaluate({
			img_url: this.attributes.thumbnail_url, 
			caption: caption});
	}
});

var ETLActivityStreamEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.activity_stream_item;
		$super(s);
	},
	getSource: function() {
		var source = '';
		if (this.isMedia()) {
			source = this._getSmallTooltipLine('Source: ' + this.source);
		}
		return source;
	},
	getEventMediaHtml: function() {
		var media = '', url = '', thumb = '';
		
		if (this.isMedia() && ((url = this.getURL()) != null)) {
			media += '<br/><a href="' + url + '" class="lightview">';

			if (((thumb = this.getThumbnailURL()) != null) && (thumb !== url)) {
				media += '<img src="' + thumb + '">';
			} else {
				media += 'Click to View';
			}
			media += '</a>';
		}
		// Debug attributes:
		// media += print_r(this.attributes); //'';
		return media;
	},
	getPreviewHtml: function() {
		return this.previewTemplate.evaluate({
			message: this.attributes.message.urlToLink(),
			author: this.getEventAuthorHtml(),
			time: this.getEventTimeHtml(),
			source: this.getSource(),
			media: this.getEventMediaHtml()
		});
	}
});
// Facebook event
var ETLFacebookActivityStreamEventSource = Class.create(ETLActivityStreamEventSource, {
	initialize: function($super, s) {
		this.source = 'Facebook';
		$super(s);
	}
});
// Twitter event
var ETLTwitterActivityStreamEventSource = Class.create(ETLActivityStreamEventSource, {
	initialize: function($super, s) {
		this.source = 'Twitter';
		$super(s);
	},
	getSource: function() {
		var source = '';
		if (this.attributes.source !== '') {
			source = this._getSmallTooltipLine('Source: ' + this.attributes.source);
		}
		return source;
	}
});
// RSS event
var ETLFeedEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.feed;
		$super(s);
	},
	getPreviewHtml: function() {
		var thumb, preview = '', source = '';
	
		if (((thumb = this.attributes.screencap_thumb_url) != null) && !thumb.match('missing')) {
			preview = '<img src="' + thumb + '" width="100" height="100" style="float: left">';
		}
		if (this.getURL() !== '') {
			source = this._getSmallTooltipLine(this.getURL());
		}
		return this.previewTemplate.evaluate({
			preview: preview,
			message: this.attributes.name,
			source: source,
			time: this.getEventTimeHtml()
		});
	}
});
// Email event
var ETLEmailEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		return this.attributes.subject + this.getEventTimeHtml();
	}
});
// Video event
var ETLVideoEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.video;
		$super(s);
	},
	getPreviewHtml: function($super) {			
		return this.previewTemplate.evaluate({
			id: this.getID(),
			video_url: this.attributes.url,
			thumbnail_url: this.attributes.thumbnail_url,
			thumb_width: this.attributes.thumb_width,
			thumb_height: this.attributes.thumb_height,
			title: this.attributes.title,
			message: this.attributes.description || this.attributes.title,
			duration: this._getSmallTooltipLine(this.attributes.duration),
			time: this.getEventTimeHtml()
		});
	}
});
// Audio event
var ETLAudioEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function($super) {
		if (this.attributes.message !== null) {
			return this.attributes.message;
		} else {
			return $super.getPreviewHtml();
		}
	}
});
// Job event
var ETLJobEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		return this.attributes.company;
	}
});
// Address event
var ETLAddressEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.address;
		$super(s);
	},
	getPreviewHtml: function() {
		return this.previewTemplate.evaluate({
			postal: this.attributes.postal_address,
			dates: this.getEventTimeHtml({format: 'date'}),
			type: this.attributes.location_type
		});
	}
});

// ETEvent Namespace
var ETEvent = {
	// Utilities, constants and vars needed
	itemTypes: [
		{type: "facebook_activity_stream_item", display_text: "Facebook&nbsp;Post", display_text_plural: "Facebook&nbsp;Posts", icon: "facebook.gif"}, 
		{type: "twitter_activity_stream_item", display_text: "Tweet", display_text_plural: "Tweets", icon: "twitter.gif"}, 
		{type: "feed_entry", display_text: "Blog&nbsp;Post", display_text_plural: "Blog&nbsp;Posts", icon: "rss.png"}, 
		{type: "backup_email", display_text: "Email", display_text_plural: "Emails", icon: "email.png"}, 
		{type: "photo", display_text: "Image", display_text_plural: "Images", icon: "photo.png"},
		{type: "video", display_text: "Video", display_text_plural: "Videos", icon: "movie.png"},
		{type: "web_video", display_text: "Video", display_text_plural: "Videos", icon: "movie.png"},
		{type: "music", display_text: "Music", display_text_plural: "Music", icon: "music.png"},
		{type: "audio", display_text: "Audio", display_text_plural: "Audio", icon: "audio.png"},
		{type: "document", display_text: "Document", display_text_plural: "Documents", icon: "doc.png"},
		{type: "school", display_text: "School", display_text_plural: "Schools", icon: "school.png"},
		{type: "family", display_text: "Family&nbsp;Member", display_text_plural: "Family&nbsp;Members", icon: "family-member.png"},
		{type: "medical", display_text: "Medical&nbsp;Data", display_text_plural: "Medical&nbsp;Data", icon: "medic-data.png"},
		{type: "medical_conditions", display_text: "Medical Condition", display_text_plural: "Medical Conditions", icon: "medic-cond.png"},
		{type: "job", display_text: "Job", display_text_plural: "Jobs", icon: "job"}, 
		{type: "address", display_text: "Address", display_text_plural: "Addresses", icon: "address.png"}
	],
	
	// Class factory function - returns ETLEventSource child class object based on passed type string
	createSource: function(data) {
		var type = data.type; //(data.attachment_type == null) ? data.type : data.attachment_type;
		var s = this.typeAttributes(type);
		var data = Object.extend(data, s);
		
		if (type === "facebook_activity_stream_item") {
			return new ETLFacebookActivityStreamEventSource(data);
		} else if (type === "twitter_activity_stream_item") {
			return new ETLTwitterActivityStreamEventSource(data);
		} else if (type === "feed_entry") {
			return new ETLFeedEventSource(data);
		} else if (type === "backup_email") {
			return new ETLEmailEventSource(data);
		} else if (type === "photo") {
			return new ETLPhotoEventSource(data);
		} else if (type === "video" || type === "web_video") {
			return new ETLVideoEventSource(data);
		} else if (type === "audio") {
			return new ETLAudioEventSource(data);
		} else if (type === "job") {
			return new ETLJobEventSource(data);
		} else if (type === "address") {	
			return new ETLAddressEventSource(data);
		} else {
			console.log("Unknown type from source: " + data.type);
			return null;
		}
	},
	isMedia: function(type) {
		return (type === 'photo' || type === 'video' || type === 'web_video' || type === 'audio');
	},
	isArtifact: function(type) {
		return (type === 'photo');
	},
	getSourceIcon: function(type) {
		return this.itemTypes.find(function(t) { return type === t.type}).icon;
	},
	typeAttributes: function(type) {
		return this.itemTypes.find(function(t) { return type === t.type});
	}
};

// Utility functions - may move these to utility file if useful
if (String.prototype.urlToLink == null) {
	String.prototype.urlToLink = function() {
		var t = this;
		t = t.replace(/((www\.|(http|https|ftp|news|file)+\:\/\/)[_.a-zA-Z0-9-]+\.[_a-zA-Z0-9\/_:@=.+?,##%&~-]*[^.|\'|\# |!|\(|?|,| |>|<|;|\)])/g, '$1');
		t = t.replace('href="www', 'href="http://www');
		t = t.replace(/((www\.|(http|https|ftp|news|file))+:\/\/[^ ]+)/g, '<div class="tooltip_link"><a href="$1" target="_new" rel="nofollow">$1</a></div>');
		return t;
	}
}
