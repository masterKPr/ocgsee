package com.application.ocgsee.views
{
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	
	public class DeckView extends ScrollContainer
	{

		public var mainList:List;

		public var sideList:List;

		public var exList:List;
		public function DeckView()
		{
			super();
			create();
		}
		
		private function create():void
		{
			mainList=new List();
			this.addChild(mainList);
			sideList=new List();
			this.addChild(sideList);
			exList=new List();
			this.addChild(exList);
			

		}
	}
}