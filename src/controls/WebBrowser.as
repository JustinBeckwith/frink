package controls {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	
	import spark.components.Application;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="locationChanging", type="flash.events.LocationChangeEvent")]
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]
	
	/**
	 * component that wraps StageWebView into a UIComponent
	 * based on - http://soenkerohde.com/2010/11/air-mobile-stagewebview-uicomponent/comment-page-1/
	 **/
	public class WebBrowser extends UIComponent{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var yOffset:int = 120;
		public var xOffset:int = 211;
		protected var myStage:Stage;
		private var _url:String;
		private var _text:String;
		private var _stageWebView:StageWebView;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * underlying stagewebview obj
		 **/
		public function get stageWebView():StageWebView{
			return _stageWebView;
		}
		
	
		public function set url(url:String):void{
			_url = url;
			
			if(_stageWebView){
				_stageWebView.loadURL(url);
			}
		}
		
		public function set text(text:String):void{
			_text = text;
			
			if(_stageWebView){
				_stageWebView.loadString(text);
			}
		}
		
		/**
		 * manually remove/add the stage property as visibility is toggled
		 **/
		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (_stageWebView != null) {
				_stageWebView.stage = value ? myStage : null;
				_stageWebView.viewPort = new Rectangle(xOffset, yOffset, myStage.fullScreenWidth - xOffset, myStage.fullScreenHeight - yOffset);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		
		public function WebBrowser(){
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		public function hide():void{
			_stageWebView.stage = null;
		}
		
		public function show():void{
			_stageWebView.stage = myStage;
		}
		
		public function dispose():void{
			hide();
			_stageWebView.dispose();
		}

		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function addedToStageHandler(event:Event):void{
			myStage = event.currentTarget.document.stage;
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_stageWebView = new StageWebView();
			//_stageWebView.stage = this.visible ? myStage : null;
			//_stageWebView.viewPort = new Rectangle(0, yOffset, myStage.width, myStage.fullScreenHeight - yOffset);
			_stageWebView.viewPort = this.getBounds(this.stage);
			_stageWebView.addEventListener(Event.COMPLETE, completeHandler);
			_stageWebView.addEventListener(ErrorEvent.ERROR, errorHandler);
			_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, locationChangingHandler);
			_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, locationChangeHandler);
			
			if(_url){
				_stageWebView.loadURL(_url);
			}else if(_text){
				_stageWebView.loadString(_text);
			}
		}
		
		protected function completeHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function locationChangingHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function locationChangeHandler(event:Event):void{
			dispatchEvent(event.clone());
		}
		
		protected function errorHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		
	}
}

