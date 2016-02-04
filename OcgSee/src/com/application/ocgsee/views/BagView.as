package com.application.ocgsee.views
{
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.ScrollContainer;
	import feathers.skins.IStyleProvider;
	
	
	public class BagView extends ScrollContainer
	{
		
		public var resultList:List;
		
		public var labelContent:ScrollContainer;
		
		public var label:Label;
		
		
		public function BagView()
		{
			super();
			create();

		}
		public static var globalStyleProvider:IStyleProvider;
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}
		private function create():void
		{
			
			resultList=new List();
			
			label=new Label();
			label.height=38;
			labelContent=new ScrollContainer();
			labelContent.addChild(label);
			labelContent.horizontalScrollPolicy=Panel.SCROLL_POLICY_ON;
			
			
			this.addChild(labelContent);
			this.addChild(resultList);
			
//			var a:WebView=new WebView();
//			this.addChild(a);
//			a.width=ApplicationFacade._.root.stage.fullScreenWidth;
//			a.height=ApplicationFacade._.root.stage.fullScreenHeight;
//			a.loadURL("http://www.ourocg.cn/Cards/View-3507");
			

			
			this.verticalScrollPolicy = Panel.SCROLL_POLICY_OFF;
			this.horizontalScrollPolicy=Panel.SCROLL_POLICY_OFF;
			
		}
		
	}
}