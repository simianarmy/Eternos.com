/* $Id */

// Media object handlers for out-of-control tooltip generator code in timeline_helper

var TooltipMedia = function() {
	var that = {};
	
	var videoExpandDimensions = {
		width: 406,
		height: 303
	};
	var videoThumbDimensions = {
		width: 100,
		height: 100
	};
	// create new video player objects for tooltip videos
	that.setupVideoPlayback = function(id, ui) {
		var flowsel = 'div#' + ETemplates.tooltipTemplateID(id, 'media') + ' a.player';
		var fp;

		ETDebug.log("flowplayer selector = " + flowsel);

		// Check for existing players for this tooltip
		// Players become useless if screen is lost, but no easy way to 
		// recreate them.
		// TODO: Right now we destroy entire tooltip & rebuild on every mouseover, 
		// just to get around this Flowplayer issue...should figure it out some day.
		ETDebug.log("creating new flowplayer for " + flowsel);
		create_flowplayer(flowsel, {
			clip: {
				autoBuffering: true,
				autoPlay: true,
				bufferLength: 1 // For annoying loading spinner if recording < bufferLength
			},
			debug: false,

			onBeforeClick: function() {
				// unload previously loaded player 
				$f().unload();

				// get wrapper element as jQuery object 
				var wrap = jQuery(this.getParent());

				// hide nested play button 
				wrap.find("img").fadeOut();

				// start growing animation
				// TODO: configurable start, end dimensions
				wrap.animate(
					videoExpandDimensions, 500, function() {
					// when animation finishes we will load our player 
					$f(this).load();
				});

				// disable default click behaviour (player loading) 
				return false;
			},

			// unload action resumes to original state         
			onUnload: function() {
				jQuery(this.getParent()).animate(
					videoThumbDimensions, 500, function() {
					// make play button visible again 
					jQuery(this).find("img").fadeIn();
				});
				return false;
			},

			// when playback finishes perform our custom unload action 
			onFinish: function() {
				this.unload();
			}
		});
	};
	// Using SoundManager & inline player javascript
	that.setupAudioPlayback = function(id) {
		if (soundManager !== null) {
			if (inlinePlayer === null) {
				// Fire it up
				soundManager.reboot();
			} else {
				// May need to do this only once...
				inlinePlayer.init();
			}
		} else {
			alert('Sorry there was an error playing the audio file!  Please use Feedback if this is not fixed in a few hours.');
			ETDebug.log("ERROR no soundmanager object!");
		}
	};
	return that;
} ();
