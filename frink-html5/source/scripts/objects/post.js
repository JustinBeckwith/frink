
/*--------------------------------------------------------------------------
--
-- LOAD EVENTS
--
--------------------------------------------------------------------------*/


$(document).ready(function(e) {
	
	// btnBack_click
	$("#btnBack").live('click', function(e) {
		$("#tabPosts").animate({left: 201});
		$("#tabPost").css("display", 'none');
	});
	
	// btnUpBoat_click
	$("#btnUpBoat").live('click', function(e) {
		vote(null, r_post, 1);
	});
	
	// btnDownBoat_click
	$("#btnDownBoat").live('click', function(e) {
		vote(null, r_post, -1);
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
	
});


/*--------------------------------------------------------------------------
--
-- METHODS
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


