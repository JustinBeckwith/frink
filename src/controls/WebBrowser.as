package controls  {
	
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import mx.core.UIComponent;
	
	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="locationChanging", type="flash.events.LocationChangeEvent")]
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]
	
	/**
	 * A UIComponent wrapper around the StageWebView
	 * To use,
	 *
	 * Loading a URL:
	 * <local:WebView source="http://google.com/" top="5" width="400" height="300"/>
	 *
	 * Loading HTML text (not tested):
	 * <local:WebView content="...html code here..." top="5" width="400" height="300"/>
	 *
	 * Credits: myself and code from Soenke's , http://soenkerohde.com/2010/11/air-mobile-stagewebview-uicomponent/
	 * */
	public class WebBrowser extends UIComponent {
		
		/**
		 * When set to true the source URL will be loaded when it is set. Default is true.
		 * */
		[Bindable]
		public var autoLoad:Boolean = true;
		
		
		public function WebBrowser() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// not sure if this is the place to give it a minimum size
			// if we don't do this without a defined size its 0 x 0
			width = 480;
			height = 300;
		}
		
		/**
		 * When the stage property is available add it to the web view
		 * */
		public function addedToStageHandler(event:Event):void {
			webView.stage = stage;
			invalidateDisplayList();
		}
		
		/**
		 * Load the URL passed in or load the URL specified in the source property
		 * */
		public function load(URL:String = ""):void {
			
			if (URL) {
				webView.loadURL(URL);
				_source = URL;
			}
			else if (source) {
				webView.loadString(source);
			}
			
		}
		
		/**
		 * Load the text passed in
		 * */
		public function loadString(value:String, mimeType:String = "text/html"):void {
			content = value;
			
			webView.loadString(value, mimeType);
			
		}
		
		private var _webView:StageWebView;
		
		/**
		 * @private
		 * */
		public function get webView():StageWebView {
			return _webView;
		}
		
		/**
		 * Stage Web View is a window to the native browser. It accepts a URL location or text.
		 * To pass in a URL set the source property. To set the text set the text property.
		 * */
		[Bindable]
		public function set webView(value:StageWebView):void {
			_webView = value;
		}
		
		private var _source:String;
		
		/**
		 * @private
		 * */
		public function get source():String {
			return _source;
		}
		
		/**
		 * Source URL for stage web view. If autoLoad is set to true then the URL is loaded automatically.
		 * If not use load method to load the source URL
		 * */
		[Bindable]
		public function set source(value:String):void {
			_source = value;
			
			if (webView && autoLoad) {
				webView.loadURL(source);
			}
		}
		
		private var _content:String;
		
		/**
		 * Sets the content of the webview. Default mime type is text/html.
		 * This feature has not been tested.
		 * */
		[Bindable]
		public function set content(value:String):void {
			_content = value;
			
			if (webView) {
				webView.loadString(value, mimeType);
			}
		}
		
		public function get content():String {
			return _content;
		}
		
		private var _mimeType:String = "text/html";
		
		/**
		 * MIME type of the web view content. Default is "text/html"
		 * */
		public function get mimeType():String {
			return _mimeType;
		}
		
		/**
		 * @private
		 */
		public function set mimeType(value:String):void {
			_mimeType = value;
		}
		
		/**
		 * Shows/Hides the web view
		 * */
		public override function set visible(value:Boolean):void {
			super.visible = value;
			webView.stage = value ? stage : null;
		}
		
		/**
		 * Disposes of the webview content
		 * */
		public function dispose():void {
			webView.dispose();
		}
		
		/**
		 * Add event listeners to stage web view events
		 * */
		override protected function createChildren():void {
			super.createChildren();
			
			webView = new StageWebView();
			
			webView.addEventListener(Event.COMPLETE, completeHandler);
			webView.addEventListener(ErrorEvent.ERROR, errorHandler);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, locationChangingHandler);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, locationChangeHandler);
			
			// load URL or text if available
			if (autoLoad && source) {
				webView.loadURL(source);
			} else if (content) {
				webView.loadString(content, mimeType);
			}
		}
		
		/**
		 * Dispatched when the page or web content has been fully loaded
		 * */
		protected function completeHandler(event:Event):void {
			dispatchEvent(event);
		}
		
		/**
		 * Dispatched when the location is about to change
		 * */
		protected function locationChangingHandler(event:Event):void {
			dispatchEvent(event);
		}
		
		/**
		 * Dispatched when the location has changed
		 * */
		protected function locationChangeHandler(event:Event):void {
			dispatchEvent(event);
		}
		
		/**
		 * Dispatched when an error occurs
		 * */
		protected function errorHandler(event:ErrorEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * Draws the object and/or sizes and positions its children.
		 * */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			// because the webview is positioned according to the stage rather than the container
			// the component is apart of we get the adjusted position
			if (webView) {
				var point:Point = localToGlobal(new Point());
				webView.viewPort = new Rectangle(point.x, point.y, unscaledWidth, unscaledHeight);
			}
		}
	}
}

