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
  new Ajax.Request('http://staging.eternos.com/timeline/search/js/'+member+'/'+start_date+'/'+end_date+'/'+options, {
      method: 'get',
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
  var artifact_images = new Array;
  var story_images = new Array;
  
  for(var i=0;i<events.results.length-1;i++) {
    if (events.results[i].event != null){
      var event = tl_create_event_source(events.results[i], event_source);
      event_source.add(event); 
      
      var artifact_image = tl_get_artifacts_image(events.results[i].event);
      artifact_images.push(artifact_image);      
    }
  };
  tl_init(event_source);
  tl_populate_artifact_images(artifact_images);
  tl_populate_story_objects(artifact_images);
}

//create event source
function tl_create_event_source(source){
  var event = source.event;
  var tl_title = tl_desc = tl_img = tl_link = null;
  var date_event = new Date();
  date_event.setTime(date_event.getTime() + ((Math.floor(Math.random()*41) - 20) * 24 * 60 * 60 * 1000));   
  
  if (event.facebook_activity_stream_item){
    fb_event = event.facebook_activity_stream_item
    switch (fb_event.attachment_type) {
      case "photo" :
        tl_title = "Uploaded photo";
        tl_desc = fb_event.message;
        tl_img = fb_event.src;
        break;
      case "link" :
        tl_title = "Posted link";
        tl_desc = fb_event.message;
        tl_link = fb_event.src;
        break;
      case null :
        tl_title = "Updated status";
        tl_desc = fb_event.message;
        tl_img = "";
        break;
      default: 
        tl_title = "Updated status";
        tl_desc = fb_event.message;
        tl_img = "";
        break;                  
    }
  } else if (event.facebook_activity_stream_item){
    tw_event = event.facebook_activity_stream_item
    tl_title = "Post a Tweet";
    tl_desc = tw_event.message;
  } else if (event.backup_photo) {
    tl_title = "Backup photo";
    tl_desc = event.backup_photo.caption;
    tl_img = event.backup_photo.source_url;
  } else if (event.backup_email){
  } else if (event.feed_entry) {
  }
  
  var return_event = new Timeline.DefaultEventSource.Event(
    date_event, date_event, date_event, date_event, true, 
    tl_title, tl_desc, tl_img);
    
  return return_event;       
}

//create objects for Artifacts
function tl_get_artifacts_image(event){
  var image = "";
  if (event.facebook_activity_stream_item){
    if (event.facebook_activity_stream_item.attachment_type == "photo"){
      img_url = event.facebook_activity_stream_item.src;
      image = image_url;      
    }
  } else if (event.backup_photo){
    image_url = event.backup_photo.source_url;
    image = image_url;
  }
  
  if (image != ""){
    return image;
  }
}

// populate each artifact image
function tl_populate_artifact_images(images){
  var source_images = images.sort(function(){return 0.5 - Math.random()});
  var thumbnails = $$('img.thumnails2')
  for (i=0;i<thumbnails.length;i++){
    thumbnails[i].src = source_images[i];
  }
}

function tl_get_story_object(){
  
}


function tl_populate_story_objects(images){
  var source_images = images.sort(function(){return 0.5 - Math.random()});
  var thumbnails = $$('img.thumnails1')
  for (i=0;i<thumbnails.length;i++){
    thumbnails[i].src = source_images[i];
  }
}

function tl_blank(){
  var event_source = new Timeline.DefaultEventSource();
  tl_init(event_source);
}

function tl_update_contents(){
  
}
