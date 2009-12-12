// $Id$
//
// *** NOTE ***
// Requires MooTools - Must use its methods
//
window.addEvent('domready', function() {

	// For testing, showing the user the current Flash version.
	//document.getElement('h3 + p').appendText(' Detected Flash ' + Browser.Plugins.Flash.version);
	var form_url = $('new_content').action;

	//alert('upload form = ' + form_url)
	var swiffy = new FancyUpload2($('content-status'), $('content-list'), {
		url: form_url,
		fieldName: 'content[uploaded_data]',
		path: "/swf/Swiff.Uploader.swf",
		next_step: $('upload-success'),
		object_ids: $('content-ids'),
		showThumbnails: true,

		onLoad: function() {
			$('content-status').removeClass('hide');
			$('content-fallback').destroy();
		},
		debug: true,
		target: 'content-browse-all',
		callBacks: {
			onAllSelect: function(files, current, overall) {
				if (current.bytesTotal > 0) {
					$('upload-status').set('html', "Click 'Upload' to start uploading files.");
					$('content-browse-all').removeClass('active');
					$('content-upload').addClass('active'); 
				}
			}
		}
	});

	/**
	 * Various interactions
	 */

	$('content-browse-all').addEvent('click', function() {
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
	 
	 
	 $('content-browse-images').addEvent('click', function() {
	 var filter = {'Images (*.jpg, *.jpeg, *.gif, *.png)': '*.jpg; *.jpeg; *.gif; *.png'};
	 
	 swiffy.options.typeFilter = filter;
	 return false;
	 });
	 */
	$('content-clear').addEvent('click', function() {
		$('upload-status').set('html', "Click 'Browse' to select file(s)");
		$('content-browse-all').addClass('active');
		$('content-upload').removeClass('active');
		swiffy.removeFile();
		return false;
	});

	$('content-upload').addEvent('click', function() {
		swiffy.upload();
		return false;
	});

	$('add-descriptions').addEvent('click', function() {
		// GET request to edit action with all uploaded object ids
		h = $('content-ids');
		if (h && (h.value != '')) {
			$('add_descriptions_form').submit();
		} else {
			alert('No files to describe!');
		}
	});
});
