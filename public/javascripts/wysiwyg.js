// $Id$
//
// Library for displaying wysiwig editor contents on a page 
// formatted for proper display of multimedia content.  

// CKEDITOR configurations:

// Mementos Editor CKEDITOR configuration
var mementosCKEditorConfig =
{
	skin : 'kama',
	uiColor : "#EFF5FF",
	toolbar : [
		['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		['Styles','Format','Font','FontSize', '-', 'TextColor','BGColor']
	]
};

// wysiwyg object
//
var wysiwyg = function() {
	// constructor takes editor contents as string
	var that = {};
	var template_includes = false;
	var templates = {
		audio: new Template('<a class="sm2_link" id="wysiwyg_filter::#{id}" href="#{url}">#{title}</a>'),
		video: new Template('<a class="popup_get" id="wysiwyg_filter::#{id}" href="#{url}">#{title}</a>')
	};
	templates.music = templates.audio;
	templates.web_video = templates.video;
	
	// Takes draggable item element div and returns html that will be used 
	// to represent it inside editor
	var get_artifact_html = function(element) {
		var drop_text = '';
		
		if ((match = element.id.match(/^artifact_(\w+)_\d+$/))) {
			var artifact_type = match[1];

			// Render artifact template into string
			if (typeof templates[artifact_type] === "object") {
				var opts = element.readAttribute('rel').evalJSON();
				opts.id = element.id;
				drop_text = templates[artifact_type].evaluate(opts);
			}
		}
		if (drop_text === '') {
			drop_text = $(element.id).innerHTML;
		}
		return drop_text;
	};
	that.get_artifact_html = get_artifact_html;
	
	// TODO:
	//   On hold until:
	//		Server-side filtering requests become performance bottleneck
	var get_xhtml = function(original_content) {
		template_includes = template_includes || includes();
		html = template_includes + original_content;
		return html;
	};
	that.get_xhtml = get_xhtml;
	
	return that;
};