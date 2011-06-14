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
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadSubReddits_errorHandler);
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
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadPosts_errorHandler);
			loader.load(request);
		}
		
		/**
		 * loadComments
		 **/
		public function loadComments(post:Object) : void {
			
			var url : String = "http://www.reddit.com" + post.permalink + ".json";
			var request : URLRequest = new URLRequest(url);
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadComments_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadComments_errorHandler);
			loader.load(request);
		} 
		
		/**
		 *	attemptLogin
		 **/
		public function attemptLogin(username:String, password:String) : void {
			
			var url : String = "http://www.reddit.com/api/login/" + username;
			
			var request : URLRequest = new URLRequest(url);
			var requestVars : URLVariables = new URLVariables();
			requestVars.op = "login-main";
			requestVars.id = "%23login_login-main";
			requestVars.renderstyle= "html";
			requestVars.passwd = password;
			requestVars.user = username;
			request.data = requestVars;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, attemptLogin_completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, attemptLogin_errorHandler);
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
		
		protected function loadPost_errorHandler(event:IOErrorEvent) : void {
			trace(event);
		}
		
		/**
		 * loadPosts handlers
		 **/
		
		protected function loadPosts_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.POSTS_LOADED, obj));
		}
		
		protected function loadPosts_errorHandler(event:IOErrorEvent) : void {
			trace(event);
		}
		
		/**
		 * loadComments handlers
		 **/
		
		protected function loadComments_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.COMMENTS_LOADED, obj));
		}
		
		protected function loadComments_errorHandler(event:Event) : void {
			trace(event);
		}
		
		/**
		 * loadSubReddits handlers
		 **/
		protected function loadSubReddits_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.SUBREDDITS_LOADED, obj));
		}
		
		protected function loadSubReddits_errorHandler(event:Event) : void {
			trace(event);
		}
		
		
		/**
		 * attemptLogin handlers
		 **/
		
		protected function attemptLogin_completeHandler(event:Event) : void {
			var obj : Object = JSON.decode((event.target as URLLoader).data);
			this.dispatchEvent(new RedditEvent(RedditEvent.LOGIN_ATTEMPTED, obj));
		}
		
		protected function attemptLogin_errorHandler(event:Event) : void {
			trace(event);
		}
	
		
	}
}