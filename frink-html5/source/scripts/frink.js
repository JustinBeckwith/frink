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
	
	// generate templates for data binding in the render methods
	registerTemplates();

	/**
	 * show the front page by default
	 **/
	showSpinny($("#tabPosts"));
	$("#tabPosts").css("z-index", topZ++).animate({ left: 201 });
	r_subreddit = "";
	LoadPosts(loadPosts_Handler);
	
	/**
	 * show more posts if scrolled to the bottom
	 **/
	$("#tabPosts").scroll(function(e) {
		var $posts = $("#tabPosts");
		if (($posts[0].scrollHeight - $posts.scrollTop()) == $posts.outerHeight()) {
			showSpinny($("#listpage"));
			LoadPosts(loadPosts_Handler, null, r_after);
		} // end if
	});
	
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
	 *	show the new post window
	 **/
	$("#btnWritePost").fancybox({
		showCloseButton: false,
	});
	
	/**
	 *	show the settings window
	 **/
	$("#btnSettings").fancybox({
		showCloseButton: false,
		onComplete: function(e) {
			$("#username").val(localStorage.username).focus();
			$("#password").val(localStorage.password);
			$("#iXss").attr("src","forms/xss-form.html");
		}
	});
	
	$("#iXss").load(function(e) {
		console.log('loaded!');
		console.log($("#iXss").contents());
	});
	
	/**
	 *	show the about window
	 **/
	$("#btnAbout").fancybox({
		showCloseButton: false,
	});
	
	/**
	 *	close the fancybox when a modal close button is clicked
	 **/
	$(".close-button").live('click', function(e) {
		$.fancybox.close();
	});
	
	/**
	 *	open the post tab when a post is clicked
	 **/
	$("#posts li a").live('click', function(e) {
		e.preventDefault();
		
		// grab the post data from the pre-loaded data
		r_post_url = $(this).attr('url');
		r_post = r_posts[$(this).attr('idx')].data;
		
		$tabPost = $("#tabPost");
		$tabPosts = $("#tabPosts");
		$contentFrame = $("#contentFrame");
		$postComments = $("#post-comments");
		$postHeader = $("#post-header");
				
		// hide the previous content of the iframe before loading
		$contentFrame.attr('src', 'about:blank');
		$postHeader.html("");
		$postComments.html("");
		
		// show the tab
		showContentTab($tabPost);
		renderPostHeader(r_post, 0, $postHeader, false, true);
		renderPostBody(r_post, false);
		hideSpinny($tabPost);
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
	
	/**
	 *	save user settings to the web database from the settings screen
	 **/
	$("#btnSaveSettings").live('click', function(e) {
		localStorage.username = $("#username").val();
		localStorage.password = $("#password").val();
		
		//attemptLogin(attemptLogin_Handler, localStorage.username, localStorage.password);
		invokeLoginForm(localStorage.username, localStorage.password);
		
		$.fancybox.close();
	});
	
	/**
	 *	write a new post
	 **/
	$("#btnWrite").live('click', function(e) {
		alert('write new post');
	});
	
	// btnBack_click
	$("#btnBack").live('click', function(e) {
		$("#tabPosts").animate({left: 201});
		$("#tabPost").animate({opacity: 0});
		$("#tabPost").css("left", -10000);
	});
	
	// btnUpBoat_click
	$("#btnUpBoat").live('click', function(e) {
		alert('up boat!');
	});
	
	// btnDownBoat_click
	$("#btnDownBoat").live('click', function(e) {
		alert('down boat!');
	});
	
	// btnComments_click
	$("#btnComments").live('click', function(e) {
		if ($("#post-comments").css('display') == 'none') {
			renderPostBody(r_post, true, true);
		} // end if
		else {
			if (!r_post.is_self) {
				renderPostBody(r_post, false, true)
			} // end if
		} // end else
	});
	
	// btnNewWindow_click
	$("#btnNewWindow").live('click', function(e) {
		alert('new window');
	});
	
	// btnSearch_click
	$("#btnSearch").click(function(e) {
		e.preventDefault();
		alert('search did not make it in here yet');
	});
	
	// track drag movements on posting tab
	$("#tabPost").mousedown(function(e){
		startMouseX = e.clientX;
		startTabX = $("#tabPost").position().left;
		isDown = true;
	});
	
	/**
	 *	when the user swipes backwards on a tablet handle the movement of abs pos divs
	 *	TODO: js physics engine probably makes this a lot easier
	 */
	$("#tabPost").mousemove(function(e){
		if (isDown) {
			var shift = startTabX - (startMouseX - e.clientX);
			if (shift < ($("body").width() - 100) && shift > 201) {
				$("#tabPost").css("left", shift);
				
				// check if we've gone too far to the right
				if ($("#tabPost").position().left > ($("#tabPosts").position().left + $("#tabPosts").width())) {
					// the post panel has been extended beyond the bounds of the listing page
					var pos = $("#tabPost").position().left - $("#tabPosts").width();
					if (pos < $("#tabLeft").width()) {
						$("#tabPosts").css("left", pos);
					} // end if
				} // end if
				
				// check if we've gone too far to the left
				if (($("#tabPost").position().left - $("#tabPosts").position().left) <= 150) {
					$("#tabPosts").animate({ left: 50 });
				} // end if
				
			} // end if
		} // end if
	});
	
	/**
	 *	functions to handle mouse leave/out/up/over for draggable panels
	 **/
	$("#tabPost").mouseup(function(e){
		handleRelease(e);
	}).mouseleave(function(e){
		//handleRelease(e);
	}).mouseout(function(e){
		//handleRelease(e);
	});
	
	/**
	 * update the label and display settings when an expand/collapse is clicked
	 */
	$('.expand').live('click', function(e) {
		if ($(this).html() == '[-]') {
			$(this).html('[+]');
			$(this).parent().siblings(".comment-body").css('display', 'none');
			$(this).parent().siblings(".replies").css('display', 'none');
		} else {
			$(this).html('[-]');
			$(this).parent().siblings(".comment-body").css('display', '');
			$(this).parent().siblings(".replies").css('display', '');
		}
	});
	
});


/*--------------------------------------------------------------------------
--
-- TAB HANDLERS
--
--------------------------------------------------------------------------*/

/**
 * loadSearchTab
 **/
function loadSearchTab() { 
	$("#txtSearch").focus();
} // end loadSearchTab function

/**
 *	loadWriteTab
 **/
function loadWriteTab() {
	$("#txtWrite").focus();
}

/**
 *	loadRedditsTab
 **/
function loadRedditsTab() {
	LoadReddits(loadReddits_Handler);
} // end loadREdditsTab method

/*--------------------------------------------------------------------------
--
-- EVENT HANDLERS
--
--------------------------------------------------------------------------*/


/**
 * when the mouse button goes up, clean up any draggable events that were executing
 **/
function handleRelease(e) {
	if (isDown) {
		isDown = false;
		// if we allowed the panel to extend farther than it should, bounce it back
		var rightPos = $("#tabPosts").position().left + $("#tabPosts").width();
		if ($("#tabPost").position().left > rightPos) {
			$("#tabPost").animate({ left: rightPos + 1 })
		} // end if
	} // end if
} // end handleRelease method

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
 *	loadPosts_Handler
 **/
function loadPosts_Handler(json) {
			
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
	hideSpinny($("#tabPosts"));
	
} // end loadPosts_Handler function

/**
 *	loadComments_Handler
 **/
function loadComments_Handler(json) {
	
	var $postComments = $("#post-comments");	
			
	// for self posts show the body in the comments page
	if (r_post.selftext_html != null) {
		$postComments.append("<br />" + htmlDecode(r_post.selftext_html) + "<br /><hr /><br />");
	} // end if
			
	// render the recursive comment list
	var comments = json[1].data.children;
	for (var i=0; i<comments.length; i++) {
		renderComment(comments[i].data, $postComments);
	} // end for
	
	hideSpinny($("#tabPosts"));
			
} // end loadComments_Handler function

/**
 *	attemptLogin_Handler
 **/
function attemptLogin_Handler(json) {
	alert('yeeeeeahhhh!!!');
} // end attemptLogin_Handler method

/*--------------------------------------------------------------------------
--
-- DATA RENDER FUNCTIONS
--
--------------------------------------------------------------------------*/

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
	$postLeft.append($title);
	
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
		$controlBar.append("<li><a href=\"#\" id=\"btnBack\" title=\"Go back to the post listing\"><img src=\"images/NIXUS/32x32/Back.png\" /></a></li>");
		$controlBar.append("<li><a href=\"#\" id=\"btnUpBoat\" title=\"Up Boat!\"><img src=\"images/NIXUS/32x32/Up.png\" /></a></li>");
		$controlBar.append("<li><a href=\"#\" id=\"btnDownBoat\" title=\"Down Boat!\"><img src=\"images/NIXUS/32x32/Down.png\" /></a></li>");
		$controlBar.append("<li><a href=\"#\" id=\"btnComments\" title=\"View the comments\"><img src=\"images/NIXUS/32x32/Chat.png\" /></a></li>");
		$controlBar.append("<li><a href=\"" + post.url + "\" target=\"blank\" title=\"Open the link in a new window\"><img src=\"images/NIXUS/32x32/Window.png\" /></a></li>");
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


/**
 *	renderPostBody
 **/
function renderPostBody(r_post, showComments, animateSwitch) {

	var	$contentFrame = $("#contentFrame");
	var	$postComments = $("#post-comments");
	var	$postHeader = $("#post-header");
	
	// if there are only comments, no need to deal with the iframe
	if (r_post.is_self || showComments) {
		if (animateSwitch) {
			$contentFrame.css('display', 'none');
			$postComments.css('display', '');
		} else {
			$contentFrame.css('display', 'none');
			$postComments.css('display', '');
		} // end else
		
		LoadComments(loadComments_Handler, r_post);
		$postComments.css('width', $(window).width() - 250);
		$postComments.css('height', $(window).height() - $postHeader.height());
	} else {
		if (animateSwitch) {
			$("#post-comments").css('display', 'none');
			$contentFrame.css('display', '');
		} else {
			$("#post-comments").css('display', 'none');
			$contentFrame.css('display', '');
		}
		$contentFrame.attr('src', r_post_url);
		$contentFrame.css('width', $(window).width() - 230);
		$contentFrame.css('height', $(window).height() - $postHeader.height());
	} // end else
} // end renderPostBody method

/**
 *	renderSubreddit
 **/
function renderSubreddit(subreddit, $reddits) {
	$reddits.append("<li><a href=\"#listpage\" r=\"" + subreddit.display_name + "\">" + subreddit.display_name + "</a></li>");
} // end renderSubreddit method


/**
 *	renderComment
 **/
function renderComment(comment, $container) {
	
	var $reply = $("<div class=\"reply\"></div>");
	var $header = $("<div class=\"reply-header\"><span class=\"expand\">[-]</span><span class=\"username\"><a href=\"#\">" + comment.author + "</a></span><span>" + (comment.ups - comment.downs) + "&nbsp;points</span><span>" + getAgoLabel(comment.created_utc) + "<span></div>");
	var $comment = $("<div class=\"comment-body\">" + comment.body + "</div>");
	$reply.append($header);
	$reply.append($comment);
		
	if (comment.replies != undefined && comment.replies.data != undefined) {
		var $replies = $("<div class=\"replies\"></div>");
		for (var i=0; i<comment.replies.data.children.length; i++) {
			var c = comment.replies.data.children[i].data;
			if (c != undefined && comment.replies.data.children[i].kind == "t1")
				renderComment(c, $replies);
		} // end for
		$reply.append($replies);
	} // end if
	
	$container.append($reply);

} // end renderComment function


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
 *	invokeLoginForm
 **/
function invokeLoginForm(username, password) {
	var $frameContents = $("#iXss").contents();
	$frameContents.find("#user").val(username);
	$frameContents.find("#passwd").val(password);
	$frameContents.find("#frmLogin").attr("action", "http://www.reddit.com/api/login/" + username);
	$frameContents.find("#frmLogin").submit();
} // end invokeLoginForm function

/**
 *	register templates - eventually switch to jquery 1.5 and make use of the integrated template functionality
 *	(this was a really nice part of using ext.js)
 **/
function registerTemplates() {

	//$.template("subredditTemplate", "<li>${data.display_name}</li>");
	
} // end registerTemplates method

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

