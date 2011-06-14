package ui.modals
{
	import qnx.dialog.BaseDialog;
	import qnx.ui.buttons.Button;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.text.Label;
	import qnx.ui.text.TextInput;

	public class WriteModal 
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		protected var textbox : TextInput;
		protected var label : Label;
		protected var btnPost : LabelButton;
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function WriteModal()
		{
			this.initUI();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * build the UI
		 **/
		protected function initUI() : void {
			
			// post textbox
			textbox = new TextInput();
			//this.add(textbox);
			
			// label
			label = new Label();
			label.text = "Link to post:";
			//this.addChild(label);
			
			// button
			btnPost = new LabelButton();
			btnPost.label = "Post";
			//this.addChild(btnPost);
		}
		
		public function show() : void {
			
		}
	}
}