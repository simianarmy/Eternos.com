////////////////////////////////////////////////////////////////////////////////////////
//
// Eternos Timeline Date Selector
//
var ETLMonthSelector = Class.create({
	initialize: function(domID) {
		this.parent = $(domID);
		this.activeDate = new Date();
		this.advanceMonths = new Array();
		this.pastMonths = new Array();
		this.monthUpDisabled = false;
		this.yearUpDisabled = false;
		this._enableNavButtons();
	},
	_populate: function() {
		$('display_month').innerHTML = this.activeDate.getMonthName();
		$('display_year').innerHTML = this.activeDate.getFullYear();

		if (!this._canClickNextMonth()) {
			this._disableClick('month_selector_up');
			this.monthUpDisabled = true;
		} else if (this.monthUpDisabled) {
			this._enableClick('month_selector_up');
			this.monthUpDisabled = false;
		}
		if (!this._canClickNextYear()) {
			this._disableClick('year_selector_up');
			this.yearUpDisabled = true;
		} else if (this.yearUpDisabled) {
			this._enableClick('year_selector_up');
			this.yearUpDisabled = false;
		}
	},
	_canClickNextMonth: function() {
		return this.activeDate.clone().addMonths(1).moveToFirstDayOfMonth().compareTo(Date.today()) !== 1;
	},
	_canClickNextYear: function() {
		return this.activeDate.clone().addYears(1).moveToFirstDayOfMonth().compareTo(Date.today()) !== 1;
	},
	_disableClick: function(id) {
		new Effect.Opacity(id, {
			from: 1.0,
			to: 0.4
		});
	},
	_enableClick: function(id) {
		new Effect.Opacity(id, {
			from: 0.4,
			to: 1.0
		});
	},
	_enableNavButtons: function() {
		$('month_selector_down').observe('click', function(event) {
			event.stop();
			this.stepDate(this.activeDate.clone().addMonths(-1));
		}.bind(this));
		$('year_selector_down').observe('click', function(event) {
			event.stop();
			this.stepDate(this.activeDate.clone().addYears(-1));
		}.bind(this));
		$('month_selector_up').observe('click', function(event) {
			event.stop();
			if (this._canClickNextMonth()) {
				this.stepDate(this.activeDate.clone().addMonths(1));
			}
		}.bind(this));
		$('year_selector_up').observe('click', function(event) {
			event.stop();
			if (this._canClickNextYear()) {
				this.stepDate(this.activeDate.clone().addYears(1));
			}
		}.bind(this));
	},
	setDate: function(date) {
		this.activeDate = date;
	},
	update: function(date) {
		if (date) {
			this.setDate(date);
		}
		this._populate();
	},
	stepDate: function(newDate) {
		if (newDate.isMonthAfter(Date.today())) {
			// Don't allow stepping into the future
			return;
		}
		ETDebug.log("Date selector stepping from " + this.activeDate + " to " + newDate);
		this.setDate(newDate);
		ETERNOS.timeline.getBase().onNewDate(newDate);
	}
});
