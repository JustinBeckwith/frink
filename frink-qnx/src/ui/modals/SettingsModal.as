package ui.modals
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.logging.Log;
	
	import qnx.dialog.DialogSize;
	import qnx.dialog.LoginDialog;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.text.Label;
	import qnx.ui.text.TextInput;
	
	/**
	 * ui class for the settings modal
	 **/
	public class SettingsModal
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		protected var dg : LoginDialog;
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function SettingsModal()
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
			
			dg = new LoginDialog();
			dg.title = "Device is locked";
			dg.message = "Please enter your username and password:";
			dg.addButton("OK");
			dg.addButton("Cancel");            
			dg.passwordPrompt = "password";
			dg.rememberMeLabel = 'Remember me';
			dg.rememberMe = true;
			dg.dialogSize= DialogSize.SIZE_SMALL;
			dg.addEventListener(Event.SELECT, buttonClickHandler); 
			
		}
		
		public function show() : void {
			dg.show();
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function buttonClickHandler(e : MouseEvent) : void {
			
		}
	}
}