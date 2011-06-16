
/*--------------------------------------------------------------------------
--
-- LOAD HANDLERS
--
--------------------------------------------------------------------------*/

var scrollMail;

$(document).ready(function(e) {
	
	scrollMail = new iScroll('tabMail');
	
	// top bar mail type selector - clear the messages and rebind the list
	$("#messageTypeList li").click(function(e) {
		$(this).siblings().removeClass('selected');
		$(this).addClass('selected');
		$("#messages").html('');
		showSpinny($("#tabMail"));
		loadMessages(loadMail_Handler, $(this).text());
	});
	
});


/*--------------------------------------------------------------------------
--
-- METHODS
--
--------------------------------------------------------------------------*/


/**
 *	loadMailTab
 **/
function loadMailTab() {
	showSpinny($("#tabMail"));
	loadMessages(loadMail_Handler, 'inbox');
} // end loadMailTab method



/**
 * loadMail_Handler
 **/
function loadMail_Handler(json) {
	
	var messages = json.data.children;
	var $messages = $("#messages");
			
	// render each reddit
	for (var i=0; i<messages.length; i++) {
		var message = messages[i].data;
		renderMessage(message, $messages);
	} // end for
	
	// show a message if the list is blank
	if (messages.length == 0) {
		var $emptyLI = $("<li></li>");
		$emptyLI.append("<span class='empty'>there doesn't seem to be anything here</span>");
		$messages.append($emptyLI);
	}
	
	r_messages = messages;
	scrollMail.refresh();
	hideSpinny($("#tabMail"));
	
} // end loadMail_Handler function


/**
 *	renderMessage
 **/
function renderMessage(message, $messages) {
	var $subject = $("<div>" + message.subject + "</div>")
	var $header = $("<div class=\"message-header\">from <span class=\"username\"><a href=\"#\">" + message.author + "</a></span> sent <span>" + getAgoLabel(message.created_utc) + " ago<span></div>");
	var $body = $("<div class=\"message-body\">" + message.body + "</div>");
	var $message = $("<li></li>").append($subject).append($header).append($body);
	$messages.append($message);
} // end renderSubreddit method



