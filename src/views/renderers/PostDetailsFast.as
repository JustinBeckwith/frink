package views.renderers {
	import spark.components.IconItemRenderer;
	import spark.components.supportClasses.StyleableTextField;

	public class PostDetailsFast extends IconItemRenderer {
		
		public function PostDetailsFast() {
			super();
		}
		
		protected var dataChanged : Boolean = false;
		
		protected var oldUnscaledWidth : int = 0;
		//protected var oldPreferredTitleHeight : int = 0;
		
		public var titleDisplay : StyleableTextField;
		public var domainLabelDisplay : StyleableTextField;
		public var subredditLabelDisplay: StyleableTextField;
		public var scoreLabelDisplay : StyleableTextField;
		
		
		override protected function createChildren():void {
			
			super.createChildren();
						
			// TITLE
			if (!titleDisplay) {
				titleDisplay = new StyleableTextField();
				titleDisplay.styleName = this;
				titleDisplay.editable = false;
				titleDisplay.selectable = false;
				titleDisplay.multiline = true;
				titleDisplay.wordWrap = true;
				addChild(titleDisplay);
			}
			
			// use a function on the icon to ensure it gets created
			this.iconFunction = function(data:Object) : String {
				if (data && data.data && data.data.thumbnail && data.data.thumbnail !='') {
					// sometimes thumbnail returns a relative system path from reddit.com/static/something.png
					if ((data.data.thumbnail as String).indexOf("/static/") == 0)
						return "http://www.reddit.com" + data.data.thumbnail;
					
					return data.data.thumbnail;
				} 
				return '';
			}
		}
		
		
		override public function styleChanged(styleName:String):void {
			super.styleChanged(styleName);
			
			if (titleDisplay)
				titleDisplay.styleChanged(styleName);
		}
		
		
		override public function set data(value:Object):void {
			super.data = value;
			this.dataChanged = false;
			this.invalidateProperties();			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (this.dataChanged) {
				this.dataChanged = false;
				
				this.titleDisplay.text = data.data.title;
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		// Override measure() to calculate the size required by the item renderer.
		override protected function measure():void {
			
			// start them at 0, then go through icon, label, and decorator
			// and add to these
			var myMeasuredWidth:Number = 0;
			var myMeasuredHeight:Number = 0;
			var myMeasuredMinWidth:Number = 0;
			var myMeasuredMinHeight:Number = 0;
			
			// calculate padding and horizontal gap
			// verticalGap is already handled above when there's a label
			// and a title since that's the only place verticalGap matters.
			// if we handled verticalGap here, it might add it to the icon if 
			// the icon was the tallest item.
			var numHorizontalSections:int = 0;
			if (iconDisplay)
				numHorizontalSections++;
			
			if (decoratorDisplay)
				numHorizontalSections++;
			
			// if titleDisplay
			numHorizontalSections++;
			
			var paddingAndGapWidth:Number = getStyle("paddingLeft") + getStyle("paddingRight");
			if (numHorizontalSections > 0)
				paddingAndGapWidth += (getStyle("horizontalGap") * (numHorizontalSections - 1));
			
			var verticalGap:Number = getStyle("verticalGap");
			var paddingHeight:Number = getStyle("paddingTop") + getStyle("paddingBottom");
			
			// Icon is on left
			
			var myIconWidth:Number = 0;
			var myIconHeight:Number = 0;
			if (iconDisplay)
			{
				this.iconDisplay.source = data.data.thumbnail;
				this.iconDisplay.visible = data && data.data && data.data.thumbnail && data.data.thumbnail !='';
				
				myIconWidth = (isNaN(iconWidth) ? getElementPreferredWidth(iconDisplay) : iconWidth);
				myIconHeight = (isNaN(iconHeight) ? getElementPreferredHeight(iconDisplay) : iconHeight);
				
				myMeasuredWidth += myIconWidth;
				myMeasuredMinWidth += myIconWidth;
				myMeasuredHeight = Math.max(myMeasuredHeight, myIconHeight);
				myMeasuredMinHeight = Math.max(myMeasuredMinHeight, myIconHeight);
			}
			
			// Decorator is up next
			var decoratorWidth:Number = 0;
			var decoratorHeight:Number = 0;
			
			if (decoratorDisplay)
			{
				decoratorWidth = getElementPreferredWidth(decoratorDisplay);
				decoratorHeight = getElementPreferredHeight(decoratorDisplay);
				
				myMeasuredWidth += decoratorWidth;
				myMeasuredMinWidth += decoratorWidth;
				myMeasuredHeight = Math.max(myMeasuredHeight, decoratorHeight);
				myMeasuredMinHeight = Math.max(myMeasuredHeight, decoratorHeight);
			}
			
			// Text is aligned next to icon
			var titleWidth:Number = 0;
			var titleHeight:Number = 0;
			
			
			var titleDisplayEstimatedWidth:Number = 640 - paddingAndGapWidth - myIconWidth - decoratorWidth;
			setElementSize(titleDisplay, titleDisplayEstimatedWidth, NaN);
				
			titleWidth = getElementPreferredWidth(titleDisplay);
			titleHeight = getElementPreferredHeight(titleDisplay);
			
			
			myMeasuredWidth += Math.max(titleWidth);
			myMeasuredHeight = Math.max(myMeasuredHeight, titleHeight + verticalGap);
			
			myMeasuredWidth += paddingAndGapWidth;
			myMeasuredMinWidth += paddingAndGapWidth;
			
			// verticalGap handled in label and title
			myMeasuredHeight += paddingHeight;
			myMeasuredMinHeight += paddingHeight;
			
			// now set the local variables to the member variables.
			measuredWidth = myMeasuredWidth
			measuredHeight = myMeasuredHeight;
			
			measuredMinWidth = myMeasuredMinWidth;
			measuredMinHeight = myMeasuredMinHeight;
		}
		
		override protected function layoutContents(unscaledWidth:Number,
												   unscaledHeight:Number):void
		{
			// no need to call super.layoutContents() since we're changing how it happens here
			
			// start laying out our children now
			var iconWidth:Number = 0;
			var iconHeight:Number = 0;
			var decoratorWidth:Number = 0;
			var decoratorHeight:Number = 0;
			
			var hasLabel:Boolean = labelDisplay && labelDisplay.text != "";
			var hastitle:Boolean = titleDisplay && titleDisplay.text != "";
			
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var verticalAlign:String = getStyle("verticalAlign");
			var verticalGap:Number   = (hasLabel && hastitle) ? getStyle("verticalGap") : 0;
			
			var vAlign:Number;
			if (verticalAlign == "top")
				vAlign = 0;
			else if (verticalAlign == "bottom")
				vAlign = 1;
			else // if (verticalAlign == "middle")
				vAlign = 0.5;
			// made "middle" last even though it's most likely so it is the default and if someone 
			// types "center", then it will still vertically center itself.
			
			var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
			var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;
			
			// icon is on the left
			if (iconDisplay)
			{
				// set the icon's position and size
				setElementSize(iconDisplay, this.iconWidth, this.iconHeight);
				
				iconWidth = iconDisplay.getLayoutBoundsWidth();
				iconHeight = iconDisplay.getLayoutBoundsHeight();
				
				// use vAlign to position the icon.
				var iconDisplayY:Number = Math.round(vAlign * (viewHeight - iconHeight)) + paddingTop;
				setElementPosition(iconDisplay, paddingLeft, iconDisplayY);
			}
			
			// decorator is aligned next to icon
			if (decoratorDisplay)
			{
				decoratorWidth = getElementPreferredWidth(decoratorDisplay);
				decoratorHeight = getElementPreferredHeight(decoratorDisplay);
				
				setElementSize(decoratorDisplay, decoratorWidth, decoratorHeight);
				
				// decorator is always right aligned, vertically centered
				var decoratorY:Number = Math.round(0.5 * (viewHeight - decoratorHeight)) + paddingTop;
				setElementPosition(decoratorDisplay, unscaledWidth - paddingRight - decoratorWidth, decoratorY);
			}
			
			// Figure out how much space we have for label and title as well as the 
			// starting left position
			var labelComponentsViewWidth:Number = viewWidth - iconWidth - decoratorWidth;
			
			// don't forget the extra gap padding if these elements exist
			if (iconDisplay)
				labelComponentsViewWidth -= horizontalGap;
			if (decoratorDisplay)
				labelComponentsViewWidth -= horizontalGap;
			
			var labelComponentsX:Number = paddingLeft;
			if (iconDisplay)
				labelComponentsX += iconWidth + horizontalGap;
			
			// calculte the natural height for the label
			var labelTextHeight:Number = 0;
			
			if (hastitle)
			{
				// commit styles to make sure it uses updated look
				titleDisplay.commitStyles();
			}
			
			// now size and position the elements, 3 different configurations we care about:
			// 1) label and title
			// 2) label only
			// 3) title only
			
			// label display goes on top
			// title display goes below
			
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var titleWidth:Number = 0;
			var titleHeight:Number = 0;
			
			if (hasLabel)
			{
				// handle labelDisplay.  it can only be 1 line
				
				// width of label takes up rest of space
				// height only takes up what it needs so we can properly place the title
				// and make sure verticalAlign is operating on a correct value.
				labelWidth = Math.max(labelComponentsViewWidth, 0);
				labelHeight = labelTextHeight;
				
				if (labelWidth == 0)
					setElementSize(labelDisplay, NaN, 0);
				else
					setElementSize(labelDisplay, labelWidth, labelHeight);
				
				// attempt to truncate text
				labelDisplay.truncateToFit();
			}
			
			if (hastitle)
			{
				// handle title...because the text is multi-line, measuring and layout 
				// can be somewhat tricky
				titleWidth = Math.max(labelComponentsViewWidth, 0);
				
				// We get called with unscaledWidth = 0 a few times...
				// rather than deal with this case normally, 
				// we can just special-case it later to do something smarter
				if (titleWidth == 0)
				{
					// if unscaledWidth is 0, we want to make sure titleDisplay is invisible.
					// we could set titleDisplay's width to 0, but that would cause an extra 
					// layout pass because of the text reflow logic.  Because of that, we 
					// can just set its height to 0.
					setElementSize(titleDisplay, NaN, 0);
				}
				else
				{
					// grab old textDisplay height before resizing it
					var oldPreferredtitleHeight:Number = getElementPreferredHeight(titleDisplay);
					
					// keep track of oldUnscaledWidth so we have a good guess as to the width 
					// of the titleDisplay on the next measure() pass
					oldUnscaledWidth = unscaledWidth;
					
					// set the width of titleDisplay to titleWidth.
					// set the height to oldtitleHeight.  If the height's actually wrong, 
					// we'll invalidateSize() and go through this layout pass again anyways
					setElementSize(titleDisplay, titleWidth, oldPreferredtitleHeight);
					
					// grab new titleDisplay height after the titleDisplay has taken its final width
					var newPreferredtitleHeight:Number = getElementPreferredHeight(titleDisplay);
					
					// if the resize caused the titleDisplay's height to change (because of 
					// text reflow), then we need to remeasure ourselves with our new width
					if (oldPreferredtitleHeight != newPreferredtitleHeight)
						invalidateSize();
					
					titleHeight = newPreferredtitleHeight;
				}
			}
			
			// Position the text components now that we know all heights so we can respect verticalAlign style
			var totalHeight:Number = 0;
			var labelComponentsY:Number = 0; 
			
			// Heights used in our alignment calculations.  We only care about the "real" ascent 
			var labelAlignmentHeight:Number = 0; 
			var titleAlignmentHeight:Number = 0; 
			
			if (hasLabel)
				labelAlignmentHeight = getElementPreferredHeight(labelDisplay);
			if (hastitle)
				titleAlignmentHeight = getElementPreferredHeight(titleDisplay);
			
			totalHeight = labelAlignmentHeight + titleAlignmentHeight + verticalGap;          
			labelComponentsY = Math.round(vAlign * (viewHeight - totalHeight)) + paddingTop;
			
			if (labelDisplay)
				setElementPosition(labelDisplay, labelComponentsX, labelComponentsY);
			
			if (titleDisplay)
			{
				var titleY:Number = labelComponentsY + labelAlignmentHeight + verticalGap;
				setElementPosition(titleDisplay, labelComponentsX, titleY);
			}
		}
		
		
		
	}
}