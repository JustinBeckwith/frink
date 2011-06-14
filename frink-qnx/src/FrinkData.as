package
{
	import data.RedditAPI;

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
		protected static var allowInstantiation : Boolean;
		
		public var api : RedditAPI;
		
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
	
		
	}
}