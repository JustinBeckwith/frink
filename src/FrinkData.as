package
{
	import data.RedditAPI;
	
	import flash.net.SharedObject;

	/**
	 * singelton class that acts as the global data reference
	 **/
	public class FrinkData
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		protected static var _instance : FrinkData;
		protected var _api : RedditAPI;
		protected static var allowInstantiation : Boolean;
		
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
	
		
	}
}