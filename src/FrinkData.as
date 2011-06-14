package
{
	import data.RedditAPI;
	
	import events.FrinkEvent;
	import events.RedditEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;

	/**
	 * singelton class that acts as the global data reference
	 **/
	[Event(name="authChange", type="events.FrinkEvent")]
	[Event(name="modalOpen", type="events.FrinkEvent")]
	[Event(name="modalClose", type="events.FrinkEvent")]
	public class FrinkData extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected static var _instance : FrinkData;
		protected var _api : RedditAPI;
		protected static var allowInstantiation : Boolean;
		protected var version : String = "1.0.0";
		protected var mailTimer : Timer;
		public var isLocal : Boolean = false;
		
		/**
		 * check if the user has previously entered credentials
		 **/
		public function get hasCredentials() : Boolean {
			return this.database.data.username != null &&
					this.database.data.username != '' &&
					this.database.data.password != null &&
					this.database.data.password != '';
		}
		
		/**
		 * global shared object
		 **/
		public function get database() : SharedObject {
			return SharedObject.getLocal("redditCredentials");
		}
		
		
		/**
		 * use a single instance of the reddit api
		 **/
		public function get api() : RedditAPI {
			if (_api == null)
				_api = new RedditAPI();
			return _api;
		}
		
		/**
		 * return the single instance of FrinkData
		 **/
		public static function get instance() : FrinkData {
			if (FrinkData._instance == null) {
				FrinkData.allowInstantiation = true;
				FrinkData._instance = new FrinkData();
				FrinkData.allowInstantiation = false;
			}
			return FrinkData._instance;
		}
		
		/**
		 * wrapper method for reddit api isLoggedIn
		 **/
		public function get isLoggedIn() : Boolean {
			return this.api.isLoggedIn;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		/**
		 * only allow the constructor if getInstance is being called the first time
		 **/
		public function FrinkData()
		{
			if (!FrinkData.allowInstantiation) {
				throw new Error("Hey, I'm a singleton!  Maybe try getInstance().");
			} else {
				this.mailTimer = new Timer(1*60*1000);
				this.mailTimer.addEventListener(TimerEvent.TIMER, mailTimer_tickHandler);
				this.api.addEventListener(RedditEvent.LOGIN_ATTEMPTED, api_loginAttempted);
				this.api.addEventListener(RedditEvent.LOGOUT, api_logout);
				this.addEventListener(FrinkEvent.AUTH_CHANGE, frink_authChangeHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * get the label for the amount of time that has passed since the given utc time in milliseconds
		 **/
		public function getAgoLabel(created_utc : Number) : String {
			
			var currentTimeTicks : Number = (new Date()).getTime();
			var minutesAgoCreated : Number = (currentTimeTicks - (created_utc*1000))/1000/60;
			var unitsAgo : Number;
			var unitLabel : String;
			
			if (minutesAgoCreated > 60*24*365) {
				unitsAgo = Math.round(minutesAgoCreated/60/24/30);
				unitLabel = "year"
			} else if (minutesAgoCreated > 60*24*30) {
				unitsAgo = Math.round(minutesAgoCreated/60/24/30);
				unitLabel = "month";
			} else if (minutesAgoCreated > 60*24) {
				unitsAgo = Math.round(minutesAgoCreated/60/24);
				unitLabel = "day";	
			} else if (minutesAgoCreated > 60) {
				unitsAgo = Math.round(minutesAgoCreated/60);
				unitLabel = "hour";
			} else {
				unitsAgo = Math.round(minutesAgoCreated);
				unitLabel = "minute";
			} // end else
			
			var agoLabel : String = unitsAgo + " " + unitLabel + (unitsAgo > 1 ? "s" : "");
			return agoLabel;
		}
		
		/**
		 * perform a login with the stored credentials
		 * primarily used at the start of the app
		 **/
		public function autoLogin() : void {
			// global event handler for auto login added in constructor
			FrinkData.instance.api.attemptLogin(this.database.data.username, this.database.data.password);
		}
		
		/**
		 * clear the credentials and log the user out
		 **/
		public function logOut() : void {
			this.database.data.username = null;
			this.database.data.password = null;
			FrinkData.instance.api.logOut();
		}
		
		/**
		 * raise a global event notifying a modal open or close
		 **/
		public function raiseModalEvent(event:FrinkEvent) : void {
			this.dispatchEvent(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * when a log in occurs dispatch an event to the rest of the app 
		 **/
		protected function api_loginAttempted(event:RedditEvent) : void {
			if (event.result.success) {
				var evt : FrinkEvent = new FrinkEvent(FrinkEvent.AUTH_CHANGE, event.result);
				this.dispatchEvent(evt);
			}
		}
		
		/**
		 * notify the system a logout event has occurred
		 **/
		protected function api_logout(event:RedditEvent) : void {
			var evt : FrinkEvent = new FrinkEvent(FrinkEvent.AUTH_CHANGE, event.result);
			this.dispatchEvent(evt);
		}
		
		/**
		 * on auth changes start/stop the mail timer
		 **/
		protected function frink_authChangeHandler(event:FrinkEvent) : void {
			if (this.isLoggedIn) {
				mailTimer.start();
				this.api.getUnreadMessageCount();
			}
			else {
				mailTimer.stop();
			}
		}
		
		/**
		 * every (x) minutes check for new mail
		 **/
		protected function mailTimer_tickHandler(event:TimerEvent) : void {
			this.api.getUnreadMessageCount();
		}
		
	}
}