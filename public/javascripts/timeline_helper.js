//initialize Timeline 
var tl;
function tl_init(event_source) {
   var theme = Timeline.ClassicTheme.create();
   var bandInfos = [
     Timeline.createBandInfo({
         width:          "15%",
         intervalUnit:   Timeline.DateTime.YEAR,
         intervalPixels: 150,
         overview: true,
         theme: theme
     }),
     Timeline.createBandInfo({
         width:          "85%",
         intervalUnit:   Timeline.DateTime.MONTH,
         intervalPixels: 200,
         eventSource: event_source,
         theme: theme
     })
   ];
   bandInfos[1].syncWith = 0;
   bandInfos[1].highlight = true; 
   tl = Timeline.create(document.getElementById("my-timeline"), bandInfos);
   
   //event listener for timeline band scrolling
   tl.getBand(0).addOnScrollListener(function(band){
     var min_date = tl_format_date(band.getMinDate(), 'rails');
     var max_date = tl_format_date(band.getMaxDate(), 'rails');
     var el_options = 'fake';
     tl_search(window._tl_member_id, min_date, max_date, el_options);
   });
   
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
  window._tl_member_id = member;
  new Ajax.Request('/timeline/search/js/'+member+'/'+start_date+'/'+end_date+'/'+options, {
      method: 'get',
      onSuccess: function(transport){
        var response = transport.responseText || "";
        tl_toggle_timeline_details();
        tl_parse_events(response);
      },
      onFailure: function(){
        tl_on_failure();
      },
      onLoading: function(){
        tl_on_loading();
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
  var tl_title = tl_desc = tl_img = tl_link = tl_icon = tl_color = tl_tcolor = null;
  var tl_date = new Date();
  var asset_url = "http://simile.mit.edu/timeline/api/";
  var imgs_url = asset_url + "images/";
    
  if (event.facebook_activity_stream_item){
    fb_event = event.facebook_activity_stream_item
    
    tl_icon = imgs_url + "dark-blue-circle.png";
    tl_color = tl_tcolor = "blue";
    if (fb_event.published_at) {
      tl_date = tl_format_date(fb_event.published_at);
    }
    
    switch (fb_event.attachment_type) {
      case "photo" :
        tl_title = "Uploaded photo";
        tl_desc = fb_event.message;
        tl_img = fb_event.src;
        break;
      case "link" :
        tl_title = "Wall posting";
        tl_desc = fb_event.message;
        tl_link = fb_event.src;
        break;
      case null :
        tl_title = "Updated status";
        tl_desc = fb_event.message;
        tl_img = "";
        break;
      default: 
        tl_title = "Facebook post";
        tl_desc = fb_event.message;
        tl_img = "";
        break;                  
    }
  } else if (event.twitter_activity_stream_item){
    tw_event = event.twitter_activity_stream_item
    
    tl_color = tl_tcolor = "cyan";
    tl_icon = imgs_url + "dull-green-circle.png";
    if (tw_event.published_at){
      tl_date = tl_format_date(tw_event.published_at);
    }
    
    tl_title = "Post a tweet";
    tl_desc = tw_event.message;
  } else if (event.backup_photo) {
    if (event.backup_photo.created_at){
      tl_date = tl_format_date(event.backup_photo.created_at);
    }
    
    tl_icon = imgs_url + "gray-circle.png";
    tl_color = tl_tcolor = "gray";
    tl_title = "Backup photo";
    tl_desc = event.backup_photo.caption;
    tl_img = event.backup_photo.source_url;
  } else if (event.backup_email){
    tl_icon = imgs_url + "red-circle.png";
    tl_color = tl_tcolor = "red";
    if (event.backup_email.received_at) {
      tl_date = tl_format_date(event.backup_email.received_at);
    }
    
    tl_title = "Receiving an email";
    tl_desc = "FROM: " + event.backup_email.sender[0] + "; SUBJECT: " + event.backup_email.subject;
  } else if (event.feed_entry) {
    if (event.feed_entry.published_at){
      tl_date = tl_format_date(event.feed_entry.published_at);
    }
    
    tl_icon = imgs_url + "dull-red-circle.png";
    tl_color = tl_tcolor = "orange";
    tl_title = "New feed item";
    tl_desc = "SOURCE: " + event.feed_entry.name + "; DESCRIPTION: " + event.feed_entry.summary;
    tl_link = event.feed_entry.url;
  }
  
  var return_event = new Timeline.DefaultEventSource.Event(
    tl_date, tl_date, tl_date, tl_date, true, 
    tl_title, tl_desc, tl_img, tl_link, tl_icon, tl_color, tl_tcolor);
    
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

//populate each artifact image
function tl_populate_artifact_images(images){
  var source_images = images.sort(function(){return 0.5 - Math.random()});
  var thumbnails = $$('img.thumnails2')
  for (i=0;i<thumbnails.length;i++){
    thumbnails[i].src = source_images[i];
  }
}

//get objects for stories section
function tl_get_story_object(){
  //TODO:
}

//populate objects for story section
function tl_populate_story_objects(images){
  var source_images = images.sort(function(){return 0.5 - Math.random()});
  var thumbnails = $$('img.thumnails1')
  for (i=0;i<thumbnails.length;i++){
    thumbnails[i].src = source_images[i];
  }
}

//format date from rails response for timeline date format
function tl_format_date(date, format){
  if (format == null) {
    var year = date.substr(0, 4);
    var month = date.substr(5, 2);
    var day = date.substr(8, 2);
    rv_date = new Date(year, month, day);
  }else{
    rv_date = date.getFullYear() +'-'+ date.getMonth() +'-'+ date.getDate();
  }
  return rv_date;
}

//display blank timeline(without points)
function tl_blank(){
  var event_source = new Timeline.DefaultEventSource();
  tl_init(event_source);
}

//behavior on timeline loading
function tl_on_loading(){
  //TODO:
}

//action if timeline failure
function tl_on_failure(){
  tl_blank();
}

//show/hide stories, artifacts and backup progress
function tl_toggle_timeline_details(){
  $('timeline-detail').toggle();
}

//handling on failure
function tl_show_on_failure(){
  
}

//on timeline drag event
function tl_on_drag(){
  
}


