package
{
	import flash.display.Sprite;
	import qnx.ui.data.DataProvider;
	import qnx.ui.listClasses.List;
	import qnx.ui.listClasses.ListSelectionMode;
	import qnx.ui.listClasses.ScrollDirection;
	
	public class ListSample extends Sprite
	{
		public function ListSample()
		{
			initializeUI();
		}
		
		private function initializeUI():void
		{
			// create an array for objects
			var arrMonth:Array=[];
			
			// add objects with a label property
			arrMonth.push({label: "January"});
			arrMonth.push({label: "February"});
			arrMonth.push({label: "March"});
			arrMonth.push({label: "April"});
			arrMonth.push({label: "May"});
			arrMonth.push({label: "June"});
			arrMonth.push({label: "July"});
			arrMonth.push({label: "August"});
			arrMonth.push({label: "September"});
			arrMonth.push({label: "October"});
			arrMonth.push({label: "November"});
			arrMonth.push({label: "December"});
			
			//create a new list
			var myList:List = new List();
			
			// set the position of x and y
			myList.setPosition(100, 200);
			
			// set the width
			myList.width = 400;
			
			// set the height
			myList.height = 100;
			myList.columnWidth = 100;
			
			myList.selectionMode = ListSelectionMode.MULTIPLE;
			myList.scrollDirection = ScrollDirection.HORIZONTAL;
			
			myList.dataProvider = new DataProvider(arrMonth);
			
			//add the list to the display list
			this.addChild(myList);
		} 
	}
}