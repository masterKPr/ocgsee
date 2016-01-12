package com.application.ocgsee.themes
{
	import com.application.ocgsee.views.ResultListView;
	import com.application.ocgsee.views.SearchView;
	import com.application.ocgsee.views.ShowCard;
	
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	public class OcgseeTheme extends MetalWorksMobileTheme
	{
		public function OcgseeTheme(scaleToDPI:Boolean=true)
		{
			super(scaleToDPI);
		}
		protected override function initializeStyleProviders():void{
			super.initializeStyleProviders();
			this.getStyleProviderForClass(SearchView).defaultStyleFunction=setSearchViewStyles;
			this.getStyleProviderForClass(ResultListView).defaultStyleFunction=setResultViewStyles;
			this.getStyleProviderForClass(ShowCard).defaultStyleFunction=setShowCardStyles;
		}
		
		private function setShowCardStyles(view:ShowCard):void
		{
			var viewLayout:HorizontalLayout = new HorizontalLayout();
			viewLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			viewLayout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			viewLayout.gap=10;
			viewLayout.paddingLeft=0;
			viewLayout.paddingRight=0;
			viewLayout.paddingTop=0;
			viewLayout.paddingBottom=0;
			view.layout=viewLayout;
			
			var labelLayout:HorizontalLayout = new HorizontalLayout();
			labelLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			labelLayout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_TOP;
			labelLayout.paddingLeft=1;
			labelLayout.paddingRight=1;
			labelLayout.paddingTop=1;
			labelLayout.paddingBottom=1;
			view.labelContent.layout=labelLayout;
			
			var btnLayout:VerticalLayout=new VerticalLayout();
			view.btnContent.layout=btnLayout;
			
			
		}
		
		private function setResultViewStyles(view:ResultListView):void
		{
			var listLayoutData:AnchorLayoutData=new AnchorLayoutData(50,10,10,10,0,0);
			view.resultList.layoutData=listLayoutData;
			var headLayoutData:AnchorLayoutData=new AnchorLayoutData(15,15,NaN,15);
			headLayoutData.horizontalCenter=0;
			view.labelContent.layoutData=headLayoutData;
			
			var headLayout:HorizontalLayout=new HorizontalLayout();
			headLayout.horizontalAlign=HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			view.labelContent.layout=headLayout;
			
			var viewLayout:AnchorLayout=new AnchorLayout();
			view.layout=viewLayout;
			
		}
		private function setSearchViewStyles(view:SearchView):void{
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign=VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap=10;
			layout.padding=10;
			view.layout=layout;
		}
	}
}