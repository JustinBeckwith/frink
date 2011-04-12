package events
{
	import flash.events.Event;
	
	/**
	 * event class for UI layer events
	 * 
	 **/
	public class FrinkEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//	Event Enumeration
		//
		//--------------------------------------------------------------------------
		
		public static const AUTH_CHANGE : String = "authChange";
		
		
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
		
		public function FrinkEvent(type:String, result:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.result = result;
			super(type, bubbles, cancelable);
		}
	}
}