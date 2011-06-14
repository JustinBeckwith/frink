/**
 *	reddit-api.js
 *	
 *	@desc	this library is responsible for making all backend data calls to the reddit web site
 *	@author	Justin Beckwith
 **/

// url constants
var url_base = "http://www.reddit.com";
var url_myReddits = "http://www.reddit.com/reddits/mine/.json?count=25";
var url_popularReddits = "http://www.reddit.com/reddits/.json?count=25";

/**
 *	LoadReddits
 **/
function LoadReddits(handler, before, after) {
	
	var url = isLoggedIn ? url_myReddits : url_popularReddits;
	
	if (before != null) 
		url += "&before=" + before;
	
	if (after != null)
		url += "&after=" + after;
	
	$.ajax({ 
		url: url,
		jsonp: "jsonp",
		dataType: "jsonp",
		success: function(json) {		
			handler(json);
		} // end success handler
	});

} // end LoadReddits function


//
// LoadPosts
//
function LoadPosts(handler, before, after) {
	
	
	var url = "http://www.reddit.com/";	
	if (r_subreddit != null && r_subreddit != "") {
		url += "r/" + r_subreddit + "/";		
	} // end if		
	url += ".json?count=25";
	
	if (before != null) 
		url += "&before=" + before;
	
	if (after != null)
		url += "&after=" + after;
	
	$.ajax({ 
		url: url,
		//jsonp: "jsonp",
		dataType: "json",
		success: function(json) {
			handler(json);
		} // end success handler
	});

} // end LoadPosts function

//
// LoadComments
//
function LoadComments(handler) {
	
	var url = "http://www.reddit.com" + r_post.permalink + ".json";
	
	$.ajax({ 
		url: url,
		jsonp: "jsonp",
		dataType: "jsonp",
		success: function(json) {
			handler(json);
		} // end success
	});
} // end LoadComments function

/**
 *	attemptLogin
 **/
function attemptLogin(handler, username, password) {
	
	$.ajax({
		url: "http://www.reddit.com/api/login/" + username,
		dataType: "json",
		contentType: "application/x-www-form-urlencoded",
		data: "op=login-main&id=%23login_login-main&renderstyle=html&passwd=" + password + "&user=" + username,
		success: function(json) {
			handler(json);
		} // end success
	});
	
} // end attemptLogin method
