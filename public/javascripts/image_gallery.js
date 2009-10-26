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

$(document).ready(function() {
    view = gridView; //this referrs to a function that we havn't created yet
    albumView(); //render the album view

    //set up the jQuery UI slider for later use by the grid view
    $("#slider").slider({
    	value: 75,
    	max: 150,
    	min: 50,
    	slide: function(event, ui) {
    	    $('#content').css('font-size',ui.value+"px");
    	}
    });

    //setup the buttons for switching views
    $("#grid").click(function() {
        $("#views a.selected").removeClass("selected");
        $(this).addClass("selected");
        gridView();
    });

    $("#mosaic").click(function() {
        $("#views a.selected").removeClass("selected");
        $(this).addClass("selected");
        mosaicView();
    });

});

function albumView() {
    //remove everything from the content area that might have been there from other views,
    //as well as the back button (used later)
    $("#content *").remove();
    $(".button").remove();

    //add the album_view class to the content view, and extent it to the bottom of the window
    //also, hide the footer, and set the title of the gallery (in the data file)
    $("#content").attr("class", "").addClass("album_view");
    $("#controls").hide();
    $("#content").css({ bottom: "0px", top: "57px" });
    $("h1").removeClass("view").html(gallery);
    current = 0; 

    $("<h2>Albums</h2>").appendTo("#content"); //add the title of the view
    $.each(albums, function(i) {
    	//create the album, and register the click handler
        var item = $('<div class="item">').click(function() {
            data = albums[i].photos;
            title = albums[i].name;
            sprite = albums[i].cover_photo_url;
            view(); //go to current view
        });

        //create the skimmer, and set the background image to the sprite for the album (in the data file)
        //then register the mousemove event
        $('<div class="skimmer">').css("background", "url("+this.cover_photo_url+")").mousemove(function(e) {
            var x = e.pageX;
            var offset = $(this).offset().left;
            var w = 160 / albums[i].photos.length;
            var image = Math.floor((x - offset) / w);
            $(this).css("background-position", "0px " + (-160 * image) + "px");
        }).mouseout(function() {
        	//when we mouseout, set the background position back to 0
            $(this).css("background-position", "0px 0px");
        }).appendTo(item);

        //create the album title and the number of photos label
        $('<strong/>').html(this.name).appendTo(item);
        $('<span/>').html(this.photos.length + (this.photos.length > 1 ? " Photos" : " Photo")).appendTo(item);

        item.appendTo("#content"); //add the item to the content area
    });
};

function gridView() {
    //remove everything from the content area that might have been there from other views,
    //add the grid_view class to the content view, and set up the title bar
    $("#content *").remove();
    $("#content").attr("class", "").addClass("grid_view");
    $("h1").addClass("view").html(title).show();
    $(".button").remove();  

    //set up the footer view, and the content area
    $("#controls").show();
    $("#controls #slider").show();
    $("#content").css({ bottom: "40px", top: "57px" });

    view = gridView; //set the current view

    //add the back button
    $('<div class="button">').html(gallery).click(function() {
        albumView(); //go back to the current view
    }).appendTo("body");

    //add the items in the album to the grid, and set the size of the image in ems.
    $.each(data, function(i) {
        var item = $('<div class="grid_item">').click(function() {
            largeView(this, i);
        });
        $('<img/>').attr("src", this.photo.url)
                   //.css("width", this.photo.width / 100 + "em")
                   //.css("height", this.photo.height / 100 + "em")
									 .css("width", 260 / 100 + "em")
                   .css("height", 192 / 100 + "em")
                   .appendTo(item);
        $("<strong/>").html(this.photo.description).appendTo(item);
        item.appendTo("#content");
    });
};

function mosaicView() {
    //remove everything from the content area that might have been there from other views,
    //add the grid_view class to the content view, and set up the title bar
    $("#content *").remove();
    $("#content").attr("class", "").addClass("mosaic_view");
    $("h1").addClass("view").html(title).show();
    $(".button").remove();

    //set up the footer view, and the content area
    $("#controls #slider").hide();
    $("#controls").show();
    $("#content").css({ bottom: "40px", top: "57px" });

    view = mosaicView; //set the current view

    //add the back button
    $('<div class="button">').html(gallery).click(function() {
        albumView(); //go back to the current view
    }).appendTo("body");

    //add the large view with title
    var detail = $('<div id="mosaic_detail">').click(function(i) {
        largeView(this, current);
    });
    $("<img/>").attr("src", data[current].photo.url).appendTo(detail);
    $("<strong/>").html(data[current].photo.description).appendTo(detail);
    detail.appendTo("#content");

    //add the thubnail grid, with a click handler to animate the image change
    var grid = $('<div id="mosaic_grid">');
    $.each(data, function(i) {
        $('<div class="mosaic_item">')
            .css({
                backgroundPosition: "0px " + (-160 * i) + "px",
                //backgroundImage: "url(" + sprite + ")"
								backgroundImage: "url(" + data[i].photo.thumbnail.url + ")"
            })
            .data("num", i)
            .click(function() {
                var num = $(this).data("num");
                current = num;
                $(".mosaic_item.selected").removeClass("selected");
                $(this).addClass("selected");

                $("#mosaic_detail").animate({ opacity: 0 }, "fast", function() {
                    $("#mosaic_detail img").attr("src", data[num].photo.url);
                    $("#mosaic_detail strong").html(data[num].photo.description);
                    $(this).animate({ opacity: 1 }, "fast");
                });
            }).appendTo(grid);
    });

    grid.appendTo("#content");

    //select the current item in the thumbnail grid view
    $(".mosaic_item:nth-child("+ (current + 1) +")").addClass("selected");
};

function largeView(photo, i) {
    current = i;
    var item = data[i];

    var hovered = false;

    $("h1").hide();
    $(".button").remove();
    $("#controls").hide();
    $("#content").css({ bottom: "0px", top: "0px" });
    $("#content").attr("class", "").addClass("large_view");
    $("#content *").remove();

    $('<div class="button">Back to Album</div>').click(function() {
        view(); //go back to the current view
    }).appendTo("#content");

    var large = $('<div id="main">');
    $("<img/>").attr("src", item.photo.url).appendTo(large);
    $("<strong/>").html(item.caption).appendTo(large);
    large.appendTo("#content");

    var wrapper = $('<div id="hover_view_wrapper">');
    var hover = $('<div id="hover_view">').hover(function() {
        hovered = true;
    }, function() {
        hovered = false;
    });

    $('<div id="previous" title="Previous">').click(function() {
        if(!data[current-1]) return;

        $(".large_view #hover_view #next").removeClass("disabled");
        if(!data[current-2]) $(this).addClass("disabled");

        current--;
        $(".large_view #main").animate({ opacity: 0 }, "fast", function() {
            $(".large_view img").attr("src", data[current].photo.url);
            $(".large_view strong").html(data[current].caption);
            $(this).animate({ opacity: 1 }, "fast");
        });
    }).appendTo(hover);

    $('<div id="next" title="Next">').click(function() {
        if(!data[current+1]) return;

        $(".large_view #hover_view #previous").removeClass("disabled");
        if(!data[current+2]) $(this).addClass("disabled");

        current++;
        $(".large_view #main").animate({ opacity: 0 }, "fast", function() {
            $(".large_view img").attr("src", data[current].photo.url);
            $(".large_view strong").html(data[current].caption);
            $(this).animate({ opacity: 1 }, "fast");
        });
    }).appendTo(hover);

    wrapper.append(hover).appendTo("#content");

    if(current == 0) {
        $(".large_view #hover_view #previous").addClass("disabled");
    }
    else if(current == data.length-1) {
        $(".large_view #hover_view #next").addClass("disabled");
    }

    var timer;
    var showing = false;

    $("#content").mousemove(function(event) {
        if(!showing) {
            showing = true;
            $(".large_view #hover_view").stop().animate({ opacity: 1 });
        }

        clearTimeout(timer);
        timer = setTimeout(function() {
            if(hovered) return;
            showing = false;
            $(".large_view #hover_view").stop().animate({ opacity: 0 });
        }, 2000);
    });
};

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
            {
                title: "Mike and Nancy",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-202/web.jpg?ver=12151358290001",
                width: 260,
                height: 192
            },
            {
                title: "Carrying the canoe",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-203/web.jpg?ver=12151358330001",
                width: 260,
                height: 192
            },
            {
                title: "In the tent",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-204/web.jpg?ver=12151358290001",
                width: 260,
                height: 192
            },
            {
                title: "Starting a laugh",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-205/web.jpg?ver=12151358330001",
                width: 260,
                height: 192
            },
            {
                title: "The whole gang",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-206/web.jpg?ver=12151358300001",
                width: 260,
                height: 192
            },
            {
                title: "Paddling downstream",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-207/web.jpg?ver=12151358280001",
                width: 260,
                height: 192
            },
            {
                title: "Carla and Sarah",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-208/web.jpg?ver=12151358320001",
                width: 260,
                height: 192
            },
            {
                title: "No shoes required",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-209/web.jpg?ver=12151358310001",
                width: 260,
                height: 192
            },
            {
                title: "Nancy",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-2010/web.jpg?ver=12151358280001",
                width: 260,
                height: 192
            },
            {
                title: "Getting ready to float",
                src: "http://gallery.me.com/emily_parker/100579/Lake-20Tahoe-2011/web.jpg?ver=12151358320001",
                width: 260,
                height: 192
            }
        ]
    }
    //Add more albums here...
];
