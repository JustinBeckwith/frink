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
		public static const LOGOUT : String = "logout";
		public static const VOTE_COMPLETE : String = "voteComplete";
		public static const CHILDREN_LOADED : String = "childrenLoaded";
		public static const MESSAGES_LOADED : String = "messagesLoaded";
		public static const UNREAD_MESSAGE_COUNT_LOADED : String = "unreadMessageCountLoaded";
		public static const API_ERROR : String = "apiError";
		
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
		
		public function RedditEvent(type:String, result:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.result = result;
			super(type, bubbles, cancelable);
		}
	}
}