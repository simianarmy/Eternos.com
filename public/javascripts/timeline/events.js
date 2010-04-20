// $Id$
//
// Timeline 'event' classes & constants

//Eternos Timeline Event Source base class
var ETLEventSource = Class.create({
	initialize: function(s) {
		console.log("constructing ETLEventSource for " + s.type);
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
		return ETEvent.isArtifact(this.type); 
	},
	hasAttachedArtifact: function() {
		return ETEvent.isArtifact(this.attachment_type);
	},
	isMedia: function() {
		return ETEvent.isMedia(this.type) || ETEvent.isMedia(this.attachment_type);
	},
	isVideo: function() {
		return ETEvent.isVideo(this.type);
	},
	isDuration: function() {
		return (this.end_date_obj != null) && (this.start_date_obj !== this.end_date_obj);
	},
	getPreviewHtml: function() {
		return 'Click link to view';
	},
	// Display type may be different than type if an attachment is involved,
	// But I think we just want to display the source icon now...
	getDisplayType: function() {
		// For now, just return source until Eric changes his mind
		return this.type;
		//return (this.attachment_type != null) ? this.attachment_type : this.type;
	},
	getID: function() {
		return this.attributes.id;
	},
	getIcon: function() {
		// For now, just return source until Eric changes his mind
		return this.icon;
		//return ETEvent.getSourceIcon(this.getDisplayType());
	},
	getURL: function() {
		return this.attributes.url;
	},
	getThumbnailURL: function() {
		return this.attributes.thumbnail_url;
	},
	getEditURL: function() {
		return [this.type.pluralize(), 'edit', this.getID()].join('/') +
			'?dialog=1';
	},
	getDeleteURL: function() {
		return [this.type.pluralize(), 'destroy', this.getID()].join('/');
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
	getCaption: function() {
		var txt = this.getText();
		if (txt != null && txt != '') {
			return this.getText().truncate(30);
		} else {
			return null;
		}
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
			return this._getSmallTooltipLine(time);
		}
		return '';
	},
	getEventAuthorHtml: function() {
		var author 	= '';
		if (this.attributes.author) {
			author = '<font style="font-weight: bold">' + this.attributes.author + '</font><br/>';
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
		if (!date) { return null; }
		return date.toISODate();
	},
	// Helper to generate 1-line tooltip contents
	_getSmallTooltipLine: function(text) {
		return ETemplates.tooltipTemplates.single_line_small.evaluate({text: text});
	},
	_templateOpts: function(opts) {
		return Object.extend(opts, this.menuLinks || {});
	},
	_evalTemplate: function(opts) {
		return this.previewTemplate.evaluate(this._templateOpts(opts));
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
		return this._evalTemplate({
			thumbnail_url: this.attributes.thumbnail_url, 
			img_url: this.attributes.url,
			caption: caption
		});
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
		} else if (this.attributes.attribution != null) {
			source = this._getSmallTooltipLine('Source: ' + this.attributes.attribution);
		}
		return source;
	},
	getEventMediaHtml: function() {
		var media = '', url = '', thumb = '';
		
		if (this.isMedia() && ((url = this.getURL()) != null)) {
			if (this.attributes.parsed_attachment_data.type == "video") {
				attached = this.attributes.parsed_attachment_data;
				// Use caption, name, description
				media = '<br/>' + ETemplates.tooltipTemplates.facebook_video.evaluate({
					video_url: this.getURL(),
					thumbnail_url: this.getThumbnailURL(),
					title: attached.name,
					video_source: attached.caption,
					description: attached.description
				});
			} else {
				media += '<br/><a href="' + url + '" class="lightview">';

				if (((thumb = this.getThumbnailURL()) != null) && (thumb !== url)) {
					media += '<img src="' + thumb + '"/>';
				} else {
					media += 'View ' + this.getDisplayTitle();
				}
				media += '</a>';
			}
		} else if (this.attributes.parsed_attachment_data && 
				(this.attributes.parsed_attachment_data.src != null) &&
				(typeof this.attributes.parsed_attachment_data.src == "string")) {
				media += '<br/><img src="' + this.attributes.parsed_attachment_data.src + '"/>';
		}
		// Debug attributes:
		// media += print_r(this.attributes); //'';
		return media;
	},
	getMessage: function() {
		var thumb, msg = '';
		
		
		if (this.attributes.message != null) {
			msg = this.attributes.message.urlToLink();
		} else if (this.attributes.url != null) {
			msg = this.attributes.url.urlToLink();
		}
		// Add any attachment link data (might fuck up existing layouts...)
		// Getting complicated b/c we have to include artifacts here
		if (this.attributes.parsed_attachment_data && 
			(this.attributes.parsed_attachment_data.name != null) &&
			(typeof this.attributes.parsed_attachment_data.name == "string")) {
			if (this.attributes.parsed_attachment_data.type == "link") {
				attached = this.attributes.parsed_attachment_data;
				// Use caption, name, description
				msg = '<br/>' + ETemplates.tooltipTemplates.facebook_link.evaluate({
					url: attached.href,
					title: attached.name,
					caption: attached.caption,
					description: attached.description
				});
			} 
		}
		return msg;
	},
	getPreviewHtml: function() {
		
		return this._evalTemplate(Object.extend({
			message: this.getMessage(),
			author: this.getEventAuthorHtml(),
			time: this.getEventTimeHtml(),
			source: this.getSource(),
			media: this.getEventMediaHtml()
		}, this.getPreviewExtras() || {}));
	}
});
// Facebook event
var ETLFacebookActivityStreamEventSource = Class.create(ETLActivityStreamEventSource, {
	initialize: function($super, s) {
		this.source = 'Facebook';
		$super(s);
	},
	getCommentsCount: function() {
		var comments = '', count = 0;
		if (this.attributes.comment_thread != null) {
			count = this.attributes.comment_thread.size();
			comments = this._getSmallTooltipLine(count + " " + ((count == 1) ? 'Comment' : 'Comments'));
		}
		return comments;
	},
	getComments: function() {
		var comments = '';
		if (this.attributes.comment_thread != null) {
			$A(this.attributes.comment_thread).each(function(c) {
				comments += ETemplates.tooltipTemplates.facebook_comment.evaluate({
					author: (c.username ? c.username : 'You'),
					thumb: (c.username ? '<img align="left" src="' + c.user_pic + '"/>' : ''),
					comment: c.text});
				});
			comments = this._getSmallTooltipLine('Comments: ' + comments);
		}
		return comments;
	},
	getLikes: function() {
		var likes = '', count = 0;
		if (this.attributes.liked_by != null) {
			count = this.attributes.liked_by.size();
			likes = this._getSmallTooltipLine('Liked By ' + count + ' ' + ((count == 1) ? 'Person' : 'People'));
		}
		return likes;
	},
	getPreviewExtras: function() {
		return {
			comments: this.getComments(),
			likes: this.getLikes()
		};
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
	},
	getPreviewExtras: function() {
		return {};
	}
});
// RSS event
var ETLFeedEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.feed;
		$super(s);
	},
	getPreviewHtml: function() {
		var thumb, preview_thumb_url = '', source = '';
	
		if (((thumb = this.attributes.screencap_thumb_url) != null) && !thumb.match('missing')) {
			preview_thumb_url = thumb;
		}
		if (this.getURL() !== '') {
			source = this._getSmallTooltipLine(this.getURL());
		}
		return this._evalTemplate({
			screencap_url: this.attributes.screencap_url,
			preview_thumb: preview_thumb_url,
			message: this.attributes.name,
			source: source,
			time: this.getEventTimeHtml()
		});
	}
});
// Email event
var ETLEmailEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.email;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			subject: this.attributes.subject,
			time: this.getEventTimeHtml()
		});
	}
});
// Video event
var ETLVideoEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.video;
		$super(s);
	},
	getPreviewHtml: function($super) {			
		return this._evalTemplate({
			id: this.getID(),
			video_url: this.getURL(),
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
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.audio;
		$super(s);
	},
	getPreviewHtml: function($super) {
		return this._evalTemplate({
			id: this.getID(),
			url: this.getURL(),
			title: this.getTitle(),
			filename: this.attributes.filename,
			description: this.attributes.description,
			duration: this.attributes.duration,
			duration_s: this.attributes.duration_to_s
		});
	}
});
//////////////////////////////////////////////////////
//
// Profile events
//
//////////////////////////////////////////////////////

// Address event
var ETLAddressEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.address;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			postal: this.attributes.postal_address,
			dates: this.getEventTimeHtml({format: 'date'}),
			type: this.attributes.location_type
		});
	}
});
// Job event
var ETLJobEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.job;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			company: this.attributes.company,
			title: this.attributes.title,
			dates: this.getEventTimeHtml({format: 'date'})
		});
	}
});
// School event
var ETLSchoolEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.school;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			name: this.attributes.name,
			dates: this.getEventTimeHtml({format: 'date'})
		});
	}
});
// Family event
var ETLFamilyEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.family;
		$super(s);
	},
	isDuration: function() {
		return false;
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			name: this.attributes.name,
			relationship: this.attributes.description
		});
	}
});
// Relationship event
var ETLRelationshipEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.family;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			name: this.attributes.name,
			relationship: this.attributes.description
		});
	}
});
// Medical event
var ETLMedicalEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.medical;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			condition: this.attributes.name,
			dates: this.getEventTimeHtml({format: 'date'})
		});
	}
});
// Medical Condition event
var ETLMedicalConditionEventSource = Class.create(ETLEventSource, {
	initialize: function($super, s) {
		this.previewTemplate = ETemplates.tooltipTemplates.medicalCondition;
		$super(s);
	},
	getPreviewHtml: function() {
		return this._evalTemplate({
			condition: this.attributes.name,
			dates: this.getEventTimeHtml({format: 'date'})
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
		{type: "relationship", display_text: "Relationship", display_text_plural: "Relationships", icon: "family-member.png"},
		{type: "medical", display_text: "Medical&nbsp;Data", display_text_plural: "Medical&nbsp;Data", icon: "medic-data.png"},
		{type: "medical_condition", display_text: "Medical Condition", display_text_plural: "Medical Conditions", icon: "medic-cond.png"},
		{type: "job", display_text: "Job", display_text_plural: "Jobs", icon: "job"}, 
		{type: "address", display_text: "Address", display_text_plural: "Addresses", icon: "address.png"}
	],
	
	// Class factory function - returns ETLEventSource child class object based on passed type string
	createSource: function(data) {
		var type = data.type; //(data.attachment_type == null) ? data.type : data.attachment_type;
		var s = this.typeAttributes(type);
		data = Object.extend(data, s);
		
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
			// Load flowplayer libraries as needed
			if (SimileAjax.findScript(document, 'flowplayer') === null) {
				SimileAjax.includeCssFiles(document, '/stylesheets/', ['media.css']);
				SimileAjax.includeJavascriptFiles(document, '/javascripts/', ['flowplayer-3.1.4.min.js', 'flowplayer.playlist-3.0.7.js', 'flowplayer.js']);
			}
			return new ETLVideoEventSource(data);
		} else if (type === "audio" || type === "music") {
			// Load soundmanager js & css files dynamically - heavy & use flash
			if (SimileAjax.findScript(document, 'soundmanager2') === null) {
				SimileAjax.includeCssFiles(document, '/stylesheets/', ['soundmanager2.css', 'inlineplayer.css']);
				SimileAjax.includeJavascriptFiles(document, '/javascripts/', ['soundmanager2-nodebug-jsmin.js', 'inlineplayer.js']);
			}
			return new ETLAudioEventSource(data);
		} else if (type === "job") {
			return new ETLJobEventSource(data);
		} else if (type === "address") {	
			return new ETLAddressEventSource(data);
		} else if (type === "school") {
			return new ETLSchoolEventSource(data);
		} else if (type === "family") {
			return new ETLFamilyEventSource(data);
		} else if (type === "relationship") {
			return new ETLRelationshipEventSource(data);
		} else if (type === "medical") {
			return new ETLMedicalEventSource(data);
		} else if (type === "medical_condition") {
			return new ETLMedicalConditionEventSource(data);
		} else {
			console.log("Unknown type from source: " + data.type);
			return null;
		}
	},
	isMedia: function(type) {
		return (type === 'photo' || type === 'video' || type === 'web_video' || type === 'audio');
	},
	isAudio: function(type) {
		return (type === 'audio' || type === 'music');
	},
	isArtifact: function(type) {
		return (type === 'photo') || (type === 'video') || (type === 'web_video');
	},
	isVideo: function(type) {
		return (type === 'web_video');
	},
	getSourceIcon: function(type) {
		return this.itemTypes.find(function(t) { return type === t.type; }).icon;
	},
	typeAttributes: function(type) {
		return this.itemTypes.find(function(t) { return type === t.type; });
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
	};
}
