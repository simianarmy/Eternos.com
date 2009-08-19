// $Id$
//
// Timeline 'event' classes & constants

//Eternos Timeline Event Source base class
var ETLEventSource = Class.create({
	initialize: function(s) {
		this.type 								= s.type;
		this.display_text 				= s.display_text
		this.display_text_plural 	= s.display_text_plural;
		this.icon 								= s.icon;
		this.start_date 					= s.start_date;
		this.end_date 						= s.end_date;
		this.attributes 					= s.attributes;
	},
	isArtifact: function() {
		return (this.type === 'Photo' || this.type === 'Video' || this.type === 'WebVideo');
	},
	getPreviewHtml: function() {
		return 'Click link to view';
	}
});
// Photo event
var ETLPhotoEventSource = Class.create(ETLEventSource, {
	isArtifact: function() {
		return true;
	},
	getPreviewHtml: function() {
		return '<img src="' + this.attributes.thumbnail_url + '">';
	}
});
// Facebook event
var ETLFacebookActivityStreamEventSource = Class.create(ETLEventSource, {
	getPreviewHtml: function() {
		if (this.attributes.attachment_data == null) {
			return this.attributes.message;
		} else {
			var html = this.attributes.message + '<br/>'
			if (this.attributes.thumbnail_url != null) {
				html += this.attributes.thumbnail_url;
			} else if (this.attributes.url != null) {
				html += this.attributes.url;
			} else {
				console.log("Unknown data facebook attachment type: " + this.attributes.attachment_type)
			}
			return html;
		}
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
		return this.attributes.name;
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

// ETEvent Namespace
var ETEvent = {
	// Utilities, constants and vars needed
	itemTypes: [
		{type: "FacebookActivityStreamItem", display_text: "Facebook Post", display_text_plural: "Facebook Posts", icon: "dark-blue"}, 
		{type: "TwitterActivityStreamItem", display_text: "Tweet", display_text_plural: "Tweets", icon: "dull-green"}, 
		{type: "FeedEntry", display_text: "Blog Post", display_text_plural: "Blog Posts", icon: "dull-red"}, 
		{type: "BackupEmail", display_text: "Email", display_text_plural: "Emails", icon: "red"}, 
		{type: "Photo", display_text: "Photo", display_text_plural: "Photos", icon: "blue"},
		{type: "Video", display_text: "Video", display_text_plural: "Videos", icon: "green"},
		{type: "Music", display_text: "Music", display_text_plural: "Music", icon: "green"},
		{type: "Audio", display_text: "Audio", display_text_plural: "Audio", icon: "green"},
		{type: "Document", display_text: "Document", display_text_plural: "Documents", icon: "grey"},
		{type: "School", display_text: "School", display_text_plural: "Schools", icon: "dull-blue"},
		{type: "Family", display_text: "Family Member", display_text_plural: "Family Members", icon: "dull-blue"},
		{type: "Medical", display_text: "Medical Data", display_text_plural: "Medical Data", icon: "dull-blue"},
		{type: "MedicalCondition", display_text: "Medical Condition", display_text_plural: "Medical Conditions", icon: "dull-blue"},
		{type: "Job", display_text: "Job", display_text_plural: "Jobs", icon: "dull-blue"}, 
		{type: "Address", display_text: "Address", display_text_plural: "Addresses", icon: "dull-blue"}
	],
	
	// Class factory function - returns ETLEventSource child class object based on passed type string
	createSource: function(data) {
		var type = data.type;
		var s = this.itemTypes.find(function(t) { return type === t.type});
		var data = Object.extend(data, s);
		
		if (type === "FacebookActivityStreamItem") {
			return new ETLFacebookActivityStreamEventSource(data);
		} else if (type === "TwitterActivityStreamItem") {
			return new ETLTwitterActivityStreamEventSource(data);
		} else if (type === "FeedEntry") {
			return new ETLFeedEventSource(data);
		} else if (type === "BackupEmail") {
			return new ETLEmailEventSource(data);
		} else if (type === "Photo") {
			return new ETLPhotoEventSource(data);
		} else if (type === "Video") {
			return new ETLVideoEventSource(data);
		} else if (type === "Job") {
			return new ETLJobEventSource(data);
		} else {
			alert("Unknown type from source: " + data.type);
			return null;
		}
	},
	isArtifact: function(type) {
		return (type === 'Photo' || type === 'Video' || type === 'WebVideo');
	},
	getSourceIcon: function(type) {
		return this.itemTypes.find(function(t) { return type === t.type}).icon;
	}
};
