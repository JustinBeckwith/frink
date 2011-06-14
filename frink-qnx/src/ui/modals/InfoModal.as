package ui.modals
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import qnx.dialog.AlertDialog;
	import qnx.dialog.DialogSize;
	import qnx.ui.core.Container;
	
	/**
	 * modal UI class for showing the about/info screen
	 **/
	public class InfoModal
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		protected var dg : AlertDialog;
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function InfoModal()
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
			
			dg = new AlertDialog();
			dg.title = "FRINK!";
			dg.message = "Welcome to Frink!";
			dg.addButton("OK");
			dg.dialogSize= DialogSize.SIZE_MEDIUM;
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
		
		/**
		 * click event 
		 **/
		protected function buttonClickHandler(event : MouseEvent) : void {
			
		}
		
	}
}