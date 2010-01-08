// $Id$
// JS for photo albums gallery - using jQuery
// Thanks to http://www.edesignerz.net/html/2671-recreating-the-mobileme-web-gallery-interface
// for the code & css

var current = 0; //The currently selected image
var view; //The currently selected view
var data = []; //The data for the currently selected album
var title = ""; //The title of the currently selected album
var sprite = ""; //The sprite of the currently selected album
var gridView, mosaicView; //the views, defined later

$j(document).ready(function() {
    view = gridView; //this referrs to a function that we havn't created yet
    albumView(); //render the album view

    //set up the jQuery UI slider for later use by the grid view
    $j("#slider").slider({
    	value: 75,
    	max: 150,
    	min: 50,
    	slide: function(event, ui) {
    	    $j('#content').css('font-size',ui.value+"px");
    	}
    });

    //setup the buttons for switching views
    $j("#grid").click(function() {
        $j("#views a.selected").removeClass("selected");
        $j(this).addClass("selected");
        gridView();
    });

    $j("#mosaic").click(function() {
        $j("#views a.selected").removeClass("selected");
        $j(this).addClass("selected");
        mosaicView();
    });

});

function albumView() {
    //remove everything from the content area that might have been there from other views,
    //as well as the back button (used later)
    $j("#content *").remove();
    $j(".button").remove();

    //add the album_view class to the content view, and extent it to the bottom of the window
    //also, hide the footer, and set the title of the gallery (in the data file)
    $j("#content").attr("class", "").addClass("album_view");
    $j("#controls").hide();
    $j("#content").css({ bottom: "0px", top: "57px" });
    $j("h1").removeClass("view").html(gallery);
    current = 0; 

    $j("<h2>Albums</h2>").appendTo("#content"); //add the title of the view
    $j.each(albums, function(i) {
    	//create the album, and register the click handler
        var item = $j('<div class="item">').click(function() {
            data = albums[i].photos;
            title = albums[i].name;
            //sprite = albums[i].cover_photo_url;
            view(); //go to current view
        });

        //create the skimmer, and set the background image to the sprite for the album (in the data file)
        //then register the mousemove event
        $j('<div class="skimmer">').css("background", "url("+this.cover_photo_url+") no-repeat center").mousemove(function(e) {
            var x = e.pageX;
            var offset = $j(this).offset().left;
            var w = 160 / albums[i].photos.length;
            var image = Math.floor((x - offset) / w);
            //$j(this).css("background-position", "0px " + (-160 * image) + "px");
						// Must use full-size image here even though it will be cutoff b/c thumbnails are 
						// smaller than the cover size.  Maybe we can set the size in the css?
						$j(this).css("background", "url("+albums[i].photos[image].url+") no-repeat center");
        }).mouseout(function() {
        	//when we mouseout, set the background position back to 0
            $j(this).css("background-position", "0px 0px");
        }).appendTo(item);

        //create the album title and the number of photos label
        $j('<strong/>').html(this.name).appendTo(item);
				if (!this.photos) {
					console.dir(this);
				} else {
        	$j('<span/>').html(this.photos.length + (this.photos.length > 1 ? " Photos" : " Photo")).appendTo(item);
				}
        item.appendTo("#content"); //add the item to the content area
    });
};

function gridView() {
    //remove everything from the content area that might have been there from other views,
    //add the grid_view class to the content view, and set up the title bar
    $j("#content *").remove();
    $j("#content").attr("class", "").addClass("grid_view");
    $j("h1").addClass("view").html(title).show();
    $j(".button").remove();  

    //set up the footer view, and the content area
    $j("#controls").show();
    $j("#controls #slider").show();
    $j("#content").css({ bottom: "40px", top: "57px" });

    view = gridView; //set the current view

    //add the back button
    $j('<div class="button">').html(gallery).click(function() {
        albumView(); //go back to the current view
    }).appendTo("body");

    //add the items in the album to the grid, and set the size of the image in ems.
    $j.each(data, function(i) {
        var item = $j('<div class="grid_item">').click(function() {
            largeView(this, i);
        });
        $j('<img/>').attr("src", this.url)
                   //.css("width", this.photo.width / 100 + "em")
                   //.css("height", this.photo.height / 100 + "em")
									 .css("width", 260 / 100 + "em")
                   .css("height", 192 / 100 + "em")
                   .appendTo(item);
        $j("<strong/>").html(this.description).appendTo(item);
        item.appendTo("#content");
    });
};

function mosaicView() {
    //remove everything from the content area that might have been there from other views,
    //add the grid_view class to the content view, and set up the title bar
    $j("#content *").remove();
    $j("#content").attr("class", "").addClass("mosaic_view");
    $j("h1").addClass("view").html(title).show();
    $j(".button").remove();

    //set up the footer view, and the content area
    $j("#controls #slider").hide();
    $j("#controls").show();
    $j("#content").css({ bottom: "40px", top: "57px" });

    view = mosaicView; //set the current view

    //add the back button
    $j('<div class="button">').html(gallery).click(function() {
        albumView(); //go back to the current view
    }).appendTo("body");

    //add the large view with title
    var detail = $j('<div id="mosaic_detail">').click(function(i) {
        largeView(this, current);
    });
    $j("<img/>").attr("src", data[current].url).appendTo(detail);
    $j("<strong/>").html(data[current].description).appendTo(detail);
    detail.appendTo("#content");

    //add the thubnail grid, with a click handler to animate the image change
    var grid = $j('<div id="mosaic_grid">');
    $j.each(data, function(i) {
        $j('<div class="mosaic_item">')
            .css({
                //backgroundPosition: "0px " + (-160 * i) + "px",
                //backgroundImage: "url(" + sprite + ")"
								background: "url(" + data[i].thumbnail.url + ") no-repeat"
            })
            .data("num", i)
            .click(function() {
                var num = $j(this).data("num");
                current = num;
                $j(".mosaic_item.selected").removeClass("selected");
                $j(this).addClass("selected");

                $j("#mosaic_detail").animate({ opacity: 0 }, "fast", function() {
                    $j("#mosaic_detail img").attr("src", data[num].url);
                    $j("#mosaic_detail strong").html(data[num].description);
                    $j(this).animate({ opacity: 1 }, "fast");
                });
            }).appendTo(grid);
    });

    grid.appendTo("#content");

    //select the current item in the thumbnail grid view
    $j(".mosaic_item:nth-child("+ (current + 1) +")").addClass("selected");
};

function largeView(photo, i) {
    current = i;
    var item = data[i];

    var hovered = false;

    $j("h1").hide();
    $j(".button").remove();
    $j("#controls").hide();
    $j("#content").css({ bottom: "0px", top: "0px" });
    $j("#content").attr("class", "").addClass("large_view");
    $j("#content *").remove();

    $j('<div class="button">Back to Album</div>').click(function() {
        view(); //go back to the current view
    }).appendTo("#content");

    var large = $j('<div id="main">');
    $j("<img/>").attr("src", item.url).appendTo(large);
    $j("<strong/>").html(item.description).appendTo(large);
    large.appendTo("#content");

    var wrapper = $j('<div id="hover_view_wrapper">');
    var hover = $j('<div id="hover_view">').hover(function() {
        hovered = true;
    }, function() {
        hovered = false;
    });

    $j('<div id="previous" title="Previous">').click(function() {
        if(!data[current-1]) return;

        $j(".large_view #hover_view #next").removeClass("disabled");
        if(!data[current-2]) $j(this).addClass("disabled");

        current--;
        $j(".large_view #main").animate({ opacity: 0 }, "fast", function() {
            $j(".large_view img").attr("src", data[current].url);
            $j(".large_view strong").html(data[current].description);
            $j(this).animate({ opacity: 1 }, "fast");
        });
    }).appendTo(hover);

    $j('<div id="next" title="Next">').click(function() {
        if(!data[current+1]) return;

        $j(".large_view #hover_view #previous").removeClass("disabled");
        if(!data[current+2]) $j(this).addClass("disabled");

        current++;
        $j(".large_view #main").animate({ opacity: 0 }, "fast", function() {
            $j(".large_view img").attr("src", data[current].url);
            $j(".large_view strong").html(data[current].description);
            $j(this).animate({ opacity: 1 }, "fast");
        });
    }).appendTo(hover);

    wrapper.append(hover).appendTo("#content");

    if(current == 0) {
        $j(".large_view #hover_view #previous").addClass("disabled");
    }
    else if(current == data.length-1) {
        $j(".large_view #hover_view #next").addClass("disabled");
    }

    var timer;
    var showing = false;

    $j("#content").mousemove(function(event) {
        if(!showing) {
            showing = true;
            $j(".large_view #hover_view").stop().animate({ opacity: 1 });
        }

        clearTimeout(timer);
        timer = setTimeout(function() {
            if(hovered) return;
            showing = false;
            $j(".large_view #hover_view").stop().animate({ opacity: 0 });
        }, 2000);
    });
};

// Example code
var gallery = "Image Gallery";
var albums_orig = [
    {
        title: "Lake Tahoe",
        sprite: "http://gallery.me.com/emily_parker/100579/scrubSprite.jpg?ver=121513594900013",
        photos: [
            {
                title: "On the river",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-201/web.jpg?ver=12151358310001",
                width: 260,
                height: 192
            },
        ]
    }
    //Add more albums here...
];
