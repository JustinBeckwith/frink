package ui.panels
{
	import qnx.ui.core.Container;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	
	public class FrinkPanel extends Container
	{
		
		//--------------------------------------------------------------------------
		//
		//  Static Members
		//
		//--------------------------------------------------------------------------
		
		public static const FRONT_PAGE : String = "frontPage";
		public static const ALL_REDDITS : String = "allReddits";
		public static const SUB_REDDITS : String = "subReddits";
		public static const PROFILE : String = "profile";
		public static const MAIL : String = "mail";
		public static const SEARCH : String = "search";
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function FrinkPanel()
		{
			super();
			initUI();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * called when the panel is initially created
		 **/
		protected function initUI() : void {
			this.visible = false;
			this.debugColor = 0x0000FF;
			this.containment = Containment.CONTAINED;
			this.size = 100;
			this.sizeUnit = SizeUnit.PERCENT;
			this.x = 200;
		}
		
		/**
		 * called when the panel is shown after being hidden
		 **/
		public function showUI() : void {
			this.visible = true;
		}
		
	}
}