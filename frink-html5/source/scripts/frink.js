/**
 *	frink.js
 *	
 *	@desc	core javascript file for the frink project
 *	@author	Justin Beckwith
 **/

// initialize globals
var r_before = null;
var r_after = null;
var r_post_url  = null;
var r_post = null;
var r_posts = [];
var r_subreddit = null;
var r_subreddit_after = null;
var r_subreddit_before = null;
var r_messages = null;

var isLoggedIn = false;
var topZ = 30;

// globals for swipey code (this is way broke right now)
var startMouseX;
var startTabX;
var isDown = false;

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);


/**
 *	document.ready
 **/
$(document).ready(function(e) {
	
	/**
	 * show the front page by default
	 **/
	showSpinny($("#tabPosts"));
	if (localStorage.username != null && localStorage.password != null) {
		attemptPreLogin();
	} else {
		LoadPosts(loadPosts_Handler);
	} // end else
	
	/**
	 * when a left menu item is clicked tinker with the styles and show the appropriate tab
	 **/
	$("#tabLeft ul li a").click(function(e) {
		e.preventDefault();
		showTab($(this));
	});
	
	/**
	 *	close the fancybox when a modal close button is clicked
	 **/
	$(".close-button").live('click', function(e) {
		$.fancybox.close();
	});
});


/**
 * hide all the tabs and show the appropriate one
 */
function showTab($link) {
	// apply the selected class to the menu item
	$link.parent().parent().find("li").attr("class", "");
	$link.parent().attr("class","selected");
		
	// set all images back to emboss, not selected
	$link.parent().parent().find("li img").each(function(index) {
		$(this).attr('src', $(this).attr('src').replace('-selected', '-emboss'));
	});
	
	// set the image for the selected menu item to selected
	$link.find('img').attr('src', $link.find('img').attr('src').replace('-emboss', '-selected'));
	
	// hide any other tabs
	var $tab = $("#" + $link.attr("tab"));
	$(".tab").each(function() {
		if ($tab.attr("id") != $link.attr("id"))
			$(this).css("display", "none");
	});
	$("#tabPost").animate({ opacity: 0 });
	
	$tabLeft = $("#tabLeft");
	var leftPos = $tabLeft.position().left + $tabLeft.width() + 1;
	showSpinny($tab);
	$("#middle").css('left', 201);
	$tab.css('display', '');
	
	// custom load code, could be an eval, but evals make me feel dirty.
	console.log($link.attr("id"));
	switch($link.attr("id")) {
		case "linkSearch":
			loadSearchTab();
			break;
		case "linkReddits":
			loadRedditsTab();
			break;
		case "linkMail":
			loadMailTab();
			break;
		case "linkPosts":
			loadPostTab();
			break;
		case "linkAll":
			loadAllTab();
			break;
	} // end switch
} // end showTab function

/**
 * any time an authentication event occurs update the UI
 */
function authChange() {
	
	// show / hide the mail link
	if (isLoggedIn) {
		$("#liMail").css('display','');
	} else {
		$("#liMail").css('display','none');
	} // end else
	
	// switch to the posts tab $parentresh the list
	showSpinny($("#tabPosts"));
	showTab($("#linkPosts"));
	r_subreddit = "";
	LoadPosts(loadPosts_Handler);
	
} // end authChange method

/*--------------------------------------------------------------------------
--
-- UTILITY FUNCTIONS
--
--------------------------------------------------------------------------*/
//
// getAgoLabel
//
function getAgoLabel(created_utc) {

	var currentTimeTicks = (new Date()).getTime();
	var minutesAgoCreated = (currentTimeTicks - (created_utc*1000))/1000/60;
	var unitsAgo;
	var unitLabel;
	
	if (minutesAgoCreated > 60*24*365) {
		unitsAgo = Math.round(minutesAgoCreated/60/24/30);
		unitLabel = "year"
	} else if (minutesAgoCreated > 60*24*30) {
		unitsAgo = Math.round(minutesAgoCreated/60/24/30);
		unitLabel = "month";
	} else if (minutesAgoCreated > 60*24) {
		unitsAgo = Math.round(minutesAgoCreated/60/24);
		unitLabel = "day";	
	} else if (minutesAgoCreated > 60) {
		unitsAgo = Math.round(minutesAgoCreated/60);
		unitLabel = "hour";
	} else {
		unitsAgo = Math.round(minutesAgoCreated);
		unitLabel = "minute";
	} // end else
	
	var agoLabel = unitsAgo + " " + unitLabel + (unitsAgo > 1 ? "s" : "");
	return agoLabel;
	
} // end getAgoLabel

//
// htmlDecode
//
function htmlDecode(input){
	var e = document.createElement('div');
	e.innerHTML = input;
	return e.childNodes[0].nodeValue;
} // end htmlDecode function



/**
 *	showContentTab
 **/
function showContentTab($tab) {	

	// pre-show the spinny
	showSpinny($tab);
		
	// move the posts tab over to the left
	$("#tabPosts").animate({ left: 50 });
	
	// move the content pane to the left, and set to use remaining width
	$tab.css('z-index', topZ++)
		.css('opacity', 1)
		.css('left', $("body").width())
		.css('width', $("body").width() - 230)
		.animate({ left: 201 });
	
} // end showContentTab method

/**
 *	showSpinny
 **/
function showSpinny($container) {
	
}

/**
 *	hideSpinny
 **/
function hideSpinny($container) {
	
}

