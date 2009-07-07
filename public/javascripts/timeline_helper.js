var tl;
 function loadTimeline() {
   var bandInfos = [
     Timeline.createBandInfo({
         width:          "70%",
         intervalUnit:   Timeline.DateTime.MONTH,
         intervalPixels: 100
     }),
     Timeline.createBandInfo({
         width:          "30%",
         intervalUnit:   Timeline.DateTime.YEAR,
         intervalPixels: 200
     })
   ];
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