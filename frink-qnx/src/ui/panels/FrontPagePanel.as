package ui.panels
{
	import events.RedditEvent;
	
	import mx.collections.ArrayList;
	
	import qnx.ui.core.SizeUnit;
	import qnx.ui.data.DataProvider;
	import qnx.ui.events.ScrollEvent;
	import qnx.ui.listClasses.List;
	
	import ui.renderers.PostRenderer;

	public class FrontPagePanel extends FrinkPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		protected var posts : List;
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function FrontPagePanel()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * initialize ui elements
		 **/
		protected override function initUI() : void {
			
			super.initUI();
			this.debugColor = 0xFFFF33;	
			
			FrinkData.instance.api.addEventListener(RedditEvent.POSTS_LOADED, postsLoadedHandler);
				
			posts = new List();
			posts.size = 100;
			posts.columnWidth = 420;
			posts.sizeUnit = SizeUnit.PERCENT;
			posts.setSkin(PostRenderer);
			posts.addEventListener(ScrollEvent.SCROLL_END, scrollEndHandler);
			this.addChild(posts);
			
		}
		
		/**
		 * reload post data every time this thing is shown again
		 **/
		public override function showUI() : void {
			super.showUI();
			FrinkData.instance.api.loadPosts();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * postsLoadedHandler
		 **/
		protected function postsLoadedHandler(e : RedditEvent) : void {
			posts.dataProvider = new DataProvider(e.result.data.children as Array);
		}
		
		/**
		 * scrollEndHandler
		 **/
		protected function scrollEndHandler(e : ScrollEvent) : void {
			
		}
	}
}