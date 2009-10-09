// $Id$
//
// Timeline 'event' classes & constants

//Eternos Timeline Event Source base class
var ETLEventSource = Class.create({
	initialize: function(s) {
		console.log("constructing ETLEventSource for " + s.type);
		this.type 								= s.type;
		this.attachment_type			= s.attachment_type;
		this.icon 								= s.icon;
		this.start_date 					= s.start_date;
		this.end_date 						= s.end_date;
		this.attributes 					= s.attributes;
	},
	isArtifact: function() {
		return ETEvent.isArtifact(this.type); // || ETEvent.isArtifact(this.attachment_type);
	},
	isMedia: function() {
		return ETEvent.isMedia(this.type) || ETEvent.isMedia(this.attachment_type);
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
	getEventDate: function() {
		return this.start_date;
	},
	getEventDateObj: function() {
		return this.getStartDateObj();
	},
	getStartDateObj: function() {
		return this._parseEventDateString(this.start_date);
	},
	getEndDateObj: function() {
		return this._parseEventDateString(this.end_date);
	},
	// Returne rails action path for viewing event source collection by date
	eventDetailsPath: function(memberId) {
		return ['tl_details', memberId, this.type].join('/');
	},
	getEventTimeHtml: function() {
		var d, time = '';
		if ((this.start_date != null) && (d = this.getStartDateObj())) {
			time = '<br/><span class="event_time">' + d.toLocaleTimeString();
		}
		if ((this.end_date != null) && (this.start_date !== this.end_date) && 
			(d = this.getEndDateObj())) {
			time += ' to ' + d.toLocaleTimeString();
		}
		if (time !== '') { 
			time += '</span>';
		}
		return time;
	},
	getEventAuthorHtml: function() {
		var author 	= '';
		if (this.attributes.author) {
			author = '<br/><span class="event_author"><b>Posted by:</b> ' + this.attributes.author + '</span>';
		}
		return author;
	},
	// Parses event date from string into date object
	_parseEventDateString: function(date) {
		// try to parse iso datetime
		var parsed = Date.parseExact(date, "yyyy-MM-ddTHH:mm:ssZ");
		if (!parsed) {
			parsed = date.toDate();
		}
		return parsed;
	}
});

// Photo event
var ETLPhotoEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = new Template('<div class="tooltip_photo"><img src="#{img_url}"><br/>#{caption}</div><br/>');
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
		this.previewTemplate = new Template('#{message}#{author}#{time}#{source}#{media}');
		$super(s);
	},
	getSource: function() {
		var source = '';
		if (this.isMedia()) {
			source = '<br/><span class="event_time">Source: ' + this.source + '</span>';
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
	getPreviewHtml: function() {
		return this.previewTemplate.evaluate({
			message: this.attributes.message,
			time: this.getEventTimeHtml()
		});
	}
});
// RSS event
var ETLFeedEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		var thumb, preview = this.attributes.name;
		preview += this.getEventTimeHtml();
		if (((thumb = this.attributes.screencap_thumb_url) != null) && !thumb.match('missing')) {
			preview += '<br/><img src="' + thumb + '" width="100" height="100">';
		}
		return preview;
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
	getPreviewHtml: function() {
		return [this.attributes.street_1, this.attributes.city,
			this.attributes.country_id, 
			this.attributes.postal_code].join('<br/>');
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
		} else if (type === "video") {
			return new ETLVideoEventSource(data);
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
		return (type === 'photo' || type === 'video' || type === 'web_video');
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
