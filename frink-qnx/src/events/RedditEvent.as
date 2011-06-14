package events
{
	import flash.events.Event;
	
	/**
	 * RedditEvent
	 * 
	 **/
	public class RedditEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//	Event Enumeration
		//
		//--------------------------------------------------------------------------
		
		public static const POSTS_LOADED : String = "postsLoaded";
		public static const SUBREDDITS_LOADED : String = "subRedditsLoaded";
		public static const COMMENTS_LOADED : String = "commentsLoaded";
		public static const POST_LOADED : String = "postLoaded";
		public static const LOGIN_ATTEMPTED : String = "loginAttempted";
		
		//--------------------------------------------------------------------------
		//
		//	Variables
		//
		//--------------------------------------------------------------------------
		
		public var result : Object;
		
		//--------------------------------------------------------------------------
		//
		//	Constructors
		//
		//--------------------------------------------------------------------------
		
		public function RedditEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.result = result;
			super(type, bubbles, cancelable);
		}
	}
}