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

var isLoggedIn = false;
var topZ = 30;

// globals for swipey code (this is way broke right now)
var startMouseX;
var startTabX;
var isDown = false;

var scrollPosts, scrollReddits;

/**
 * once dom content is loaded enable the iScroll component
 */
function loaded() {
	
	// set iScroll on tabPosts
	scrollPosts = new iScroll('tabPosts', {
		pullToRefresh: 'both',
		pullUpLabel: 'load more posts...',
		onPullDown: function() {
			// clear the current posts list and reload
			$("#posts").html("");
			LoadPosts(loadPosts_Handler, r_subreddit);
		},
		onPullUp: function() {
			// load the next page of results
			console.log('loading more...' + r_before + ":" + r_after);
			LoadPosts(loadPosts_Handler, r_subreddit, null, r_after);
		}
	});
	
	// set iScroll on tabReddits
	scrollReddits = new iScroll('tabReddits');
}

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
document.addEventListener('DOMContentLoaded', loaded, false);


/**
 *	document.ready
 **/
$(document).ready(function(e) {
	
	/**
	 * show the front page by default
	 **/
	showSpinny($("#tabPosts"));
	$("#tabPosts").css("z-index", topZ++).animate({ left: 201 });
	r_subreddit = "";
	LoadPosts(loadPosts_Handler);
	
	/**
	 * when a left menu item is clicked tinker with the styles and show the appropriate tab
	 **/
	$("#tabLeft ul li a").click(function(e) {
		
		e.preventDefault();
		
		// apply the selected class to the menu item
		$(this).parent().parent().find("li").attr("class", "");
		$(this).parent().attr("class","selected");
		
		// hide any other tabs
		var $tab = $("#" + $(this).attr("tab"));
		$(".tab").each(function() {
			if ($tab.attr("id") != $(this).attr("id"))
				$(this).css("left", 201).css("z-index", 0);
		});
		$("#tabPost").animate({ opacity: 0 });
		
		$tabLeft = $("#tabLeft");
		var leftPos = $tabLeft.position().left + $tabLeft.width() + 1;
		showSpinny($tab);
		$tab.css("z-index", topZ++).animate({ left: leftPos });
		
		// custom load code, could be an eval, but evals make me feel dirty.
		switch($(this).attr("tab")) {
			case "tabSearch":
				loadSearchTab();
				break;
			case "tabReddits":
				loadRedditsTab();
				break;
			case "tabWrite":
				loadWriteTab();
				break;
		} // end switch
	});
	
	
	/**
	 *	close the fancybox when a modal close button is clicked
	 **/
	$(".close-button").live('click', function(e) {
		$.fancybox.close();
	});
	
	// if creds were left in the db, try to log in
	attemptPreLogin();
});


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
	
	// switch to the posts tab and refresh the list
	showSpinny($("#tabPosts"));
	$("#tabPosts").css("z-index", topZ++).animate({ left: 201 });
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
	var agoLabel = "";
	if (minutesAgoCreated > 60) {
		agoLabel = Math.round(minutesAgoCreated/60) + " Hours";
	} else {
		agoLabel = Math.round(minutesAgoCreated) + " Minutes";
	} // end else
	
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

