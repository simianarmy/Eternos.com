// $Id$

// module for backup progress bar displaying & updating

var backupProgressBar = function() {
	var that = {};
	that.onProgressChange = function(id, percentage) {
		//console.log("onProgressChange " + id + " = " + percentage);
		// This is very dependent on html ids, will break if html ids or classes are modified
		var tipid = id.replace('complete', 'tip');
		$(tipid).down('.job_percent_complete').innerHTML = percentage;
		if (percentage >= 100) {
			$(tipid).down('.job_status').innerHTML = 'Finished';
		}
	};
	return that;
}();