package
{
	import data.RedditAPI;
	
	import events.RedditEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	
	import qnx.dialog.AlertDialog;
	import qnx.ui.buttons.Button;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerFlow;
	
	import ui.Toolbar;
	import ui.panels.*;

	[SWF(width="1024", height="600", backgroundColor="#cccccc", frameRate="30")]
	public class frink extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		
		protected var myMain : Container;
		protected var toolbar : Toolbar;
		
		// PANELS
		protected var allRedditsPanel : AllRedditsPanel;
		protected var frontPagePanel : FrontPagePanel;
		protected var mailPanel : MailPanel;
		protected var profilePanel : ProfilePanel;
		protected var searchPanel : SearchPanel;
		protected var subRedditsPanel : SubRedditsPanel;
		protected var panels : ArrayCollection = new ArrayCollection();
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		/**
		 * constructor
		 **/
		public function frink()
		{
			super();
			
			// create events
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			// set up all of the globals
			FrinkData.instance.api = new RedditAPI();
			
			// create ui
			this.initUI();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * create all UI components
		 **/
		protected function initUI() : void {
			
			// create main container 
			myMain = new Container();
			myMain.flow = ContainerFlow.HORIZONTAL;
			myMain.debugColor = 0xFFCC00;
			this.addChild(myMain);
						
			// add child elements
			toolbar = new Toolbar();
			toolbar.addEventListener(Event.CHANGE, toolbar_changeHandler);
			myMain.addChild(toolbar);
				
			// front page panel
			frontPagePanel = new FrontPagePanel();
			panels.addItem(frontPagePanel);
			myMain.addChild(frontPagePanel);
			
			// all reddits panel
			allRedditsPanel = new AllRedditsPanel();
			panels.addItem(allRedditsPanel);
			myMain.addChild(allRedditsPanel);
			
			// mail panel
			mailPanel = new MailPanel();
			panels.addItem(mailPanel);
			myMain.addChild(mailPanel);
			
			// profile panel
			profilePanel = new ProfilePanel();
			panels.addItem(profilePanel);
			myMain.addChild(profilePanel);
			
			// search panel
			searchPanel = new SearchPanel();
			panels.addItem(searchPanel);
			myMain.addChild(searchPanel);
			
			// subreddits panel
			subRedditsPanel = new SubRedditsPanel();
			panels.addItem(subRedditsPanel);
			myMain.addChild(subRedditsPanel);
						
			stage.nativeWindow.visible = true;	
			
			// the first panel shown is front page
			this.frontPagePanel.showUI();
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Events
		//
		//--------------------------------------------------------------------------
		
		/**
		 * invoked when a click of the buttons on the toolbar occurs
		 **/
		protected function toolbar_changeHandler(event : Event) : void {
			
			// hide all of the panels
			for each (var fp : FrinkPanel in panels) {
				fp.visible = false;
			}
			
			// show the appropriate panel
			var panel : FrinkPanel = null;
			switch(toolbar.selectedPanel) {
				case FrinkPanel.FRONT_PAGE:
					panel = frontPagePanel;
					break;
				case FrinkPanel.ALL_REDDITS:
					panel = allRedditsPanel;
					break;
				case FrinkPanel.SUB_REDDITS:
					panel = subRedditsPanel;
					break;
				case FrinkPanel.PROFILE:
					panel = profilePanel;
					break;
				case FrinkPanel.MAIL:
					panel = mailPanel;
					break;
				case FrinkPanel.SEARCH:
					panel = searchPanel;
					break;
			}
			panel.showUI();
			
		}
		
		/**
		 * onResize
		 **/
		private function onResize(event: Event):void
		{
			myMain.setSize(stage.stageWidth, stage.stageHeight);
		}
		
		/**
		 * handleAddedToStage
		 **/
		private function handleAddedToStage(e : Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			stage.addEventListener( Event.RESIZE, onResize );
			onResize(new Event(Event.RESIZE));
		}
		

	}
}