
/*--------------------------------------------------------------------------
--
-- LOAD HANDLERS
--
--------------------------------------------------------------------------*/

var bindingReddits = false;
var scrollReddits;

$(document).ready(function(e) {
	
	/**
	 * show more subreddits if scrolled to the bottom of the subreddit list
	 **/
	scrollReddits = new iScroll('tabReddits', {
		onScrollBottom: function() {
			if (!bindingReddits && r_subreddit_after != null) {
				bindingReddits = true;
				addLoading($("#reddits"), scrollReddits);
				LoadReddits(loadReddits_Handler, null, r_subreddit_after);
			} // end if
		}
	});
	
	/**
	 *	open the listing page when a subreddit list item is clicked on
	 **/
	$('#reddits a[href=#listpage]').live('click', function(e) {	
		e.preventDefault();
		r_subreddit = $(this).attr("r");
		$("#posts").html("");
		scrollPosts.refresh();
		$tabPosts = $("#tabPosts");
		$("#tabReddits").css('display','none');
		$tabPosts.css('display','');
		showSpinny($tabPosts);
		LoadPosts(loadPosts_Handler, r_subreddit);
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
	showSpinny($tabReddits);
	$("#reddits").html("");
	scrollReddits.scrollTo(0,0);
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
	removeLoading(scrollReddits);
	bindingReddits = false;
	
} // end loadReddits_Handler function


/**
 *	renderSubreddit
 **/
function renderSubreddit(subreddit, $reddits) {
	$reddits.append("<li><a href=\"#listpage\" r=\"" + subreddit.display_name + "\"><div>" + subreddit.display_name + "</div></a></li>");
} // end renderSubreddit method



