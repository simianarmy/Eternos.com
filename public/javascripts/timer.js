var timer = {
	minutes :0,
	seconds : 0,
    completeTarget :0,
	elm :null,
	samay : null,
	sep : ':',
	init : function(m,s,elm, ct)
	{
		m = parseInt(m,10);
		s = parseInt(s,10);
        completeTarget = ct;
		if(m<0 || s<0 || isNaN(m) || isNaN(s)) { alert('Invalid Values'); return; }
		this.minutes = m;
		this.seconds = s;
		this.elm = document.getElementById(elm);
		timer.start();
	},
	start : function()
	{
		this.samay = setInterval((this.doCountDown),1000);
	},
	doCountDown : function()
	{
		if(timer.seconds == 0)
		{
			if(timer.minutes == 0)
			{
				clearInterval(timer.samay);
				timerComplete(completeTarget);
				return;
			}
			else
			{
				timer.seconds=60;
				timer.minutes--;
			}
		}
		timer.seconds--;
		timer.updateTimer(timer.minutes,timer.seconds);
	},
	updateTimer :  function(min,secs)
	{
		min = (min < 10 ? '0'+min : min);
		secs = (secs < 10 ? '0'+secs : secs);
		/*(this.elm).innerHTML = min+(this.sep)+secs;*/
        (this.elm).innerHTML =secs;
	}
}
function timerComplete(completeTarget)
{
	window.location = completeTarget

}