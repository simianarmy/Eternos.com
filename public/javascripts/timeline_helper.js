var tl;
function loadTimeline(event_source) {
   var bandInfos = [
     Timeline.createBandInfo({
         width:          "15%",
         intervalUnit:   Timeline.DateTime.YEAR,
         intervalPixels: 100,
         overview: true
     }),
     Timeline.createBandInfo({
         width:          "85%",
         intervalUnit:   Timeline.DateTime.MONTH,
         intervalPixels: 200,
         eventSource: event_source
     })
   ];
   
   bandInfos[1].syncWith = 0;
   bandInfos[1].highlight = true; 
   
   tl = Timeline.create(document.getElementById("my-timeline"), bandInfos);
}

var resizeTimerID = null;
function onResize() {
   if (resizeTimerID == null) {
       resizeTimerID = window.setTimeout(function() {
           resizeTimerID = null;
           tl.layout();
       }, 500);
   }
}
 
function loadTimelineEvents(member, start_date, end_date, options){
  new Ajax.Request('/timeline/search/js/'+member+'/'+start_date+'/'+end_date+'/'+options, {
      method:'get',
      onSuccess: function(transport){
        var response = transport.responseText || "";
        populateTimelineEvents(response);
        },
      onFailure: function(){ 
      // error handling here
      }
  });   
}

function populateTimelineEvents(source){
  var event_source = source.evalJSON();
  
  var eventSource = new Timeline.DefaultEventSource();
  for(var i=0;i<event_source.results.length-1;i++) {
      var dateEvent = new Date();
      dateEvent.setTime(dateEvent.getTime() + ((Math.floor(Math.random()*41) - 20) * 24 * 60 * 60 * 1000));
      var evt = new Timeline.DefaultEventSource.Event(
         dateEvent, 
         dateEvent, 
         dateEvent, 
         dateEvent, 
         true,
         "Event " + event_source.results[i], "Description for Event " + i );
      eventSource.add(evt);
  };
  loadTimeline(eventSource);
}
