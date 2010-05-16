////////////////////////////////////////////////////////////////////////////////////////
//
// Eternos Timeline Artifact Section
//
var ETLArtifactSection = Class.create({
	initialize: function(domID) {
		this.MaxDisplayCount 	= 10;
		this.pixPerRow				= 3;
		// Set this to true|false
		this.doRandomize = false;

		this.parent = $(domID);
		this.timeOut = 3;
		this.title = "Artifacts";
		this.items = [];
		this.template = ETemplates.artifactTemplates.artifacts;
		this.loadingTemplate = ETemplates.loadingTemplate;
		this.boxTemplate = ETemplates.artifactTemplates.artifactBox;

		this.showLoading();
	},
	// Returns collection of artifacts for the given month
	// Skip any items that don't have thumbnail or don't fall on target month
	_itemsInMonth: function(date) {
		var targetDate = date.startingMonth();

		ETDebug.log("Looking for artifacts in collection of " + this.items.size() + " items matching date: " + targetDate);
		return this.items.findAll(function(i) {
			return (i !== undefined) && (i.attributes.thumbnail_url !== undefined) && (i.getEventDateObj().startingMonth() === targetDate);
		});
	},
	_itemsToS: function(activeDate) {
		var i, j, rows, numDisplay;
		var s = '',
			ul_class;
		var item, artis = this._itemsInMonth(activeDate);

		if ((numDisplay = Math.min(artis.length, this.MaxDisplayCount)) > 0) {
			artis.randomize();
		}
		ETDebug.log("Displaying " + numDisplay + " out of " + artis.length + " artifacts for: " + activeDate);

		for (i=0, j=0; i<numDisplay; i++) {
			item = artis[i];
			ETDebug.log("Adding artifact #" + i + ": type: " + item.type);

			s += this.boxTemplate.evaluate({
				id: item.getID(),
				num: i,
				style: 'artifact-thumbnail',
				url: item.getURL(),
				thumbnail_url: item.getThumbnailURL(),
				title: item.getTitle(),
				caption: item.getText()
			});
			// In rows of pixPerRow
			if (((j+1) % this.pixPerRow) == 0) {
				//s += '<br/>';
			}
		}
		// Add remaining artifacts, but hide them.  Lightview will include them in slideshow.
		if (numDisplay < artis.length) {
			for (i=numDisplay; i<artis.length; i++) {
				item = artis[i];
				ETDebug.log("Adding hidden artifact #" + i + ": type: " + item.type);

				s += this.boxTemplate.evaluate({
					id: item.getID(),
					num: i,
					style: 'artifact-thumbnail hidden',
					url: item.getURL(),
					thumbnail_url: item.getThumbnailURL(),
					title: item.getTitle(),
					caption: item.getText()
				});
			}
			s += '<br/>' + artis.length + ' artifacts found.  ';
		} else {
			s += '<br/>';
		}
		if (numDisplay > 0) {
			s += 'Click any artifact to launch slideshow';
		} else {
			s = 'No artifacts for this time period';
		}
		return s;
	},
	_write: function(content) {
		var c = content || '';
		if (c === '' || this.items.length < 1) {
			c = (div = $('artifact_info')) ? div.innertHTML : ''; //that.utils.blankArtifactImg;
		}
		this.parent.innerHTML = this.template.evaluate({
			title: this.title,
			artifacts: c
		});
	},
	// Returns collection of artifacts for the given date
	itemsInDate: function(date) {
		ETDebug.log("Looking for artifacts in collection of " + this.items.size() + " items matching date: " + date);
		var dateObj = date.toDate();
		return this.items.findAll(function(i) {
			return (i !== undefined) && (i.attributes.thumbnail_url !== undefined) && i.getEventDateObj().clearTime().equals(dateObj);
		});
	},
	// Adds artifact event object to internal collection, returns 
	// true if added.
	addItem: function(item) {
		// Skip artifacts with missing source or if already added
		ETDebug.log("add artifact: " + item.type);
		if ((item.getURL() == null) || this.contains(item)) {
			ETDebug.log("not added");
			return false;
		}
		this.items.push(item);
		return true;
	},
	addItems: function(items) {
		this.items.concat(items);
	},
	empty: function() {
		this.items.clear();
	},
	// Returns true if items list contains item with the same source url
	contains: function(item) {
		return this.items.detect(function(i) {
			return item.getURL() === i.getURL();
		});
	},
	populate: function(activeDate) {
		this._write(this._itemsToS(activeDate));
	},
	showLoading: function() {
		this._write(this.loadingTemplate.evaluate({
			type: " Artifacts"
		}));
		//	load_busy(this.parent);
	},
	updateTitle: function(title) {
		this.title = title;
		this._write();
	}
	/*
	, randomize: function() {
		var i, j, tmp, tmp_title;
		var v = $$('li.visible-artifact-item');
		var h = $$('li.hidden-artifact-item');
		if (v.length === 0 || h.length === 0) {
			return;
		}

		if (this.doRandomize) {
			new PeriodicalExecuter(function(pe) {
				if (v.length > 0 && h.length > 0) {
					i = Math.floor(Math.random() * v.length);
					j = Math.floor(Math.random() * h.length);
					tmp = v[i]; // <a><img>...</a>
					tmp_title = v[i].down().title;

					v[i].pulsate({
						pulses: 1,
						duration: 1.5
					});
					// TODO: Fix me
					// This is f'd up - title attibutes get lost, and we start seeing 
					// a lot of duplicates in artifacts
					ETDebug.log("Swapping artifact with html: " + h[j].innerHTML);
					v[i].update(h[j].innerHTML);
					if (h[j].down().title !== '') { // correct some weirdness
						ETDebug.log("setting title attribute: " + h[j].down().title);
						v[i].down().writeAttribute({
							title: h[j].down().title
						});
					}
					ETDebug.log("Swapping artifact with html: " + tmp.innerHTML);
					h[j].update(tmp.innerHTML);
					//ETDebug.log("setting title attribute: " + tmp_title);
					//h[j].down().writeAttribute({title: tmp_title});
				}
			}.bind(this), this.timeOut);
		}
	}
	*/
});
