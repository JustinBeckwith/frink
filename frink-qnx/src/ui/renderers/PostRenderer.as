package ui.renderers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import qnx.ui.buttons.CheckBox;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	import qnx.ui.listClasses.AlternatingCellRenderer;
	import qnx.ui.text.Label;
	
	
	public class PostRenderer extends AlternatingCellRenderer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// UI ELEMENTS
		protected var pnlMain : Container;
		protected var pnlData : Container;
		protected var pnlScore : Container;
		
		protected var lblTitle : Label;
		protected var img : Image;
		protected var lblDomain : Label;
		protected var lblScore : Label;
		protected var lblSubReddit : Label;
		protected var lblAuthor : Label;
		protected var lblAgo : Label;
		protected var lblNumComments : Label;
		
		/**
		 * perform render here (lame sauce, it expects a 'label' property?)
		 **/
		override public function set data(value:Object):void {
			super.data = value.data;
			if (value.data) {
				//lblTitle.text = this.data.title;
				//lblDomain.text = this.data.domain;
				lblScore.text = this.data.score;
				lblAuthor.text = this.data.author;
				lblSubReddit.text = this.data.subreddit;
				lblNumComments.text = this.data.num_comments;
				lblAgo.text = this.getAgoLabel(this.data.created_utc);
				
				if (this.data.thumbnail && this.data.thumbnail != '') {
					// sometimes thumbnail returns a relative system path from reddit.com/static/something.png
					if ((this.data.thumbnail as String).indexOf("/static/") == 0)
						this.data.thumbnail = "http://www.reddit.com" + this.data.thumbnail;
					this.img.setImage(this.data.thumbnail);
				}
				
				//this.invalidate();
				//pnlMain.layout();
				//pnlData.layout();
				
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructors
		//
		//--------------------------------------------------------------------------
		
		public function PostRenderer()
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
		 * get the label for the amount of time that has passed since the given utc time in milliseconds
		 **/
		protected function getAgoLabel(created_utc : Number) : String {
			
			var currentTimeTicks : Number = (new Date()).getTime();
			var minutesAgoCreated : Number = (currentTimeTicks - (created_utc*1000))/1000/60;
			var agoLabel : String = "";
			if (minutesAgoCreated > 60) {
				agoLabel = Math.round(minutesAgoCreated/60) + " Hours";
			} else {
				agoLabel = Math.round(minutesAgoCreated) + " Minutes";
			} // end else
			
			return agoLabel;
		}
		
		/**
		 * create UI for renderer
		 **/
		protected function initUI():void 
		{
	
			this.size = 100;
			this.sizeUnit = SizeUnit.PERCENT;
				
			// pnlMain
			pnlMain = new Container();
			pnlMain.flow = ContainerFlow.HORIZONTAL;
			pnlMain.size = 100;
			pnlMain.sizeUnit = SizeUnit.PERCENT;
			
			// thumbnail
			img = new Image();
			
			// pnlData
			pnlData = new Container();
			pnlData.flow = ContainerFlow.VERTICAL;
			pnlData.size = 100;
			pnlData.sizeUnit = SizeUnit.PERCENT;
			
			// title
			lblTitle = new Label();
			lblTitle.autoSize = TextFieldAutoSize.LEFT;
			lblTitle.text = "this is a test of";
			//lblTitle.wordWrap = true;
			//lblTitle.multiline = true;
			pnlData.addChild(lblTitle);
			
			// domain
			lblDomain = new Label();
			lblDomain.text = "the emergency broadcast system";
			lblDomain.autoSize = TextFieldAutoSize.LEFT;
			//pnlData.addChild(lblDomain);
			
			// use a container for score, domain, and author
			pnlScore = new Container();
			pnlScore.debugColor = 0xFF0000;
			
			// score
			lblScore = new Label();
			lblScore.format.color = 0xFF0000;
			pnlScore.addChild(lblScore);
			//pnlData.addChild(pnlScore);
			
			// subreddit
			lblSubReddit = new Label();
			pnlScore.addChild(lblSubReddit);
			
			// author
			lblAuthor = new Label();
			pnlScore.addChild(lblAuthor);
			
			// ago
			lblAgo = new Label();
			//pnlData.addChild(lblAgo);
			
			// num comments
			lblNumComments = new Label();
			//pnlData.addChild(lblNumComments);
			
			//pnlData.addChild(pnlScore);
			
			// add the core item
			pnlMain.addChild(img);
			pnlMain.addChild(pnlData);
			this.addChild(pnlMain);
			//this.addChild(pnlData);
			
			
		
		}
		
	}
}