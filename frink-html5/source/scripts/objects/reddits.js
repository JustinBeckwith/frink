
/*--------------------------------------------------------------------------
--
-- LOAD HANDLERS
--
--------------------------------------------------------------------------*/


$(document).ready(function(e) {
	
	/**
	 * show more subreddits if scrolled to the bottom of the subreddit list
	 **/
	$("#tabReddits").scroll(function(e) {
		var $tabReddits = $("#tabReddits");
		if (($tabReddits[0].scrollHeight - $tabReddits.scrollTop()) == $tabReddits.outerHeight()) {
			showSpinny($("#tabReddits"));
			LoadReddits(loadReddits_Handler, null, r_subreddit_after);
		} // end if
	});
	
	/**
	 *	open the listing page when a subreddit list item is clicked on
	 **/
	$('a[href=#listpage]').live('click', function(e) {	
		e.preventDefault();
		showSpinny();
		r_subreddit = $(this).attr("r");
		$("#posts").html("");
		$tabLeft = $("#tabLeft");
		$("#tabPosts").css('z-index', topZ++);
		$("#tabPosts").animate({ left: $tabLeft.position().left + $tabLeft.width() });
		LoadPosts(loadPosts_Handler);
	});
	
	
});


/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/


/**
 *	loadRedditsTab
 **/
function loadRedditsTab() {
	LoadReddits(loadReddits_Handler);
} // end loadREdditsTab method



/**
 * loadReddits_Handler
 **/
function loadReddits_Handler(json) {
	
	// set before/after for scrolling through list
	r_subreddit_after = json.data.after;
	r_subreddit_before = json.data.before;
	
	var reddits = json.data.children;
	var $reddits = $("#reddits");
			
	// render each reddit
	for (var i=0; i<reddits.length; i++) {
		var subreddit = reddits[i].data;
		renderSubreddit(subreddit, $reddits);
	} // end for
	
	r_reddits = reddits;
	scrollReddits.refresh();
	hideSpinny($("#tabReddits"));
	
} // end loadReddits_Handler function


/**
 *	renderSubreddit
 **/
function renderSubreddit(subreddit, $reddits) {
	$reddits.append("<li><a href=\"#listpage\" r=\"" + subreddit.display_name + "\">" + subreddit.display_name + "</a></li>");
} // end renderSubreddit method



