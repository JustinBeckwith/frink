

/*--------------------------------------------------------------------------
--
-- LOAD EVENTS
--
--------------------------------------------------------------------------*/


var scrollPosts;
var bindingPosts = false;

$(document).ready(function(e) {
	
	// set iScroll on tabPosts
	scrollPosts = new iScroll('tabPosts', {
		pullToRefresh: 'down',   
		onPullDown: function() {
			// clear the current posts list and reload
			//bindingPosts = true;
			//showSpinny($tabPosts);
			//$("#posts").html("");
			//LoadPosts(loadPosts_Handler, r_subreddit);
		},
		onScrollBottom: function() {
			if (!bindingPosts && r_after != null) {
				bindingPosts = true;
				//showSpinny($("#listpage"));
				showSpinny($("#tabPosts"));				
				LoadPosts(loadPosts_Handler, r_subreddit, null, r_after);
			} // end if
		}
	});
	
	/**
	 *	open the post tab when a post is clicked
	 **/
	$("#posts li a").live('click', function(e) {
		e.preventDefault();
		
		// grab the post data from the pre-loaded data
		r_post_url = $(this).attr('url');
		r_post = r_posts[$(this).attr('idx')].data;
		
		$postHeader = $("#post-header");
				
		// hide the previous content of the iframe before loading
		$contentFrame.attr('src', 'about:blank');
		$postHeader.html("");
		$postComments.html("");
		
		// show the tab
		showContentTab($tabPost);
		renderPostHeader(r_post, 0, $postHeader, false, true);
		renderPostBody(r_post, false);
	});
		
	
});


/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/


/**
 *	showContentTab
 **/
function showContentTab($tab) {	
	
	// move the middle tab to the left 
	$middle.css('left', 50);
	
	// move the content pane to the left, and set to use remaining width
	var left = isPortrait ? 51 : 201;
	$tab.css('left', left)
		.css('display', 'inline')
		.css('width', $(window).width() - left - 10);
	
} // end showContentTab method


/**
 *	loadPostsTab
 **/
function loadPostTab() {
	bindingPosts = true;
	showSpinny($tabPosts);
	$("#posts").html("");
	scrollPosts.scrollTo(0,0);
	LoadPosts(loadPosts_Handler, "");
} // end loadPostsTab method

/**
 *	loadAllTab
 **/
function loadAllTab() {
	showSpinny($tabPosts);
	$("#posts").html("");
	LoadPosts(loadPosts_Handler, "all");
} // end loadPostsTab method




/**
 *	loadPosts_Handler
 **/
function loadPosts_Handler(json) {
	
	// grab the modHash for voting
	userHash = json.data.modhash;
			
	// set the before/after			
	r_after = json.data.after;
	r_before = json.data.before;			
			
	var posts = json.data.children;
	var $posts = $("#posts");
			
	// render each post
	for (var i=0; i<posts.length; i++) {
		var post = posts[i].data;
		renderPostHeader(post, i+r_posts.length, $posts, true);
	}; // end for
			
	// store the posts globally
	r_posts = r_posts.concat(posts);
	scrollPosts.refresh();
	hideSpinny($tabPosts);
	bindingPosts = false;
	
} // end loadPosts_Handler function


//
// renderPostHeader
//
function renderPostHeader(post, idx, parent, useLI, renderControls) {	
	
	// create the post div
	var $postElement = $("<div class=\"post\"></div>");
	var $postLeft = $("<div class=\"post-left\"></div>");
	
	// add the thumbnail if needed
	if (post.thumbnail != '') {
		if (post.thumbnail.indexOf("/static/") == 0)
			post.thumbnail = "http://www.reddit.com" + post.thumbnail;
		var $thumb = $("<img src=\"" + post.thumbnail + "\" alt=\"[img]\" />");
		$postElement.append($thumb);
	} // end if
			
	// add the title
	var $title = $("<div class=\"title\">" + post.title + "</div>");
	//$postLeft.append($title);
	$postElement.append($title);
	
	// add the domain
	var $domain = $("<div class=\"domain\">" + post.domain + "</div>");
	$postLeft.append($domain);
	
	// add the score, subreddit, and user
	var $bottombar = $("<div class=\"bottombar\"><span class=\"score\">" + post.score + "</span>&nbsp;&nbsp;&nbsp;" + post.subreddit + "&nbsp;by&nbsp;" + post.author + "</div>");
	$postLeft.append($bottombar);
	
	// I want this to be right justified, but I ran out of time and CSS was being irritating
	var $hours = $("<div class=\"hours\">" + getAgoLabel(post.created_utc) + "</div>");
	var $num_comments = $("<span class=\"num_comments\">" + post.num_comments + "</span>");
	$postLeft.append($hours);
	
	// add the left part to the element
	$postElement.append($postLeft);	
		
	// add controls if neccesary
	if (renderControls) {
		var $controlBar = $("<ul id=\"controlBar\"></ul>");
		$controlBar.append("<li><img src=\"images/icons/arrow-left.png\" id=\"btnBack\" title=\"Go back to the post listing\" /></li>");
		$controlBar.append("<li><img src=\"images/icons/arrow-up" + ((r_post.likes==true) ? "-selected" : "") + ".png\" id=\"btnUpBoat\" title=\"Up Boat!\" /></li>");
		$controlBar.append("<li><img src=\"images/icons/arrow-down" + ((r_post.likes==false) ? "-selected" : "") + ".png\" id=\"btnDownBoat\" title=\"Down Boat!\" /></li>");
		if (!r_post.is_self) {
			$controlBar.append("<li><img src=\"images/icons/comments.png\" id=\"btnComments\" title=\"View the comments\" /></li>");
		} // end if
		$controlBar.append("<li><img src=\"images/icons/action.png\" id=\"btnOpenLink\" title=\"Open the link in a new window\" /></li>");
		$postElement.append($controlBar);
	} // end if
	
	//useLI is used for list mode, otherwise just append it to a header
	if (useLI) {
	
		// generate the wrapping a href tag
		var href = post.is_self ? "#comments" : "#post";
		var $athumb = $("<a href=\"" + href + "\" url=\"" + post.url + "\" idx=\"" + idx + "\"></a>");
		
		$athumb.append($postElement);
		
		// generate the li 
		var $li = $("<li></li>");
		$li.append($athumb);

		// add the post to the UI
		parent.append($li);
		
	} //end if
	else {
		parent.append($postElement);
	} // end else
	
} // end renderPostHeader function






