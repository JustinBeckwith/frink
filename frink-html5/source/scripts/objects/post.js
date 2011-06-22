
/*--------------------------------------------------------------------------
--
-- LOAD EVENTS
--
--------------------------------------------------------------------------*/


$(document).ready(function(e) {
	
	// btnBack_click
	$("#btnBack").live('click', function(e) {
		$("#contentFrame").attr('src', '');
		$middle.css('left', 201);
		$tabPost.css("display", 'none');
	});
	
	// btnUpBoat_click
	$("#btnUpBoat").live('click', function(e) {
		makeVote(true);
	});
	
	// btnDownBoat_click
	$("#btnDownBoat").live('click', function(e) {
		makeVote(false);
	});
	
	// btnComments_click
	$("#btnComments").live('click', function(e) {
		if ($postCommentsScroller.css('display') == 'none') {
			$(this).attr('src', 'images/icons/comments-selected.png');
			renderPostBody(r_post, true, true);
		} // end if
		else {
			$(this).attr('src', 'images/icons/comments.png');
			renderPostBody(r_post, false, true)
		} // end else
	});
	
	// track drag movements on posting tab
	/*
	$("#tabPost").mousedown(function(e){
		startMouseX = e.clientX;
		startTabX = $("#tabPost").position().left;
		isDown = true;
	});
	*/
	
	/**
	 *	when the user swipes backwards on a tablet handle the movement of abs pos divs
	 *	TODO: js physics engine probably makes this a lot easier
	 */
	/*
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
	*/
	
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
	
});


/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/


/**
 *	renderPostBody
 **/
function renderPostBody(r_post, showComments, animateSwitch) {

	var	$postHeader = $("#post-header");
	
	// if there are only comments, no need to deal with the iframe
	if (r_post.is_self || showComments) {
		showSpinny($postContent);
		$contentFrame.css('display', 'none')
						.attr('src', '');
		$postCommentsScroller.css('display', '');
		LoadComments(loadComments_Handler, r_post);
	} else {
		$postCommentsScroller.css('display', 'none');
		$contentFrame.attr('src', r_post_url)
					.css('display', '');		
	} // end else
	
	$contentFrame.css('height', $(window).height() - $postHeader.height() - 4);
    $postCommentsScroller.css('height', $(window).height() - $postHeader.height() - 4);
	
} // end renderPostBody method





/**
 * manage the UI and api calls for a vote
 * 
 * the reddit API only takes a +1, 0, -1 for votes.  An upvote after a downvote
 * simply sends the +1, up after up sends a 0, etc
 **/
function makeVote(up) {
	
	if (isLoggedIn) {
		
		// vote logic if the user is logged in
		var dir = 0;
		
		// figure out if the user likes it, hates it, or is ambivalent
		if (r_post.likes == null) {
			// there hasn't been a vote yet, so just make the call and do the UI work
			dir = up ? 1 : -1;
		} else if (r_post.likes == false) {
			// the post was previously down voted - undo downs but flipsy up votes
			dir = up ? 1 : 0;
		} else if (r_post.likes == true) {
			// the post was previously up voted - undo ups but flipsy downs
			dir = up ? 0 : -1;
		}
		
		// update the underlying data structure and UI elements 
		if (dir == 0) {
			r_post.likes = null;
			$("#btnUpBoat").attr('src', 'images/icons/arrow-up.png');
			$("#btnDownBoat").attr('src', 'images/icons/arrow-down.png');
		} else if (dir == -1) {
			r_post.likes = false;
			$("#btnUpBoat").attr('src', 'images/icons/arrow-up.png');
			$("#btnDownBoat").attr('src', 'images/icons/arrow-down-selected.png');
		} else if (dir == 1) { 
			r_post.likes = true;
			$("#btnUpBoat").attr('src', 'images/icons/arrow-up-selected.png');
			$("#btnDownBoat").attr('src', 'images/icons/arrow-down.png');
		}
		
		// perform the back end data call to cast the vote
		vote(null, r_post.name, dir);
	} else {
		// if not logged in, show them the settings dialog
		$("#btnSettings").click();
	}
}


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


