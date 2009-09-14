// $Id$
//
// Timeline 'event' classes & constants

//Eternos Timeline Event Source base class
var ETLEventSource = Class.create({
	initialize: function(s) {
		console.log("constructing ETLEventSource for " + s.type);
		this.type 								= s.type;
		this.attachment_type			= s.attachment_type;
		this.display_text 				= s.display_text
		this.display_text_plural 	= s.display_text_plural;
		this.icon 								= s.icon;
		this.start_date 					= s.start_date;
		this.end_date 						= s.end_date;
		this.event_date_s					= '';
		this.attributes 					= s.attributes;
	},
	isArtifact: function() {
		return ETEvent.isArtifact(this.type) || ETEvent.isArtifact(this.attachment_type);
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
	// Returns event's date occurrence, as date string
	// Needed b/c dates can be date or datetimes
	eventDateString: function() {
		var parts;
		if (this.event_date_s === '') {
			parts = this.start_date.replace(MysqlDateRE, "$1 $2 $3").split(' ');
			this.event_date_s = parts.join('-');
		}
		return this.event_date_s;
	},
	// Returne rails action path for viewing event source collection by date
	eventDetailsPath: function(memberId) {
		return ['tl_details', memberId, this.type].join('/');
	}
});

// Photo event
var ETLPhotoEventSource = Class.create(ETLEventSource, {
	isArtifact: function() {
		return true;
	},
	getPreviewHtml: function() {
		var str = '';
		if (this.attributes.caption !== undefined) {
			str = this.attributes.caption;
		} else if (this.attributes.description !== undefined) {
			str = this.attributes.description;
		}
		str += '<br/><img src="' + this.attributes.thumbnail_url + '">';
		return str;
	}
});
// Facebook event
var ETLFacebookActivityStreamEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		var html = this.attributes.message;
		if (this.attributes.attachment_data != null) {
			html += '<br/>'
			if (this.attributes.thumbnail_url != null) {
				html += this.attributes.thumbnail_url;
			} else if (this.attributes.url != null) {
				html += this.attributes.url;
			} else {
				//console.log("Unknown data facebook attachment type: " + this.attributes.attachment_type)
			}
		}
		return html;
	}
});
// Twitter event
var ETLTwitterActivityStreamEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		return this.attributes.message;
	}
});
// RSS event
var ETLFeedEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		var thumb, preview = this.attributes.name;
		if (((thumb = this.attributes.screencap_thumb_url) != null) && !thumb.match('missing')) {
			preview += '<br/><img src="' + thumb + '" width="100" height="100">';
		}
		return preview;
	}
});
// Email event
var ETLEmailEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		return this.attributes.subject;
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
		{type: "facebook_activity_stream_item", display_text: "Facebook Post", display_text_plural: "Facebook Posts", icon: "facebook.gif"}, 
		{type: "twitter_activity_stream_item", display_text: "Tweet", display_text_plural: "Tweets", icon: "twitter.gif"}, 
		{type: "feed_entry", display_text: "Blog Post", display_text_plural: "Blog Posts", icon: "rss.png"}, 
		{type: "backup_email", display_text: "Email", display_text_plural: "Emails", icon: "email.png"}, 
		{type: "photo", display_text: "Image", display_text_plural: "Images", icon: "photo.png"},
		{type: "video", display_text: "Video", display_text_plural: "Videos", icon: "movie.png"},
		{type: "music", display_text: "Music", display_text_plural: "Music", icon: "music.png"},
		{type: "audio", display_text: "Audio", display_text_plural: "Audio", icon: "audio.png"},
		{type: "document", display_text: "Document", display_text_plural: "Documents", icon: "doc.png"},
		{type: "school", display_text: "School", display_text_plural: "Schools", icon: "school.png"},
		{type: "family", display_text: "Family Member", display_text_plural: "Family Members", icon: "family-member.png"},
		{type: "medical", display_text: "Medical Data", display_text_plural: "Medical Data", icon: "medic-data.png"},
		{type: "medical_conditions", display_text: "Medical Condition", display_text_plural: "Medical Conditions", icon: "medic-cond.png"},
		{type: "job", display_text: "Job", display_text_plural: "Jobs", icon: "job"}, 
		{type: "address", display_text: "Address", display_text_plural: "Addresses", icon: "address.png"}
	],
	
	// Class factory function - returns ETLEventSource child class object based on passed type string
	createSource: function(data) {
		var type = (data.attachment_type == null) ? data.type : data.attachment_type;
		var s = this.itemTypes.find(function(t) { return type === t.type});
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
			alert("Unknown type from source: " + data.type);
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
	}
};

