package ui
{	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	
	import ui.modals.InfoModal;
	import ui.modals.SettingsModal;
	import ui.modals.WriteModal;
	import ui.panels.FrinkPanel;
	
	
	[Event(name="change", type="flash.events.Event")] 
	public class Toolbar extends Container
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// currently selected tab panel
		public var selectedPanel : String = FrinkPanel.FRONT_PAGE;
		
		// VISUAL ELEMENTS
		
		// buttons
		protected var btnFrontPage : LabelButton;
		protected var btnAllReddits : LabelButton;
		protected var btnSubReddits : LabelButton;
		protected var btnProfile : LabelButton;
		protected var btnSearch : LabelButton;
		protected var btnMail : LabelButton;
		protected var btnWrite : LabelButton;
		protected var btnSettings : LabelButton;
		protected var btnInfo : LabelButton;
		
		// dialogs
		protected var dgInfo : InfoModal;
		protected var dgSettings : SettingsModal;
		protected var dgWrite : WriteModal;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 **/
		public function Toolbar()
		{
			super();
			this.initUI();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * create all user interface elements
		 **/
		protected function initUI() : void {           
			
			// main component
			this.flow = ContainerFlow.VERTICAL;
			this.debugColor = 0xFF3300;
			this.size = 200;
			this.sizeUnit = SizeUnit.PIXELS;
			this.align = ContainerAlign.NEAR;
			
			// create bottom container
			var bottom : Container = new Container();
			bottom.flow = ContainerFlow.HORIZONTAL;
			bottom.containment = Containment.DOCK_BOTTOM;
			bottom.debugColor = 0x00FF00;
			
			// write button
			btnWrite = new LabelButton();
			btnWrite.label = "W";
			btnWrite.width = 32;
			btnWrite.height = 32;
			btnWrite.addEventListener(MouseEvent.CLICK, btnWrite_clickHandler);
			bottom.addChild(btnWrite);
			
			// settings button
			btnSettings = new LabelButton();
			btnSettings.label = "S";
			btnSettings.width = 32;
			btnSettings.height = 32;
			btnSettings.addEventListener(MouseEvent.CLICK, btnSettings_clickHandler);
			bottom.addChild(btnSettings);
			
			// about button
			btnInfo = new LabelButton();
			btnInfo.label = "A";
			btnInfo.width = 32;
			btnInfo.height = 32;
			btnInfo.addEventListener(MouseEvent.CLICK, btnInfo_clickHandler);
			bottom.addChild(btnInfo);
			
			// add the bottom bar to the layout
			this.addChild(bottom);
			
			
			// reddit alien
			
			
			// front page
			btnFrontPage = new LabelButton();
			btnFrontPage.label = "Front Page";
			btnFrontPage.addEventListener(MouseEvent.CLICK, btnMenu_clickHandler);
			this.addChild(btnFrontPage);
			
			// all reddits
			btnAllReddits = new LabelButton();
			btnAllReddits.label = "All Reddits";
			btnAllReddits.addEventListener(MouseEvent.CLICK, btnMenu_clickHandler);
			this.addChild(btnAllReddits);
			
			// SubReddits
			btnSubReddits = new LabelButton();
			btnSubReddits.label = "SubReddits";
			btnSubReddits.addEventListener(MouseEvent.CLICK, btnMenu_clickHandler);
			this.addChild(btnSubReddits);
			
			// Mail
			btnMail = new LabelButton();
			btnMail.label = "Mail";
			btnMail.addEventListener(MouseEvent.CLICK, btnMenu_clickHandler);
			this.addChild(btnMail);
			
			// Profile
			btnProfile = new LabelButton();
			btnProfile.label = "Profile";
			btnProfile.addEventListener(MouseEvent.CLICK, btnMenu_clickHandler);
			this.addChild(btnProfile);
			
			// Search
			btnSearch = new LabelButton();
			btnSearch.label = "Search";
			btnSearch.addEventListener(MouseEvent.CLICK, btnMenu_clickHandler);
			this.addChild(btnSearch);
			
			// modals
			dgInfo = new InfoModal();
			dgSettings = new SettingsModal();
			dgWrite = new WriteModal();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * btnMenu_clickHandler
		 **/
		protected function btnMenu_clickHandler(event:MouseEvent) : void {
			switch (event.target) {
				case btnFrontPage:
					this.selectedPanel = FrinkPanel.FRONT_PAGE;
					break;
				case btnAllReddits:
					this.selectedPanel = FrinkPanel.ALL_REDDITS;
					break;
				case btnSubReddits:
					this.selectedPanel = FrinkPanel.SUB_REDDITS;
					break;
				case btnProfile:
					this.selectedPanel = FrinkPanel.PROFILE;
					break;
				case btnSearch:
					this.selectedPanel = FrinkPanel.SEARCH;
					break;
				case btnMail:
					this.selectedPanel = FrinkPanel.MAIL;
					break;
				case btnSearch: 
					this.selectedPanel = FrinkPanel.SEARCH;
					break;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * btnWrite_clickHandler
		 **/
		protected function btnWrite_clickHandler(event:MouseEvent) : void {
			dgWrite.show();
		}
		
		/**
		 * btnSettings_clickHandler
		 **/
		protected function btnSettings_clickHandler(event:MouseEvent) : void {
			dgSettings.show();			
		}
		
		/**
		 * btnInfo_clickHandler
		 **/
		protected function btnInfo_clickHandler(event:MouseEvent) : void {
			dgInfo.show();
		}
		
		
	}
}