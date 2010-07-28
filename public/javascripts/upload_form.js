// $Id$
//
// *** NOTE ***
// Requires MooTools - Must use its methods
//
window.addEvent('domready', function() {

	// For testing, showing the user the current Flash version.
	//document.getElement('h3 + p').appendText(' Detected Flash ' + Browser.Plugins.Flash.version);
	var form_url = document.id('new_content').action;

	//alert('upload form = ' + form_url)
	var swiffy = new FancyUpload2(document.id('content-status'), document.id('content-list'), {
		url: form_url,
		fieldName: 'content[uploaded_data]',
		path: "/swf/Swiff.Uploader.swf",
		next_step: document.id('upload-success'),
		object_ids: document.id('content-ids'),
		showThumbnails: true,

		onLoad: function() {
			document.id('content-status').removeClass('hide');
			document.id('content-fallback').destroy();
		},
		debug: true,
		target: 'content-browse-all',
		callBacks: {
			onAllSelect: function(files, current, overall) {
				if (current.bytesTotal > 0) {
					/*
					document.id('upload-status').set('html', "Click 'Upload' to start uploading files.");
					document.id('content-browse-all').removeClass('active');
					document.id('content-upload').addClass('active');
					document.id('content-clear').removeClass('hide');
					*/
					swiffy.upload();
				}
			}
		}
	});

	/**
	 * Various interactions
	 */

	document.id('content-browse-all').addEvent('click', function() {
		/**
		 * Doesn't work anymore with Flash 10: swiffy.browse();
		 * FancyUpload moves the Flash movie as overlay over the link.
		 * (see option "target" above)
		 */
		swiffy.browse();
		return false;
	});

	/**
	 * The *NEW* way to set the typeFilter, since Flash 10 does not call
	 * swiffy.browse(), we need to change the type manually before the browse-click.
	 
	 
	 document.id('content-browse-images').addEvent('click', function() {
	 var filter = {'Images (*.jpg, *.jpeg, *.gif, *.png)': '*.jpg; *.jpeg; *.gif; *.png'};
	 
	 swiffy.options.typeFilter = filter;
	 return false;
	 });
	 */
	document.id('content-clear').addEvent('click', function() {
		document.id('upload-status').set('html', "Click 'Browse' to select file(s)");
		document.id('content-browse-all').addClass('active');
		document.id('content-upload').removeClass('active');
		swiffy.removeFile();
		return false;
	});

	document.id('content-upload').addEvent('click', function() {
		swiffy.upload();
		return false;
	});

	document.id('add-descriptions').addEvent('click', function() {
		// GET request to edit action with all uploaded object ids
		h = document.id('content-ids');
		if (h && (h.value != '')) {
			document.id('add_descriptions_form').submit();
		} else {
			alert('No files to describe!');
		}
	});
});
