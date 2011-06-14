package ui.panels
{
	import qnx.ui.text.Label;
	import qnx.ui.text.TextInput;
	
	public class SearchPanel extends FrinkPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function SearchPanel()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		protected override function initUI() : void {
			
			super.initUI();
			this.debugColor = 0x993333;
			
			var tb : TextInput = new TextInput();
			this.addChild(tb);
			
			var lb : Label = new Label();
			lb.text = "Enter search term:";
			this.addChild(lb);
		}
	}
}