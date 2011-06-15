/**
 *	reddit-api.js
 *	
 *	@desc	this library is responsible for making all backend data calls to the reddit web site
 *	@author	Justin Beckwith
 **/

//--------------------------------------------------------------------------
//
//	Variables
//
//--------------------------------------------------------------------------
		

// url constants
var URL_BASE = "http://www.reddit.com/";
	
var URL_MY_REDDITS = "http://www.reddit.com/reddits/mine/.json?count=25";
var URL_POPULAR_REDDITS = "http://www.reddit.com/reddits/.json?count=25";

var URL_MESSAGES_INBOX = "http://www.reddit.com/message/inbox/.json";
var URL_MESSAGES_SENT = "http://www.reddit.com/message/sent/.json";
var URL_MESSAGES_COMMENTS = "http://www.reddit.com/message/comments/.json";
var URL_MESSAGES_MOD = "http://www.reddit.com/message/moderator/.json";
var URL_MESSAGES_UNREAD = "http://www.reddit.com/message/unread.json";

var URL_VOTE = "http://www.reddit.com/api/vote";
var URL_MORE_CHILDREN = "http://www.reddit.com/api/moreChildren";
var URL_LOGOUT = "http://www.reddit.com/logout";
var URL_LOGIN = "http://www.reddit.com/api/login";

// other global variables
var isLoggedIn = false;
var userHash = '';
var unreadMessageCount = 0;


/**
 *	LoadReddits
 **/
function LoadReddits(handler, before, after) {
	
	var url = isLoggedIn ? URL_MY_REDDITS : URL_POPULAR_REDDITS;
	
	if (before != null) 
		url += "&before=" + before;
	
	if (after != null)
		url += "&after=" + after;
	
	$.getJSON(url, function(json) {		
			handler(json);
		} // end success handler
	);

} // end LoadReddits function


//
// LoadPosts
//
function LoadPosts(handler, subreddit, before, after) {
	
	
	var url = URL_BASE;	
	if (subreddit != null && subreddit != "") {
		url += "r/" + subreddit + "/";		
	} // end if
	url += ".json?count=25";
	
	if (before != null) 
		url += "&before=" + before;
	
	if (after != null)
		url += "&after=" + after;
	
	$.getJSON(url, function(json) {
			handler(json);
		} // end success handler
	);

} // end LoadPosts function

//
// LoadComments
//
function LoadComments(handler, post) {
	
	var url = "http://www.reddit.com" + post.permalink + ".json";
	
	$.getJSON(url, function(json) {
			handler(json);
		} // end success
	);
} // end LoadComments function

/**
 *	attemptLogin
 **/
function attemptLogin(handler, username, password) {
	
	var url = URL_LOGIN + "/" + username;
	var postData = "op=login-main&id=%23login_login-main&renderstyle=html&passwd=" + password + "&user=" + username;
	
	$.post(url, postData, 
		function(json, textStatus) {
			handler(json);
		}, "json" 
	);
	
} // end attemptLogin method



/**
 *	vote
 **/
function vote(handler, name, direction) {
	
	var url = URL_VOTE;
	var postData = "id=" + name + "&dir=" + direction + "&renderstyle=html&uh=" + userHash; 
	
	$.post(url, postData, 
		function(json, textStatus) {
			handler(json);
		}, "json" 
	);
	
} // end vote method


/**
 *	logout
 **/
function logout(handler) {
	
	var url = URL_LOGOUT;
	var postData = "uh=" + userHash; 
	
	$.post(url, postData, 
		function(json, textStatus) {
			if (handler) handler(json);
		}, "json" 
	);
	
} // end logout method

/**
 *	loadMessages - public available, normal handler
 **/
function loadMessages(messageType, before, after) {
	this.loadMessagesInternal(loadMessages_completeHandler, messageType, before, after);
}

/**
 * loadMessages - route to the appropriate listener
 **/
function loadMessagesInternal(handler, messageType, before, after) {
	
	var url = null;
	switch(messageType) {
		case MessageType.INBOX:
			url = URL_MESSAGES_INBOX;
			break;
		case MessageType.COMMENTS:
			url = URL_MESSAGES_COMMENTS;
			break;
		case MessageType.MOD:
			url = URL_MESSAGES_MOD;
			break;
		case MessageType.SENT:
			url = URL_MESSAGES_SENT;
			break;
		case MessageType.UNREAD:
			url = URL_MESSAGES_UNREAD;
			break;
	}
	
	if (before != null) 
		url += "&before=" + before;
	
	if (after != null)
		url += "&after=" + after;
	
	$.getJSON(url, handler)
	
	// any time you request the messages list with .json, the message is not
	// marked as read.  To get around this, make a phantom request to the non-json
	// version of the request message 
	if (messageType != MessageType.UNREAD) 
	{
		var url2 = url.replace(".json","");
		
		// var loader2 : URLLoader = new URLLoader();
		// loader2.addEventListener(Event.COMPLETE, api_messageNotifyHandler);
		// loader2.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
		// loader2.load(request2);
	}
} 

/**
 * get the number of unread messages for the current user
 **/
function getUnreadMessageCount(handler) {
	loadMessagesInternal(handler, MessageType.UNREAD);
}

