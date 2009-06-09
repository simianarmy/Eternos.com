// $Id$
//
// Builds from lightview slideshow to support audio/video tracks

var SlideShow = Class.create();

SlideShow.prototype = {
	
	initialize: function(element, options) {
		// SoundManager should autoload audio file
		// and should be accessible from SMSound object
		// Try to set property
		this.container = element;
		this.narrative = false;
		this.narrativePlaying = false;
		this.state = 'started';
		this.currentSlideNum = 0;
		this.currentAudio;
		this.sounds = {};
		this.slides = $$('.lightview');
		this.numSlides = this.slides.length || 0;
		this.opts = Object.extend({
			perSlideDelay: 5,
			with_track: true
		}, options);
		
		if (!this.numSlides) {
			// throw/log some kind of error
			return;
		}
		if (options.with_track) {
			this.getAudioTrack();
		}
		this.collectMedia();
		this.calculateSlideDisplayTimes();
		
		if (this.narrative) {
			soundManager.onfinish = function() {
				this.narrativePlaying= false;
			}.bind(this);
		}
		// Called on every slide
		this.container.observe('lightview:opened', function() {
			var currentSlideId = Lightview.element.id;
			this.debug( "slide id: " + currentSlideId );
			this.currentSlideNum = this.getSlideNumById(currentSlideId);
			this.debug( "on slide # = " + this.currentSlideNum );
			clearTimeout(this.timer);
			
			// On manual nav click (forward)
			if (this.currentAudio && (this.currentAudio.playState == 1)) {
				this.currentAudio.stop();
			}
			// Resume narrative audio if paused
			if (this.narrative && this.narrative.paused()) {
				this.narrative.resume();
			}
			// Pause narrative audio if slide contains sound
			if (currentSlideId.match(/(audio|music|video)/)) {
				this.pause();
				if (this.currentAudio = this.sounds[this.getSlideMediaId(currentSlideId)]) {
					this.currentAudio.play();
				}
			}
			// Don't bother setting timeout on video slide, just let user navigate away
			// when ready
			if (false === /video/.test(currentSlideId)) {
				this.setShowTime();
			}
		}.bind(this));
	
		// Called when lightview close action triggered
		this.container.observe('lightview:hidden', function() {
			this.close();
		}.bind(this));
	},
	start: function(element) {
		this.debug("Starting slideshow");
		this.state = 'started';
		if (this.audio) {
			this.debug("Starting audio narration");
			this.narrative.onplay = this.showNextSlide(0);
			this.narrative.play();
			this.narrativePlaying = true;
		} else {
			 this.showNextSlide(0);
		}
	},
	stop: function() {
		this.debug("Stopping slideshow");
		this.state = 'stopped';
		clearTimeout(this.timer);
		this.narrative && this.narrative.stop();
		$H(this.sounds).values().each(function(a) a.stop());
		this.narrativePlaying = false;
		this.currentSlideNum = 0;
		//Lightview.stopSlideshow();
	},
	pause: function() {
		this.debug("Pausing slideshow audio");
		this.narrative && this.narrative.pause();
		//Lightview.stopSlideshow();
	},
	setShowTime: function() {
		timeout = this.slides[this.currentSlideNum-1].duration
		this.debug("Setting current slide timeout to " + timeout);
		this.timer = setTimeout(function() { that.showNextSlide(that.currentSlideNum); }, timeout*1000);
	},
	showNextSlide: function(slideNum) {
		// Handle case where slide has changed from a non-timeout event (manual nav)
		var that = this;
		
		if (slideNum != this.currentSlideNum) {
			this.debug("Unexpeced slide # for showNextSlide: " + slideNum);
			//setTimeout(function() { that.nextSlide(that.currentSlideNum++); }, timeout*1000);
		}
		else if (slideNum >= this.numSlides) {
			this.stop();
		}  
		else { 
			this.currentSlideNum++;
			Lightview.show(this.slides[slideNum].id);
		}
	},
	getSlideNumById: function(slideId) {
		var idx = -1;
		this.slides.each(function(val, index) {
			if (val.id == slideId) { 
				idx = index;
			}
		});
		return idx+1;
	},
	close: function() {
		this.stop();
		//soundManager.reboot();
	},
	// Uses narrative audio duration to calculate per-slide display time
	getAudioTrack: function() {
		// Narration audio
		if (audio = $$('a#narration.sm2_link')) {
			this.narrative = audio[0];
			soundManager.createSound({
				id: "slideshow_audio_narration",
			  url: audio.href,
			  volume: 50,
				duration: audio.readAttribute('duration')
			});
			// Calculate per-slide display time
			if (duration = audio.options.duration) {
				this.debug("Audio duration: " + duration)
				Lightview.options.slideshowDelay = this.opts.perSlideDelay = 
					durationToSeconds(duration) / this.numSlides;
			}
		}
	},
	collectMedia: function() {
		// Fetches audio links from page and prepares for playback.
		that = this;
		$$('a.sm2_link').each(function(audio) {
			that.sounds[audio.id] = soundManager.createSound({
				id: audio.id,
			  url: audio.href,
			  volume: 50,
				duration: audio.readAttribute('duration'),
			//	onfinish: function() { that.nextSlide(); }
			});
		});
	},
	// Calculate display times per slide based on content type
	// Playable content needs to be displayed for their duration, 
	// all others for use delay calculated in collectAudio()
	calculateSlideDisplayTimes: function() {
		this.slides.each(function(slide, index) {
			if (d = $(slide.id).readAttribute('duration')) {
				slide.duration = parseInt(d) + 4; // Add extra time for video/audio to load
			} else {
				slide.duration = this.opts.perSlideDelay;
			}
			this.debug( "Display time for slide: " + slide.id + ' = ' + 
			 	slide.duration);
		}.bind(this));
	},
	// Determines if slide contains an audio object
	isAudioSlide: function(slide) {
		return /(audio|music)/.test(slide.id);
	},
	// Returns slide's media object, if any
	getSlideMediaId: function(slideId) {
		match = /slide_(\S+_\d+)$/.exec(slideId);
		return match[1];
	},
	debug: function(msg) {
		if (window.console) {
			console.log(msg);
		}
	}
};

function durationToSeconds(d) {
	return d / 1000;
}
