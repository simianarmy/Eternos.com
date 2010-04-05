// Utility functions

// required Date' prototypes
Date.prototype.numDays = function() {
	return this.getDaysInMonth(this.getFullYear(), this.getMonth());
};
Date.prototype.getFullMonth = function() {
	var m = this.getMonth() + 1 + "";
	return (m.length < 2) ? "0" + m : m;
};
// Returns YYYY-MM-DD string with day set to beginning of the month
Date.prototype.startingMonth = function() {
	return this.getFullYear() + "-" + this.getFullMonth() + "-01";
};
// Returns YYYY-MM-DD string with day set to end of the month
Date.prototype.endingMonth = function() {
	return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.numDays();
};
// Return YYYY-MM-DD string representation of the date
Date.prototype.toMysqlDateString = function() {
	return this.getFullYear() + "-" + this.getFullMonth() + "-" + this.getDate();
};
Date.prototype.getMonthName = function() {
	var nm = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	var nu = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
	return nm[this.getMonth()];
};

Date.prototype.monthRange = function(num, dir) {
	var set_up = function(d) {
		d.setMonth(d.getMonth() + num);
	};
	var set_down = function(d) {
		d.setMonth(d.getMonth() - num);
	};

	dir == 'next' ? set_up(this) : set_down(this);
	var rv = this.getFullYear() + "-" + this.getFullMonth() + "-" + this.getDate();
	dir == 'next' ? set_down(this) : set_up(this);

	return rv;
};
// Compares date to other date & returns true iff year & month are the same
Date.prototype.equalsYearMonth = function(other) {
	return (this.getYear() === other.getYear()) && (this.getFullMonth() === other.getFullMonth());
};
Date.prototype.equalsDay = function(other) {
	return this.clone().clearTime().equals(other.clone().clearTime());
};
// isMonthAfter
// Returns true iff  date's month is > passed dated
Date.prototype.isMonthAfter = function(d) {
	return this.clone().moveToFirstDayOfMonth().clearTime() > d.clone().moveToFirstDayOfMonth().clearTime();
};

// required Array' prototypes 
Array.prototype.unique = function() {
	var r = new Array();
	o: for (var i = 0, n = this.length; i < n; i++) {
		for (var x = 0, y = r.length; x < y; x++) {
			if (r[x] == this[i]) {
				continue o;
			}
		}
		r[r.length] = this[i];
	}
	return r;
};
// Fisher-Yates randomization
Array.prototype.randomize = function() {
	var i = this.length;
	var j, tempi, tempj;

	if (i === 0) return false;
	while (--i) {
		j = Math.floor(Math.random() * (i + 1));
		tempi = this[i];
		tempj = this[j];
		this[i] = tempj;
		this[j] = tempi;
	}
	return this;
};

//Date parsing regex & sort function
var MysqlDateRE = /^(\d{4})\-(\d{2})\-(\d{2})T?.*/;
var mysqlTimeToDate = function(datetime) {
	//function parses mysql datetime string and returns javascript Date object
	//input has to be in this format: 2007-06-05 15:26:02
	var regex = /^([0-9]{2,4})-([0-1][0-9])-([0-3][0-9]) (?:([0-2][0-9]):([0-5][0-9]):([0-5][0-9]))?$/;
	var parts = datetime.replace(regex, "$1 $2 $3 $4 $5 $6").split(' ');
	return new Date(parts[0], parts[1] - 1, parts[2], parts[3], parts[4], parts[5]);
};
//function parses mysql datetime string and returns javascript Date object
//input has to be in this format: 2007-06-05
var mysqlDateToDate = function(date) {
	var parts = date.replace(MysqlDateRE, "$1 $2 $3").split(' ');
	return new Date(parts[0], parts[1] - 1, parts[2]);
};
var orderDatesDescending = function(x, y) {
	x = x.replace(MysqlDateRE, "$1$2$3");
	y = y.replace(MysqlDateRE, "$1$2$3");
	if (x > y) return -1;
	if (x < y) return 1;
	return 0;
};
String.prototype.toDate = function() {
	return mysqlDateToDate(this);
};
String.prototype.toMysqlDateFormat = function() {
	return this.replace(MysqlDateRE, "$1 $2 $3").split(' ').join('-');
};
String.prototype.toISODate = function() {
	var dt = Date.parseExact(this, "yyyy-MM-ddTHH:mm:ssZ");
	if (!dt) {
		dt = this.toDate();
	}
	return dt;
};
// Timeline-wide debug flag
var DEBUG_BOX = false; // show debug in box
// Timeline debug module
var ETDebug = function() {
	function onpage(msg) {
		if (DEBUG_BOX) {
			$('debug_box').innerHTML += msg + ' ';
			log(msg);
		}
	};
	function log(msg) {
		if (ETERNOS.debug) {
			console.log(msg);
		}
	};
	function dump(msg) {
		if (ETERNOS.debug) {
			console.dir(msg);
		}
	};
	return {
		onpage: onpage,
		log: log,
		dump: dump
	};
} ();

//Eternos Timeline Date
var ETLDate = Class.create({
	initialize: function(date, format) {
		this.inDate = date;
		this.inFormat = format || 'natural';
		this.getOutDate();
	},
	getOutDate: function() {
		if (this.inFormat == 'natural') {
			this.outDate = this.inDate.getFullYear() + '-' + this.inDate.getMonth() + 1 + '-' + this.inDate.getDate();
		} else if (this.inFormat == 'gregorian') {
			this.outDate = Timeline.DateTime.parseGregorianDateTime(this.inDate.substr(0, 4));
		} else if (typeof this.inDate === 'string') {
			this.outDate = this.inDate.toISODate();
		}
		return this.outDate;
	}
});

// This probably isn't needed anymore...
function getWinHeight() {
	return win_dimension()[1] * 0.8;
};
