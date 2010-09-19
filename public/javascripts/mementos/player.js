// $Id$
//
// Memento Player
//

// Adapter to more complex editor artifact selection object
// Wraps all the functions needed for playlist generation
var ArtifactSelectionAdapter = function() {
	var that = {};
	var artifacts;

	// Parses string from json object into artifact data, adds to 
	// selection
	that.loadFromJSON = function(json) {
		var slide, placeholder;
		console.log("Got url " + json.url);
		
		// Create new slide object similar to ArtifactSelection
		slide = jQuery('<div></div>');
		if (json.mediaType === 'html') {
			slide[0].userHtml = json.html;
		} else {
			slide.attr('src', json.url);
			slide.attr('content_id', json.cid);
			slide.attr('mediaType', json.mediaType);

			if (json.caption) {
				slide[0].text_description = json.caption;
			}
		}
		artifacts.push(slide[0]);
	};
	
	that.getSize = function() {
		// Return size + 1 to account for "drop here" slide
		return artifacts.size() + 1;
	};
	
	that.getArtifacts = function() {
		// Always return artifacts array with extra placeholder at end
		return artifacts.concat({});
	};
		
	that.init = function() {
		artifacts = new Array();
		// Add placeholder
		//artifacts.push({});
		
		return this;
	};
	return that;
}();

var SoundtrackAdapter = function() {
	var that = {};
	var soundtrack;
	
	// Loads soundtrack from json data
	that.loadFromJSON = function(json) {
		console.log("Loading audio: " + json.url);
		
		// Use json object as sound object
		json.source = json.url;
		json.content_id = json.cid;
		
		soundtrack.addAudio(json);
	};
	
	// Delegators
	that.getDuration = function() {
		return soundtrack.getDuration();
	};
	
	that.getTracks = function() {
		return soundtrack.getTracks();
	};
	
	that.getSize = function() {
		return soundtrack.getSize();
	};
	
	that.play = function() {
		soundtrack.play();
	};
	
	that.stop = function() {
		soundtrack.stop();
	};
	
	that.pause = function() {
		soundtrack.pause();
	};
	
	that.init = function() {
		// Create Soundtrack object without dom info
		soundtrack = Soundtrack.init(null);
		
		return this;
	};
	return that;
}();

// Player object - simplifed to load from json & begin playing
var MementoPlayer = function() {
	var that = {};

	var artifacts, 
		soundtrack,
		movieGenerator;
		
	// Play from json data
	that.play = function() {
		$('loading-indicator').hide();
		movieGenerator.preview();
	};
	
	// Initialize minimal setup
	that.init = function(title, artifactsJson, soundtrackJson) {
		artifacts = ArtifactSelectionAdapter.init();
		soundtrack = SoundtrackAdapter.init();
		
		// Pass adapter objects to main generator object that expects editor stuff
		movieGenerator = MovieGenerator.init(artifacts, soundtrack);
		
		// Now load data from json into objects, updating movie to recalculate
		// slide durations each time
		$A(artifactsJson).each(function(json) {
			artifacts.loadFromJSON(json);
			movieGenerator.movieUpdated();
		});
		$A(soundtrackJson).each(function(json) {
			soundtrack.loadFromJSON(json);
			movieGenerator.movieUpdated();
		});
		// Wait for audio ready custom event so that soundtrack playback works correctly
		document.observe('audio:ready', function() {
			that.play();
		});
		return this;
	};

	return that;
}();
