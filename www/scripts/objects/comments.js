
/*--------------------------------------------------------------------------
--
-- LOAD EVENTS
--
--------------------------------------------------------------------------*/


var scrollComments;

$(document).ready(function(e) {
	
	// configure iScroll on comments pane
	scrollComments = new iScroll('post-comments-scroller');
	
	// update the label and display settings when an expand/collapse is clicked
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
		scrollComments.refresh();
	});
});



/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/


/**
 *	loadComments_Handler
 **/
function loadComments_Handler(json) {	
			
	// for self posts show the body in the comments page
	if (r_post.selftext_html != null) {
		$postComments.append("<br />" + htmlDecode(r_post.selftext_html) + "<br /><hr /><br />");
	} // end if
			
	// render the recursive comment list
	var comments = json[1].data.children;
	for (var i=0; i<comments.length; i++) {
		if (comments[i].data.kind != 'more')
			renderComment(comments[i].data, $postComments);
	} // end for
	
	scrollComments.refresh();
	hideSpinny($postContent);
			
} // end loadComments_Handler function


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


