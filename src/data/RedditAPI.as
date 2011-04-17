package data
{
	import com.adobe.serialization.json.JSON;
	
	import events.RedditEvent;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	
	
	/**
	 * RedditAPI
	 * 
	 * provides API interface for accessing the JSON API
	 **/
	
	[Event(name="postLoaded", type="events.RedditEvent")] 
	[Event(name="postsLoaded", type="events.RedditEvent")]
	[Event(name="commentsLoaded", type="events.RedditEvent")]
	[Event(name="loginAttempted", type="events.RedditEvent")] 
	[Event(name="childrenLoaded", type="events.RedditEvent")]
	[Event(name="messagesLoaded", type="events.RedditEvent")]
	[Event(name="logout", type="events.RedditEvent")] 
	public class RedditAPI extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//	Constructors
		//
		//--------------------------------------------------------------------------
		
		/**
		 * RedditAPI
		 **/
		public function RedditAPI()
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//	Variables
		//
		//--------------------------------------------------------------------------
		
		
		// url constants
		protected const URL_BASE : String = "http://www.reddit.com/";
	
		protected const URL_MY_REDDITS : String = "http://www.reddit.com/reddits/mine/.json?count=25";
		protected const URL_POPULAR_REDDITS : String = "http://www.reddit.com/reddits/.json?count=25";
		
		protected const URL_MESSAGES_INBOX : String = "http://www.reddit.com/message/inbox/.json";
		protected const URL_MESSAGES_SENT : String = "http://www.reddit.com/message/sent/.json";
		protected const URL_MESSAGES_COMMENTS : String = "http://www.reddit.com/message/comments/.json";
		protected const URL_MESSAGES_MOD : String = "http://www.reddit.com/message/moderator/.json";
		
		protected const URL_VOTE : String = "http://www.reddit.com/api/vote";
		protected const URL_MORE_CHILDREN : String = "http://www.reddit.com/api/moreChildren";
		protected const URL_LOGOUT : String = "http://www.reddit.com/logout";
		
		protected var _isLoggedIn : Boolean = false;
		protected var userHash : String = "";
		
		
		//--------------------------------------------------------------------------
		//
		//	Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * expose the isLoggedIn property
		 **/
		public function get isLoggedIn() : Boolean {
			return _isLoggedIn;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	loadSubReddits
		 **/
		public function loadSubReddits(before:String = null, after:String = null) : void {
			
			var url : String = _isLoggedIn ? URL_MY_REDDITS : URL_POPULAR_REDDITS;
			
			if (before != null) 
				url += "&before=" + before;
			
			if (after != null)
				url += "&after=" + after;
			
			var request : URLRequest = new URLRequest(url);
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadSubReddits_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		} 
		
		/**
		 * loadPosts
		 **/
		public function loadPosts(subreddit:String = null, before:String = null, after:String = null) : void {
			
			var url : String = URL_BASE;	
			if (subreddit != null && subreddit != "") {
				url += "r/" + subreddit + "/";		
			} // end if		
			url += ".json?count=25";
			
			if (before != null) 
				url += "&before=" + before;
			
			if (after != null)
				url += "&after=" + after;
			
			var request : URLRequest = new URLRequest(url);
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadPosts_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		}
		
		/**
		 * loadComments
		 **/
		public function loadComments(post:Object) : void {
			
			var url : String = "http://www.reddit.com" + post.data.permalink + ".json?sort=top";
			var request : URLRequest = new URLRequest(url);
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadComments_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		} 
		
		/**
		 *	attemptLogin
		 **/
		public function attemptLogin(username:String, password:String) : void {
			
			var url : String = "http://www.reddit.com/api/login/" + username;
			
			var request : URLRequest = new URLRequest(url);
			request.method = "post";
			//request.contentType = "json";
			
			var requestVars : URLVariables = new URLVariables();
			requestVars.op = "login-main";
			requestVars.id = "%23login_login-main";
			requestVars.renderstyle= "html";
			//requestVars.api_type = "json";
			requestVars.passwd = password;
			requestVars.user = username;
			request.data = requestVars;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, attemptLogin_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		} 
		
		/**
		 *	loadChildren
		 * 	
		 * 	this is used to load additional comments from a thread
		 **/
		public function loadChildren(link_id : String, name:String) : void {
			
			var request : URLRequest = new URLRequest(URL_MORE_CHILDREN);
			request.method = "post";
			
			/*
				link_id=t3_gj8g7
				children=c1nz780%2Cc1nzcj5
				depth=1
				id=t1_c1nz780
				pv_hex=
				r=pics
				renderstyle=html
			*/
			
			var requestVars : URLVariables = new URLVariables();
			requestVars.link_id = link_id;
			requestVars.children = name;
			requestVars.depth = 1;
			requestVars.renderstyle= "html";
			request.data = requestVars;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadChildren_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		} 
		
		/**
		 *	vote
		 * 
		 * @param direction - a value of either -1, 0, +1
		 **/
		public function vote(name:String, direction:int) : void {
				
			var request : URLRequest = new URLRequest(URL_VOTE);
			request.method = "post";
			request.contentType = "application/x-www-form-urlencoded";
			
			// vote hash is in the api docs, but isn't required
			
			var requestVars : URLVariables = new URLVariables();
			requestVars.id = name;
			requestVars.dir = direction;
			requestVars.renderstyle = 'html';
			requestVars.uh = this.userHash;
			request.data = requestVars;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, vote_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		} 
		
		/**
		 * log the user out 
		 **/
		public function logOut() : void {
			
			var request : URLRequest = new URLRequest(URL_LOGOUT);
			request.method = "post";
			
			var requestVars : URLVariables = new URLVariables();
			requestVars.uh = this.userHash;
			request.data = requestVars;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, logOut_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		}
		
		
		/**
		 *	loadMessages
		 **/
		public function loadMessages(messageType:String, before:String = null, after:String = null) : void {
			
			var url : String = null;
			switch(messageType) {
				case MessageType.INBOX:
					url = this.URL_MESSAGES_INBOX;
					break;
				case MessageType.COMMENTS:
					url = this.URL_MESSAGES_COMMENTS;
					break;
				case MessageType.MOD:
					url = this.URL_MESSAGES_MOD;
					break;
				case MessageType.SENT:
					url = this.URL_MESSAGES_SENT;
					break;
			}
			
			if (before != null) 
				url += "&before=" + before;
			
			if (after != null)
				url += "&after=" + after;
			
			var request : URLRequest = new URLRequest(url);
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadMessages_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
			loader.load(request);
		} 

		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------

		/**
		 * loadPost handlers
		 **/
		
		protected function loadPost_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.POST_LOADED, obj));
		}
		
		/**
		 * loadPosts handlers
		 **/
		
		protected function loadPosts_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.userHash = obj.data.modhash;
			this.dispatchEvent(new RedditEvent(RedditEvent.POSTS_LOADED, obj));
		}
		
		/**
		 * loadComments handlers
		 **/
		
		protected function loadComments_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.COMMENTS_LOADED, obj));
		}
		
		/**
		 * loadSubReddits handlers
		 **/
		protected function loadSubReddits_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.SUBREDDITS_LOADED, obj));	
		}
		
		/**
		 * vote handlers
		 **/
		protected function vote_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.VOTE_COMPLETE, obj));	
		}
		
		/**
		 * loadChildren handlers
		 **/
		
		protected function loadChildren_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.CHILDREN_LOADED, obj));
		}
		
		
		/**
		 * loadMessages handlers
		 **/
		
		protected function loadMessages_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.MESSAGES_LOADED, obj));
		}
		
		/**
		 * attemptLogin handler
		 * 
		 * Little explanation on the workflow:  The first request here is a native ajax
		 * request that reddit.com uses on their home page to perform the login.  It returns
		 * a goofy jquery array object thing that contains information on what the UI is 
		 * supposed to do.  For now, I am just checking for the presence of a recover 
		 * password flag they set if it is a failed request.  
		 * 
		 * In the event that there is no recover-password field in the response, I assume
		 * your login is cool.  This will set a cookie that's used for subsquent URLRequests
		 * automatically (sweet).  However, to do anything useful, you need to pass a user
		 * hash (uh) with any vote, comment, or post.  This hash is not returned via header,
		 * cookie, json, or anything remotely useful for an API.  It is only available in the 
		 * source of a HTML request from an authenticated user.  So we need to request 
		 * reddit.com in stage 2, and parse the response looking for:
		 * 
		 * <input type="hidden" value="vmunhulvlv638ecd3e025xxxxx051bxxxxxe61c748ea4d64f5" name="uh">
		 * 
		 * Do I know how to party, or what?
		 **/
		
		protected function attemptLogin_completeHandler(event:Event) : void {
			//var obj : Object = JSON.decode((event.target as URLLoader).data);
			
			// this is so lame.  The best way to do this is to read the cookies,
			// but I don't think that's an option with URLLoader.  Option B is
			// to try this, then a follow on request, but I'm very lazy.
			
			var success : Boolean = (((event.target as URLLoader).data as String).indexOf(".recover-password") == -1);
			
			if (success) {
				// so here it gets fun.  we've succesfully verified the username and password,
				// but to do anything fun you need a user hash that's only returned in the 
				// source of a non json request.  Let the hacking begin.
				
				var url : String = "http://www.reddit.com";
				var request : URLRequest = new URLRequest(url);
				var loader : URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, attemptLoginStage2_completeHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, api_errorHandler);
				loader.load(request);
			} else {
				// since the username password was wrong, no need to go to stage 2 authentication
				var obj : Object = { success: success };
				this.dispatchEvent(new RedditEvent(RedditEvent.LOGIN_ATTEMPTED, obj));
			}
			
		}
		
		/**
		 * attemptLoginStage2_completeHandler
		 **/
		protected function attemptLoginStage2_completeHandler(event:Event) : void {
			
			// look in the response for something like this:
			// <input type="hidden" value="vmunhulvlv638ecd3e025xxxxx051bxxxxxe61c748ea4d64f5" name="uh">
			
			var response : String = (event.target as URLLoader).data;
			var token : String = "<input type=\"hidden\" name=\"uh\" value=\"";
			var startTagIdx : Number = response.indexOf(token);
			var success : Boolean = (startTagIdx != -1);
			
			// if the regex found a match, grab the value
			if (success) {
				var startIdx : Number = startTagIdx + token.length;
				var endIdx : Number = response.indexOf("\"", startIdx);
				//this.userHash = response.substring(startIdx, endIdx);
			}
			
			// raise the event notifying success or fail
			_isLoggedIn = success;
			var obj : Object = { success: success };
			this.dispatchEvent(new RedditEvent(RedditEvent.LOGIN_ATTEMPTED, obj));
		}
		
		
		/**
		 * set the not logged in flag and raise an event when done
		 **/
		protected function logOut_completeHandler(event:Event) : void {
			_isLoggedIn = false;
			this.dispatchEvent(new RedditEvent(RedditEvent.LOGOUT));
		}
		
		/**
		 * generic io error handler
		 **/
		protected function api_errorHandler(event:Event) : void {
			this.dispatchEvent(new RedditEvent(RedditEvent.API_ERROR, null));
		}
	
		
	}
}