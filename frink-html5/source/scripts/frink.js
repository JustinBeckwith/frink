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
var isPortrait = false;

// globals for swipey code (this is way broke right now)
var startMouseX;
var startTabX;
var isDown = false;
var resizeTimer;
var mailTimer;

// create some global jquery obj references
var $middle;
var $tabPost;
var $spinny;
var $tabPosts;
var $tabReddits;
var $postComments;
var $contentFrame;
var $postContent;
var $postCommentsScroller;

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);


/**
 *	document.ready
 **/
$(document).ready(function(e) {
	
	// set some globals
	$middle = $("#middle");
	$tabPost = $("#tabPost");
	$spinny = $("#spinny");
	$tabPosts = $("#tabPosts");
	$tabReddits = $("#tabReddits");
	$postComments = $("#post-comments");
	$postCommentsScroller = $("#post-comments-scroller");
	$contentFrame = $("#contentFrame");
	$postContent = $("#post-content");
	
	isPortrait = $(window).height() > $(window).width();
	
	onWindowResize();
	
	/**
	 * show the front page by default
	 **/
	if (localStorage.username != null && localStorage.password != null) {
		attemptPreLogin();
	} else {
		loadPostTab();
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
	
	// grab any a-href tags and make them event driven so they work
	$(".link-box ul li").click(function(e) {
		followLink($(this).attr('href'));
	});
	
});



/**
 * manage landscape/portrait transitions
 */
$(window).resize(function() {
    onWindowResize();
});

function onWindowResize() {
        
    // determine if we're in portrait or landscape
    isPortrait = $(window).height() > $(window).width();
    var postVisible = $tabPost.is(":visible");
    
    // resize the post view if selected
    if (postVisible) {
    	// move the tabPost over to the far left side hiding text for portrait mode
    	var left = isPortrait ? 51 : 201;
    	$tabPost.css('left', left)
    		.css('width', $(window).width() - left - 10)
    		.css('height', $(window).height() - 6);
    		
    	$contentFrame.css('height', $(window).height() - $("#post-header").height() - 4);
    	$postCommentsScroller.css('height', $(window).height() - $("#post-header").height() - 4);
    	
    } // end if
    
    // size and position the middle panel
    var left = (isPortrait || postVisible) ? 51 : 201;
	var width = $(window).width() - left - 10;
	if (width > 550) width = 550;  
    $middle.css('left', left)
    	.css('width', width);
  	  
};




/**
 * hide all the tabs and show the appropriate one
 */
function showTab($link) {
	// apply the selected class to the menu item
	$link.parent().parent().children("li").each(function() {
		$(this).attr("class", "");
	});
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
	$tabPost.css('display','none');
	
	// reposition and size middle panel
	$tab.css('display', '');
	onWindowResize();
		
	// custom load code, could be an eval, but evals make me feel dirty.
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
	$("#liMail").css('display',isLoggedIn ? '' : 'none');
	
	// start/stop the mail timer to check for new mail
	if (isLoggedIn) {
		checkMail();
		mailTimer = setInterval(checkMail, 15000);
	} // end if
	else {
		clearInterval(mailTimer);
	} // end else
		
	// switch to the posts tab $parentresh the list
	r_subreddit = "";
	showTab($("#linkPosts"));
	
} // end authChange method

/**
 * checkMail - hit the server and look for new mail messages
 */
function checkMail() {
	getUnreadMessageCount(checkMail_handler);
}

/**
 * update the icon to regular/orange if there are new messages
 */
function checkMail_handler(json) {
	if (json.data.children.length == 0) {
		$("#linkMail img").attr('src', 'images/icons/mail-emboss.png')
	} // end if
	else {
		$("#linkMail img").attr('src', 'images/icons/mail-emboss-orange.png')
	} // end else
} // end checkMail_handler


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
 *	showSpinny
 **/
function showSpinny($container) {

	$container.attr('display', 'none');
	
	var left = $container.offset().left;
	var width = $container.width();
	
	$spinny.css('left', $container.offset().left + ($container.width()/2) - 50)
			.css('top', $container.offset().top + 20)
			.css('display', 'inline');
}

/**
 *	hideSpinny
 **/
function hideSpinny($container) {
	$spinny.css('display', 'none');
	$container.attr('display', 'block');
}

/**
 * followLink - method to follow links in BlackBerry Browser
 **/	
function followLink(address) {
	var encodedAddress = "";
	
	// URL Encode all instances of ':' in the address
	encodedAddress = address.replace(/:/g, "%3A");
	
	// Leave the first instance of ':' in its normal form
	encodedAddress = encodedAddress.replace(/%3A/, ":");
	
	// Escape all instances of '&' in the address
	encodedAddress = encodedAddress.replace(/&/g, "\&");
	
	if (typeof blackberry !== 'undefined') {
		try{
			// If I am a BlackBerry device, invoke native browser
			var args = new blackberry.invoke.BrowserArguments(encodedAddress);
			blackberry.invoke.invoke(blackberry.invoke.APP_BROWSER, args);
		} catch(e) {
 			alert("Sorry, there was a problem invoking the browser");
 		}
	} else {
		// If I am not a BlackBerry device, open link in current browser
		window.open(encodedAddress); 
	} // end else
} // end followLink function


