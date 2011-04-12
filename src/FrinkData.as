package
{
	import data.RedditAPI;
	
	import events.FrinkEvent;
	import events.RedditEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;

	/**
	 * singelton class that acts as the global data reference
	 **/
	[Event(name="authChange", type="events.FrinkEvent")]
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
				this.api.addEventListener(RedditEvent.LOGIN_ATTEMPTED, api_loginAttempted);
				this.api.addEventListener(RedditEvent.LOGOUT, api_logout);
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
			var agoLabel : String = "";
			if (minutesAgoCreated > 60) {
				agoLabel = Math.round(minutesAgoCreated/60) + " Hours";
			} else {
				agoLabel = Math.round(minutesAgoCreated) + " Minutes";
			} // end else
			
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
		
	}
}