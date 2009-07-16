//initialize Timeline 
var tl;
function tl_init(event_source) {
   var bandInfos = [
     Timeline.createBandInfo({
         width:          "15%",
         intervalUnit:   Timeline.DateTime.YEAR,
         intervalPixels: 150,
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

//search Timeline events
function tl_search(member, start_date, end_date, options){
  new Ajax.Request('/timeline/search/js/'+member+'/'+start_date+'/'+end_date+'/'+options, {
      method:'get',
      onSuccess: function(transport){
        var response = transport.responseText || "";
        tl_parse_events(response);
      },
      onFailure: function(){
        tl_init('');
      }
  });
}

//parse returning response from Timeline search
function tl_parse_events(source){
  var events = source.evalJSON();
  var event_source = new Timeline.DefaultEventSource();
  
  for(var i=0;i<events.results.length-1;i++) {
    var event = tl_create_event_source(events.results[i], event_source);
    event_source.add(event);
  };
  tl_init(event_source);
}

//create event source
function tl_create_event_source(source){
  var event = source.event;
  var tl_title = tl_desc = tl_img = tl_link = null;
  var date_event = new Date();
  date_event.setTime(date_event.getTime() + ((Math.floor(Math.random()*41) - 20) * 24 * 60 * 60 * 1000));   
    
  if (event.facebook_activity_stream_item){
    switch (event.facebook_activity_stream_item.attachment_type) {
      case "photo" :
        tl_title = "Uploaded photo";
        tl_desc = event.facebook_activity_stream_item.message;
        tl_img = event.facebook_activity_stream_item.src;
        break;
      case "link" :
        tl_title = "Posted link";
        tl_desc = event.facebook_activity_stream_item.message;
        tl_link = event.facebook_activity_stream_item.src;
        break;
      case null :
        tl_title = "Updated status";
        tl_desc = event.facebook_activity_stream_item.message;
        tl_img = "";
        break;
      default: 
        tl_title = "Updated status";
        tl_desc = event.facebook_activity_stream_item.message;
        tl_img = "";
        break;                  
    }
  } else if (event.backup_photo) {
    tl_title = "Backup photo";
    tl_desc = event.backup_photo.caption;
    tl_img = event.backup_photo.source_url;
  }
  
  var return_event = new Timeline.DefaultEventSource.Event(
    date_event, date_event, date_event, date_event, true, 
    tl_title, tl_desc, tl_img);
    
  return return_event;       
}

//create objects for Timeline detail
function tl_create_event_detail(){
  
}

