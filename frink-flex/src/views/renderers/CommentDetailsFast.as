package views.renderers
{
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import spark.components.DataGroup;
	import spark.components.LabelItemRenderer;
	import spark.components.supportClasses.StyleableTextField;
	import spark.layouts.BasicLayout;
	import spark.layouts.TileLayout;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
	
	
	/**
	 * 
	 * ASDoc comments for this item renderer class
	 * 
	 */
	public class CommentDetailsFast extends LabelItemRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * notes a data change event occured and the label values are invalid
		 **/
		protected var dataChanged : Boolean = false;
		
		[Bindable]
		protected var expanded : Boolean = true;
		
		[Bindable]
		protected var childComments : ArrayCollection = new ArrayCollection();
		
		protected var oldUnscaledWidth : Number = 0;
		protected var oldUnscaledHeight : Number = 0;
		
		// UI elements
		protected var expandDisplay : StyleableTextField;
		protected var authorDisplay : StyleableTextField;
		protected var pointsDisplay : StyleableTextField;
		protected var dateDisplay : StyleableTextField;
		
		protected var subDisplay : DataGroup;
				
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * constructor
		 **/
		public function CommentDetailsFast()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 *
		 * Override this setter to respond to data changes
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			this.dataChanged = true;
			this.invalidateProperties();
		} 
		
		/**
		 * @protected
		 * 
		 *  Processes the properties set on the component.
		 **/
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (this.dataChanged) {
				this.dataChanged = false;
				
				// 'more' will be used when I implement other ways of showing comments (top, all, etc)
				if (this.data.kind == "more") {
					this.visible = false;
					this.includeInLayout = false;
				} 
				else {
					this.visible = true;
					this.labelDisplay.text = data.data.body;
					this.authorDisplay.text = data.data.author;
					this.pointsDisplay.text = (data.data.ups - data.data.downs) + " points";
					this.dateDisplay.text = FrinkData.instance.getAgoLabel(data.data.created_utc) + " ago";
					
					// bind the child collection of comments
					this.childComments.removeAll();
					if (this.data && this.data.data && this.data.data.replies && this.data.data.replies.data) {
						this.childComments.addAll(new ArrayCollection(data.data.replies.data.children));
					}
				} 
			
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 * 
		 * Override this method to create children for your item renderer 
		 */	
		override protected function createChildren():void
		{
			// BODY
			super.createChildren();
			labelDisplay.setStyle("fontSize", 14);
			labelDisplay.wordWrap = true;
			labelDisplay.multiline = true;
						
			// create any additional children for your item renderer here
			
			// EXPAND
			if (!expandDisplay) {
				expandDisplay = new StyleableTextField();
				expandDisplay.styleName = this;
				expandDisplay.editable = false;
				expandDisplay.selectable = false;
				expandDisplay.multiline = false;
				expandDisplay.wordWrap = false;
				expandDisplay.setStyle("fontSize", 12);
				expandDisplay.setStyle("fontWeight", "bold");
				expandDisplay.setStyle("color", 0x336699);
				expandDisplay.text = "[ - ]";
				expandDisplay.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void {
					expanded = !expanded;
					expandDisplay.text = expanded ? "[ - ]" : "[ + ]";
					invalidateSize();
					invalidateProperties();
				});
				addChild(expandDisplay);
			}
			
			// AUTHOR
			if (!authorDisplay) {
				authorDisplay = new StyleableTextField();
				authorDisplay.styleName = this;
				authorDisplay.editable = false;
				authorDisplay.selectable = false;
				authorDisplay.multiline = false;
				authorDisplay.wordWrap = false;
				authorDisplay.setStyle("fontSize", 12);
				authorDisplay.setStyle("fontWeight", "bold");
				authorDisplay.setStyle("color", 0x336699);
				addChild(authorDisplay);
			}
			
			// POINTS
			if (!pointsDisplay) {
				pointsDisplay = new StyleableTextField();
				pointsDisplay.styleName = this;
				pointsDisplay.editable = false;
				pointsDisplay.selectable = false;
				pointsDisplay.multiline = false;
				pointsDisplay.wordWrap = false;
				pointsDisplay.setStyle("fontSize", 12);
				pointsDisplay.setStyle("color", 0x888888);
				addChild(pointsDisplay);
			}
			
			// DATE
			if (!dateDisplay) {
				dateDisplay = new StyleableTextField();
				dateDisplay.styleName = this;
				dateDisplay.editable = false;
				dateDisplay.selectable = false;
				dateDisplay.multiline = false;
				dateDisplay.wordWrap = false;
				dateDisplay.setStyle("fontSize", 12);
				dateDisplay.setStyle("color", 0x888888);
				addChild(dateDisplay);
			}
			
			// SUB
			subDisplay = new DataGroup();
			subDisplay.dataProvider = this.childComments;
			subDisplay.itemRenderer = new ClassFactory(CommentDetailsFast);
			
			var layout : VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			subDisplay.layout = layout;
			
			addChild(subDisplay);
		}
		
		/**
		 * @private
		 * 
		 * Override this method to change how the item renderer 
		 * sizes itself. For performance reasons, do not call 
		 * super.measure() unless you need to.
		 */ 
		override protected function measure():void
		{
			// no need to use the super.measure() because we're doing it all in this method
			//super.measure();
			
			this.measuredWidth = 0;
			this.measuredMinWidth = 0;
			this.measuredHeight = 0;
			this.measuredMinHeight = 0;
			
			// get all of the padding and gap styles
			var horizontalPadding:Number = getStyle("paddingLeft") + getStyle("paddingRight");
			var verticalPadding:Number = getStyle("paddingTop") + getStyle("paddingBottom");
			var horizontalGap : Number = getStyle("horizontalGap");
			var verticalGap : Number = getStyle("verticalGap");
			
			// the top line contains the expand control, author label, point label, and date label
			var topBarWidth : Number = getElementPreferredWidth(expandDisplay) + horizontalGap + 
				getElementPreferredWidth(authorDisplay) + horizontalGap +
				getElementPreferredWidth(pointsDisplay) + horizontalGap +
				getElementPreferredWidth(dateDisplay);
			
			// top bar height is the measured height of the tallest element
			var topBarHeight : Number = Math.max(getElementPreferredHeight(expandDisplay),
					getElementPreferredHeight(authorDisplay),
					getElementPreferredHeight(pointsDisplay),
					getElementPreferredHeight(dateDisplay));
			
			var subWidth : Number = getElementPreferredWidth(subDisplay);
			var subHeight : Number = getElementPreferredHeight(subDisplay);
			
			// set the UIComponent properties to define component width and height
			if (this.expanded) {
				// this is expanded, so it includes all of the components in size calculations
				this.measuredWidth = Math.max(labelDisplay.textWidth, topBarWidth, subWidth) + horizontalPadding;
				this.measuredHeight = getElementPreferredHeight(labelDisplay) + verticalGap + topBarHeight + verticalGap +
					subHeight + verticalPadding;
			} else {
				// collapsed view only shows the top bar
				this.measuredWidth = topBarWidth + horizontalPadding;
				this.measuredHeight = topBarHeight + verticalPadding;
			}
		}
		
		/**
		 * @private
		 * 
		 * Override this method to change how the background is drawn for 
		 * item renderer.  For performance reasons, do not call 
		 * super.drawBackground() if you do not need to.
		 */
		override protected function drawBackground(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			//super.drawBackground(unscaledWidth, unscaledHeight);
			// do any drawing for the background of the item renderer here    
			
			// draw a line on the right
			this.graphics.lineStyle(2, 0x00000);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, unscaledHeight);
			
			this.graphics.beginFill(Math.random() * 0xFFFFFF);
		}
		
		/**
		 * @private
		 *  
		 * Positions children within the item renderer
		 */
		override protected function layoutContents(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			// no need to use the super.layoutContents method, we roll our own
			//super.layoutContents(unscaledWidth, unscaledHeight);
			
			// grab padding and gap measurements from the style
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var verticalAlign:String = getStyle("verticalAlign");
			var verticalGap:Number   = getStyle("verticalGap");
			
			// define the size of the viewPort minus padding
			var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
			var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;
			
			// start with the top bar elements
			var currentX : Number = paddingLeft;
			var currentY : Number = paddingTop;
			
			// EXPAND
			expandDisplay.commitStyles();
			var expandWidth : Number = getElementPreferredWidth(expandDisplay);
			var expandHeight : Number = getElementPreferredHeight(expandDisplay);
			setElementPosition(expandDisplay, currentX, currentY)
			currentX += (expandWidth + horizontalGap);
			
			// AUTHOR
			authorDisplay.commitStyles();
			var authorWidth : Number = getElementPreferredWidth(authorDisplay);
			var authorHeight : Number = getElementPreferredHeight(authorDisplay);
			setElementPosition(authorDisplay, currentX, currentY);
			currentX += (authorWidth + horizontalGap);
			
			// POINTS
			pointsDisplay.commitStyles();
			var pointsWidth : Number = getElementPreferredWidth(pointsDisplay);
			var pointsHeight : Number = getElementPreferredHeight(pointsDisplay);
			setElementPosition(pointsDisplay, currentX, currentY);
			currentX += (pointsWidth + horizontalGap);
			
			// DATE
			dateDisplay.commitStyles();
			var dateWidth : Number = getElementPreferredWidth(dateDisplay);
			var dateHeight : Number = getElementPreferredHeight(dateDisplay);
			setElementPosition(dateDisplay, currentX, currentY);
			
			// done with the top bar, scan down to the body line
			currentX = paddingLeft;
			currentY += (Math.max(expandHeight, authorHeight, pointsHeight, dateHeight) + (verticalGap*2)); 
			
			
			// BODY
			labelDisplay.commitStyles();
			
			var bodyWidth : Number = viewWidth;
			var oldPreferredBodyHeight:Number = getElementPreferredHeight(labelDisplay);
			oldUnscaledWidth = unscaledWidth;
			setElementSize(labelDisplay, labelDisplay.textWidth, labelDisplay.textHeight);
			
			var newPreferredBodyHeight:Number = getElementPreferredHeight(labelDisplay);
			if (oldPreferredBodyHeight != newPreferredBodyHeight)
				invalidateSize();
			var bodyHeight : Number = newPreferredBodyHeight;
			
			setElementPosition(labelDisplay, currentX, currentY);
						
			labelDisplay.includeInLayout = expanded;
			labelDisplay.visible = expanded;
			
			currentY += (bodyHeight + verticalGap);
			
			// SUB COMMENTS
			var subWidth : Number = getElementPreferredWidth(subDisplay);
			var subHeight : Number = getElementPreferredHeight(subDisplay);
			setElementPosition(subDisplay, currentX, currentY);
			subDisplay.includeInLayout = expanded && this.childComments.length > 0;
			subDisplay.visible = expanded && this.childComments.length > 0;
		}
	}
}