package events
{
	import flash.events.Event;
	
	import views.panels.postList;
	
	public class PanelEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//	Event Enumeration
		//
		//--------------------------------------------------------------------------
		
		public static const POST_SELECTED : String = "postSelected";
		
		//--------------------------------------------------------------------------
		//
		//	Variables
		//
		//--------------------------------------------------------------------------
		
		public var list : postList;
		
		//--------------------------------------------------------------------------
		//
		//	Constructors
		//
		//--------------------------------------------------------------------------
		
		public function PanelEvent(type:String, list:postList, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.list = list;
			super(type, bubbles, cancelable);
		}
	}
}