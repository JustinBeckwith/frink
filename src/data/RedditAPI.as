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
		protected var url_base : String = "http://www.reddit.com/";
		protected var url_myReddits : String = "http://www.reddit.com/reddits/mine/.json?count=25";
		protected var url_popularReddits : String = "http://www.reddit.com/reddits/.json?count=25";
		protected var isLoggedIn : Boolean = false;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	loadSubReddits
		 **/
		public function loadSubReddits(before:String = null, after:String = null) : void {
			
			var url : String = isLoggedIn ? url_myReddits : url_popularReddits;
			
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
			
			var url : String = url_base;	
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
			
			var url : String = "http://www.reddit.com/api/moreChildren";
			
			
			var request : URLRequest = new URLRequest(url);
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
		 **/
		public function vote(name:String, up:Boolean, voteHash : String, userHash : String) : void {
			
			var url : String = "http://www.reddit.com/api/vote";
			
			var request : URLRequest = new URLRequest(url);
			request.method = "post";
			request.contentType = "json";
			
			var requestVars : URLVariables = new URLVariables();
			requestVars.id = name;
			requestVars.dir = up ? 1 : -1;
			requestVars.vh = "crap.";
			requestVars.uh = "wo!";
			request.data = requestVars;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, vote_completeHandler);
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
		 * attemptLogin handlers
		 **/
		
		protected function attemptLogin_completeHandler(event:Event) : void {
			//var obj : Object = JSON.decode((event.target as URLLoader).data);
			
			// this is so lame.  The best way to do this is to read the cookies,
			// but I don't think that's an option with URLLoader.  Option B is
			// to try this, then a follow on request, but I'm very lazy.
			
			var success : Boolean = (((event.target as URLLoader).data as String).indexOf(".recover-password") == -1);
			var obj : Object = { success: success };
			this.dispatchEvent(new RedditEvent(RedditEvent.LOGIN_ATTEMPTED, obj));
		}
		
		
		
		
		/**
		 * generic io error handler
		 **/
		protected function api_errorHandler(event:Event) : void {
			this.dispatchEvent(new RedditEvent(RedditEvent.API_ERROR, null));
		}
	
		
	}
}